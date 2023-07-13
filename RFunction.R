library('move2')
library('lubridate')

rFunction = function(data, track_add=TRUE, ...) {

  data.csv <- as.data.frame(data)
  data.csv.nona <- data.csv[,!sapply(data.csv, function(x) all(is.na(x)))]

  infos.pr <-c("track","timestamp","location.long","location.lat")
  infos.pr.ix <- which(names(data.csv.nona) %in% c("track","timestamp","location.long","location.lat"))
  if (length(infos.pr.ix)>0) data.csv.nona.pr <- data.frame(data.csv.nona[,infos.pr],data.csv.nona[,-infos.pr.ix]) else data.csv.nona.pr <- data.csv.nona
  data.csv.nona.pr$timestamp <- paste(as.character(ymd_hms(data.csv.nona.pr$timestamp)),"000",sep=".") #request from Sarah for correct Movebank/EnvDATA input format
  
  if (track_add==TRUE) 
  {
    data.csv.nona.p <- merge(data.csv.nona.pr,mt_track_data(data),by="track") #is `track` always available and the key?
    names(data.csv.nona.p) <- make.names(names(data.csv.nona.p),allow_=FALSE) #make.names maybe not wanted?
    
    logger.info("The track information data is merged to the table of locations and will be returned as one integrated csv.")
    write.csv(data.csv.nona.p, file = appArtifactPath("data_and_trackInfo.csv"),row.names=FALSE)
  } else
  {
    data.csv.nona.p <- data.csv.nona.pr
    track.info <- mt_track_data(data)
    names(data.csv.nona.p) <- make.names(names(data.csv.nona.p),allow_=FALSE) 
    names(track.info) <- make.names(names(track.info),allow_=FALSE)
    
    logger.info("The track info and the locations table will be returned as two separate csv files.")
    write.csv(data.csv.nona.p, file = appArtifactPath("data.csv"),row.names=FALSE)
    write.csv(track.info, file = appArtifactPath("trackInfo.csv"),row.names=FALSE)
  }
  
  #observation here: `animalName` is actually the name of the track and `track` is the name of the animal...
  
  result <- data
  return(result)
}
