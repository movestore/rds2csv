library('move2')
library('lubridate')
library("sf")

# data <- readRDS("./data/raw/input1_move2loc_LatLon.rds")
rFunction = function(data, timezoneUTC=T, crsLonLat=T) {
  options(digits.secs=3)
  data.save <- data ## so the data that is passed on from this app does not have the changed timezone and projection
  
  if(timezoneUTC){
    if(tz(mt_time(data.save))=="UTC"){
      logger.info("The timestamps of your data are already in UTC.")
    }else{
    logger.info(paste0("The timestamps of your data have been transformed from timezone: ",tz(mt_time(data.save)),", to UTC."))
    mt_time(data.save) <- with_tz(mt_time(data.save),tzone="UTC")
  }
  }
  if(!timezoneUTC){logger.info(paste0("The timestamps of your data are already in: ",tz(mt_time(data.save)),"."))}
  if(crsLonLat){
    if(st_crs(data.save)[[1]]=="EPSG:4326"){
      logger.info("Your data is already in the geographic coordinate system (lon/lat) 'EPSG:4326'.")
    }else{
    logger.info(paste0("Your data have been reprojected from: ",st_crs(data.save)[[1]],", to the geographic coordinate system (lon/lat) 'EPSG:4326'."))
    data.save <- st_transform(data.save,crs="EPSG:4326")
    }
  }
  if(!crsLonLat){logger.info(paste0("The projection of your data is: ",st_crs(data.save)[[1]],"."))}
  
  ## steps to convert move2 into data frame without loosing info
  data.save <- mt_as_event_attribute(data.save, names(mt_track_data(data.save))) ## puts all the track attributes in the event attribute table
  data.save <- dplyr::mutate(data.save, coords_x=sf::st_coordinates(data.save)[,1],
                        coords_y=sf::st_coordinates(data.save)[,2]) ## creates columns for coordinates
  data.csv <- data.frame(sf::st_drop_geometry(data.save)) # removes the sf geometry column from the table
  
  data.csv.nona <- data.csv[,!sapply(data.csv, function(x) all(is.na(x)))]
  infos.pr <-c(mt_track_id_column(data.save),mt_time_column(data.save),"coords_x","coords_y")
  infos.pr.ix <- which(names(data.csv.nona) %in% infos.pr)
  data.csv.nona.pr <- data.frame(data.csv.nona[,infos.pr],data.csv.nona[,-infos.pr.ix])
  data.csv.nona.pr[,2] <- format(data.csv.nona.pr[,2],format="%Y-%m-%d %H:%M:%OS") # if milliseconds are 0, than as.POSIXct removes them. Here it ensures that if there are miliseconds present, they are taken, and if there are none, .000 is added ==> request from Sarah for correct Movebank/EnvDATA input format -- adding milliseconds
 
  write.csv(data.csv.nona.pr, file = appArtifactPath("data.csv"),row.names=FALSE)
  
  
 
  # data.csv <- as.data.frame(data)
  # data.csv.nona <- data.csv[,!sapply(data.csv, function(x) all(is.na(x)))]
  # 
  # infos.pr <-c("track","timestamp","location.long","location.lat")
  # infos.pr.ix <- which(names(data.csv.nona) %in% c("track","timestamp","location.long","location.lat"))
  # if (length(infos.pr.ix)>0) data.csv.nona.pr <- data.frame(data.csv.nona[,infos.pr],data.csv.nona[,-infos.pr.ix]) else data.csv.nona.pr <- data.csv.nona
  # data.csv.nona.pr$timestamp <- paste(as.character(ymd_hms(data.csv.nona.pr$timestamp)),"000",sep=".") #request from Sarah for correct Movebank/EnvDATA input format
  # 
  # if (track_add==TRUE) 
  # {
  #   data.csv.nona.p <- merge(data.csv.nona.pr,mt_track_data(data),by="track") #is `track` always available and the key?
  #   names(data.csv.nona.p) <- make.names(names(data.csv.nona.p),allow_=FALSE) #make.names maybe not wanted?
  #   
  #   logger.info("The track information data is merged to the table of locations and will be returned as one integrated csv.")
  #   write.csv(data.csv.nona.p, file = appArtifactPath("data_and_trackInfo.csv"),row.names=FALSE)
  # } else
  # {
  #   data.csv.nona.p <- data.csv.nona.pr
  #   track.info <- mt_track_data(data)
  #   names(data.csv.nona.p) <- make.names(names(data.csv.nona.p),allow_=FALSE) 
  #   names(track.info) <- make.names(names(track.info),allow_=FALSE)
  #   
  #   logger.info("The track info and the locations table will be returned as two separate csv files.")
  #   write.csv(data.csv.nona.p, file = appArtifactPath("data.csv"),row.names=FALSE)
  #   write.csv(track.info, file = appArtifactPath("trackInfo.csv"),row.names=FALSE)
  # }
  # 
  # #observation here: `animalName` is actually the name of the track and `track` is the name of the animal...
  # 
  result <- data
  return(result)
}
