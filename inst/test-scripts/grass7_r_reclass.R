library("RQGIS")
library("raster")
data(dem)
open_app()
alg <- "grass7:r.reclass"
get_usage(alg)
lines <- "0 thru 350 = 1\n351 thru 700 = 2\n701 thru 1500 = 3"
writeLines(text = lines, file.path(tempdir(), "classes.txt"))

reclass <- run_qgis(alg, input = dem, 
                    rules = file.path(tempdir(), "classes.txt"),
                    output = "reclass.tif", load_output = TRUE)
