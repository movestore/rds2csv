library('move')

rFunction <- function(data)
{
  Sys.setenv(tz="GMT")
  
  data.csv <- as.data.frame(data)
  data.csv.nona <- data.csv[,!sapply(data.csv, function(x) all(is.na(x)))] 
  write.csv(data.csv.nona, file = paste0(Sys.getenv(x = "APP_ARTIFACTS_DIR", "/tmp/"),"data.csv"),row.names=FALSE)
  
  result <- data
  return(result)
}

  
  
  
  
  
  
  
  
  
  
