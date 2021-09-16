

#Code to extract pixel values from raster dataset using shapefile.
#load packages
library(rgdal)
library(readOGR)
library(raster)
#loading the shp file.
shp.file <- '/home/Projects/shp/shapeKAR11/VILLAGE_BOUNDARY.shp'
shp.poly <- readOGR(shp.file, stringsAsFactors = F)
#loading raster dataset (here i have used NPP annual data (2016,2017,2018) of MODIS for karnataka area).
npp.dir <- '/home/Projects/Annual_NPP_Data/tif_data'
npp.files <- Sys.glob(sprintf('%s/*.tif', npp.dir))
out.dir <- '/home/Projects/Annual_NPP_Data/NPP_all_village'
#creating a out.df dataframe for output.
n <- length(npp.files)
m <- length(shp.poly)
out.df <- data.frame(matrix(NA, m, n+1))
colnames(out.df) <- c('Village', '2016','2017','2018')
out.df$Village <- c(shp.poly$NAME_11)
for(i in 1:n){
  npp.ras <- raster(npp.files[i])
  plot(npp.ras)
  #Extracting pixel values for each village and usin 'fun = mean' doing mean of it and storing mean value for every village.
  npp.val <- unname(unlist(extract(npp.ras, shp.poly,fun =mean)))
  plot(shp.poly)
  if(length(unique(npp.val)) > 1){
    cname <- colnames(out.df[i+1])
    out.df[cname] <- npp.val
    print(i)
  }
}
#saving output as .csv file
out.bn <- 'npp_16_17_18_KA.csv'
out.file <- file.path(out.dir, out.bn)
write.csv(out.df, out.file,row.names=FALSE)