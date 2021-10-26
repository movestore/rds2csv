library('move')

rFunction <- function(data)
{
  Sys.setenv(tz="UTC")
  
  data.csv <- as.data.frame(data)
  data.csv.nona <- data.csv[,!sapply(data.csv, function(x) all(is.na(x)))]
  
  names(data.csv.nona) <- make.names(names(data.csv.nona),allow_=FALSE)
  
  infos.pr <-c("trackId","timestamp","location.long","location.lat")
  infos.pr.ix <- which(names(data.csv.nona) %in% c("trackId","timestamp","location.long","location.lat"))
  data.csv.nona.pr <- data.frame(data.csv.nona[,infos.pr],data.csv.nona[,-infos.pr.ix])
    
  write.csv(data.csv.nona.pr, file = paste0(Sys.getenv(x = "APP_ARTIFACTS_DIR", "/tmp/"),"data.csv"),row.names=FALSE)
  #write.csv(data.csv.nona.pr, file = "data.csv",row.names=FALSE)
  
  result <- data
  return(result)
}

  
  
  
  
  
  
  
  
  
  
