# Filename: inst_extdata.R (06/30/2016)

# TO DO: prepare data for the RQGIS package

# Author(s): Jannes Muenchow

#**********************************************************
# CONTENTS-------------------------------------------------
#**********************************************************

# 1. ATTACH PACKAGES AND DATA
# 2. VECTOR
# 3. RASTER
# 4. TABLES

#**********************************************************
# 1 ATTACH PACKAGES AND DATA-------------------------------
#**********************************************************

# attach packages
library("dplyr")
library("rgdal")
library("raster")
library("RODBC")
library("sp")
library("sf")

# define directories
dir_main = paste0("D:/uni/science/projects/ecology/latin_america/peru/lomas/",
                   "Daten/")
dir_dat = paste0(dir_main, "R data/Mongon/")
dir_aster = paste0(dir_main, "GIS/ASTER_original/ASTER_Casma/ASTGTM_S10W079/")
dir_db = paste0("D:/uni/science/projects/ecology/latin_america/peru/lomas/", 
                "Daten/Aufnahme/")

# load data
channel = odbcConnectAccess2007(paste0(dir_db, "Casma.accdb"))
sqlTables(channel)
spa = sqlFetch(channel, "spatial", as.is = TRUE)
spe = sqlFetch(channel, "Arten-Plot-Kreuztabelle", as.is = TRUE)
close(channel)

# load study mask
mask = read_sf(paste0(dir_dat, "shapes"), layer = "mask")

# load raster
# r = raster(paste0(dir_aster, "ASTGTM_S10W079_dem.tif"))
# r = projectRaster(r, crs = proj4string(spa)) 
# dem = r
# resolution from the raster I have used: 
# paste0("D:/uni/science/projects/ecology/latin_america/peru/lomas/Daten/", 
#        "R data/Mongon/grids/dem.asc")
dem = raster(paste0(dir_dat, "grids/dem.asc"))
ndvi = raster(paste0(dir_dat, "grids/ndvi.asc"))


#**********************************************************
# 2 VECTOR-------------------------------------------------
#**********************************************************

coordinates(spa) =~ x + y
proj4string(spa) = paste0("+proj=utm +zone=17 +south +datum=WGS84 +units=m",
                          " +no_defs +ellps=WGS84 +towgs84=0,0,0")
# spa@data = dplyr::select(spa@data, pnr, no, dem, cslope, carea, ndvi)
spa@data = dplyr::select(spa@data, pnr, no)
data.table::setnames(spa@data, c("pnr", "no"), c("id", "spri"))
# spa@data[, c("x", "y")] = sp::coordinates(spa)
# shp_2 = spTransform(shp, proj4string(r))
# writeOGR(spa, "D:/programming/R/RQGIS/RQGIS/inst/extdata", "random_points",
#          driver = "ESRI Shapefile", overwrite_layer = TRUE)
random_points = st_as_sf(spa)
devtools::use_data(random_points, overwrite = TRUE)

study_area = dplyr::select(mask, name)
devtools::use_data(study_area, overwrite = TRUE)

#**********************************************************
# 3 RASTER-------------------------------------------------
#**********************************************************

# make the bounding box a bit bigger
# ok, let's find the centroid of the bounding box
x = sum(bbox(spa)[1, ]) / 2
y = sum(bbox(spa)[2, ]) / 2
# now build a bbox
x = c(x - 1800, x + 1800)
y = c(y - 1800, y + 1800)
b_box = expand.grid(x, y)
names(b_box) = c("x", "y")
dem = trim(crop(r, extent(b_box)))

ndvi = trim(crop(ndvi, extent(b_box)))
ndvi = resample(ndvi, dem)
plot(dem)
points(spa)

# export
# writeRaster(dem, filename = "D:/programming/R/RQGIS/RQGIS/inst/extdata/dem.asc", 
#             format = "ascii", prj = TRUE, overwrite = TRUE)

devtools::use_data(dem, overwrite = TRUE)
devtools::use_data(ndvi, overwrite = TRUE)

#**********************************************************
# 4 TABLES-------------------------------------------------
#**********************************************************

spe[] = lapply(spe, as.numeric)
spe[is.na(spe)] = 0
rownames(spe) = spe$pnr
spe = dplyr::select(spe, -pnr)
# community data, a site-by-species matrix (sbsm), site-by-species cross-table
# (broadly known as contingency table in statistics), in terms of data science
# its a wide table format
comm = spe
devtools::use_data(comm, overwrite = TRUE)
