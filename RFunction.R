library('move')

rFunction <- function(data)
{
  Sys.setenv(tz="GMT")
  
  data.csv <- as.data.frame(data)
  data.csv.nona <- data.csv[,!sapply(data.csv, function(x) all(is.na(x)))]
  infos.pr <-c("local_identifier","timestamp","location_long","location_lat")
  infos.pr.ix <- which(names(data.csv.nona) %in% c("local_identifier","timestamp","location_long","location_lat"))
  data.csv.nona.pr <- data.frame(data.csv.nona[,infos.pr],data.csv.nona[,-infos.pr.ix])
    
  write.csv(data.csv.nona.pr, file = paste0(Sys.getenv(x = "APP_ARTIFACTS_DIR", "/tmp/"),"data.csv"),row.names=FALSE)
  #write.csv(data.csv.nona.pr, file = "data.csv",row.names=FALSE)
  
  result <- data
  return(result)
}

  
  
  
  
  
  
  
  
  
  
