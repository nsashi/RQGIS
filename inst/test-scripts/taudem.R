# How to install TauDEM:
# Complete installer:
# http://hydrology.usu.edu/taudem/taudem5/downloads2.html
# installs GDAL, Microsoft MPI, Microsoft Visual C++
# in QGIS:
# processing > options > providers > tauDEM:
# MPICH2/... C:\Program Files\Microsoft HPC Pack 2012\Bin
# TauDEM ... C:\Program Files\TauDEM\TauDEM5Exe

library("RQGIS")
library("raster")
data(dem)
writeRaster(dem, "C:/Users/pi37pat/Desktop/dem.tif", format = "GTiff",
            overwrite = TRUE)
qgis_env <- set_env("C:/OSGeo4W64/")


get_usage("taudem:d8flowdirections", qgis_env = qgis_env)
params <- get_args_man("taudem:d8flowdirections", qgis_env = qgis_env)
params$`-fel` <- "C:/Users/pi37pat/Desktop/dem.tif"
params$`-p` <- "D:/flow.tif"
params$`-sd8` <- "D:/slope.tif"
run_qgis(alg = "taudem:d8flowdirections", 
         params = params,show_msg = TRUE,
         qgis_env = qgis_env)
# unfortunately, this does not produce any output
# running the code in the Python console works and it tells me, that D:/flow.tif
# and D:/slope.tif were produced (however, in D: there is nothing...)


# how to use TauDEM via the command line
# http://hydrology.usu.edu/taudem/taudem5/TauDEM51CommandLineGuide.pdf
# Raphael Knevel wanted to calculate the D Infinity flow directions
system(paste0("mpiexec D8FlowDir -fel C:/Users/pi37pat/Desktop/dem.tif ", 
              "-p D:/flow.tif -sd8 D:/slope.tif"))
# please note that the TauDem output via R is not the exact same as retrieved 
# when used via QGIS... 
# By the way, TauDEM only worked with C:/OSGeo4W64/ (my D: installations are
# probably only 32-bit installations...)

shQuote("C:\\Program Files\\Microsoft MPI\\Bin\\mpiexec")
