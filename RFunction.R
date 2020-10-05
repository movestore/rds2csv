library('move')

rFunction <- function(data)
{
  Sys.setenv(tz="GMT")
  
  data.csv <- as.data.frame(data)
  data.csv.nona <- data.csv[,!sapply(data.csv, function(x) all(is.na(x)))] 
  write.csv(data.csv.nona,"data.csv",row.names=FALSE)
  
  result <- data
  return(result)
}

  
  
  
  
  
  
  
  
  
  