library('move2')
library('lubridate')
library("sf")
library("dplyr")
library("vctrs")
library("purrr")
library("rlang")

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
  
  
  ## checking if there are columns in the track data that are a list. If yes, check if the content is the same, if yes remove list. If list columns are left over because content is different transform these into a character string (could be done as well as json, but think that average user will be more comfortable with text?)
  if(any(sapply(mt_track_data(data.save), is_bare_list))){
    ## reduce all columns were entry is the same to one (so no list anymore)
    data.save <- data.save |> mutate_track_data(across(
      where( ~is_bare_list(.x) && all(purrr::map_lgl(.x, function(y) 1==length(unique(y)) ))), 
      ~do.call(vctrs::vec_c,purrr::map(.x, head,1))))
    if(any(sapply(mt_track_data(data.save), is_bare_list))){
      ## transform those that are still a list into a character string
      data.save <- data.save |> mutate_track_data(across(
        where( ~is_bare_list(.x) && all(purrr::map_lgl(.x, function(y) 1!=length(unique(y)) ))), 
        ~unlist(purrr::map(.x, paste, collapse=","))))
    }
  }
  
  ## only track attributes table -- saving here output at the end 
  track.info <- mt_track_data(data.save)
  
  ## steps to convert move2 into data frame without loosing info
  data.save <- mt_as_event_attribute(data.save, names(mt_track_data(data.save)))
  data.save <- dplyr::mutate(data.save, coords_x=sf::st_coordinates(data.save)[,1],
                        coords_y=sf::st_coordinates(data.save)[,2])
  data.save <- sf::st_drop_geometry(data.save) ## removes the sf geometry column from the table
  sfc_cols.1 <- names(data.save)[unlist(lapply(data.save, inherits, 'sfc'))] ## get the col names that are spacial
  
  for(x in sfc_cols.1){ ## converting the "point" columns into characters, ie into WKT (Well-known text)
    data.save[[x]] <- st_as_text(data.save[[x]])
  } ## st_as_sfc() can be used to convert these columns back to spacial
  
  data.csv <- data.frame(data.save)
  
  data.csv.nona <- data.csv[,!sapply(data.csv, function(x) all(is.na(x)))]
  infos.pr <-c(mt_track_id_column(data.save),mt_time_column(data.save),"coords_x","coords_y")
  infos.pr.ix <- which(names(data.csv.nona) %in% infos.pr)
  data.csv.nona.pr <- data.frame(data.csv.nona[,infos.pr],data.csv.nona[,-infos.pr.ix])
  data.csv.nona.pr[,2] <- format(data.csv.nona.pr[,2],format="%Y-%m-%d %H:%M:%OS3") # if milliseconds are 0, than as.POSIXct removes them. Here it ensures that if there are miliseconds present, they are taken, and if there are none, .000 is added ==> request from Sarah for correct Movebank/EnvDATA input format -- adding milliseconds
  
  write.csv(data.csv.nona.pr, file = appArtifactPath("data.csv"),row.names=FALSE)
  
  
  ## saving only track data table
  ## converting the "point" columns into characters
  sfc_cols.2 <- names(track.info)[unlist(lapply(track.info, inherits, 'sfc'))]
  for(x in sfc_cols.2){
    track.info[[x]] <- st_as_text(track.info[[x]])
  }
  
  track.info.ord <- track.info %>% dplyr::select(mt_track_id_column(data), everything())
  write.csv(track.info.ord, file = appArtifactPath("trackInfo.csv"),row.names=FALSE)
  
  result <- data
  return(result)
}
