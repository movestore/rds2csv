library('move')

rFunction <- function(data)
{
  Sys.setenv(tz="UTC")
  
  data.csv <- as.data.frame(data)
  data.csv$timestamp <- data@timestamps ## ensuring that the correct timestamps are in this column. Note that there is mostly a timestamp, and timestamps column, the latter is actually the correct one. If data are downloaded from movebank, both contain the same informatiion.
  data.csv.nona <- data.csv[,!sapply(data.csv, function(x) all(is.na(x)))]
  
  names(data.csv.nona) <- make.names(names(data.csv.nona),allow_=FALSE)
  
  infos.pr <-c("trackId","timestamp",attributes(data@coords)$dimnames[[2]]) # column names of coords are nor always called the same. This ensures that always the correct name is taken
  
  infos.pr.ix <- which(names(data.csv.nona) %in% infos.pr)
  data.csv.nona.pr <- data.frame(data.csv.nona[,infos.pr],data.csv.nona[,-infos.pr.ix])
    
  write.csv(data.csv.nona.pr, file = paste0(Sys.getenv(x = "APP_ARTIFACTS_DIR", "/tmp/"),"data.csv"),row.names=FALSE)
  #write.csv(data.csv.nona.pr, file = "data.csv",row.names=FALSE)
  
  result <- data
  return(result)
}

  
  
  
  
  
  
  
  
  
  
