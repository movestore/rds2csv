# Write CSV

MoveApps

Github repository: *github.com/movestore/rds2csv*

## Description
Movement data (in R-format rds) is transformed into a csv-data.frame that is returned as artefact and can be downloaded. Two files are returned, one containing all data, and one containing only the information associated to the tracks. The original data set is also passed on as output to a possible next App. 

## Documentation
The input Movement data set is transformed into a table (data frame) with a row for each location and columns indicating the timestamp, track ID, location coordiantes (longitude, latitude) and other properties of the locations. For better readability, only properties (columns) with (non-NA/non-empty) information in at least one row are retained. Additionally a table only containing the attributes associated to the tracks (e.g. name, tag, sex, study) is also provided.

The column `timestamp` is formatted to include three decimals in the seconds, so that the format will be fit for submission to annotation with EnvDATA in Movebank.

### Input data
move2::move2_loc 

### Output data
move2::move2_loc 

### Artefacts

`data.csv`: the whole data set as a csv table (including only columns that are not all NA). The first 4 columns contain the information of the track Id, timestamps, and coodinates X and Y of the dataset used for any previous analysis.

`trackInfo.csv`: the information associated to the tracks. This table contains one entry per track. The first column contains the information of the track Id used for any previous analysis.

### Settings 
**`Timezone in UTC` (timezoneUTC):** Check the box to ensure the timestamps are in UTC. If unchecked, the timestamps will be in the timezone of the data (which will be displayed in the logs of the app once it has run).

**`Coordenate system of the data in Lon/Lat (EPSG:4326)` (crsLonLat):** Check the box to ensure the data are in the geographic coordinate system (lon/lat) 'EPSG:4326'. If unchecked, the coordinates will be retained in the current projection (which will be displayed in the logs of the app once it has run).


### Null or error handling
**Data:** The full input data set is returned for further use in a next App and cannot be empty.