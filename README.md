# rds 2 csv
MoveApps

Github repository: *github.com/movestore/rds2csv*

## Description
Movement data (in R-format rds) is transformed into a csv-data.frame that is returned as artefakt and can be downloaded. The original data set is also passed on as output to a possible next App. 

## Documentation
The input Movement data set is transformed into a table (data frame) with a row for each location and columns indicating the timestamp, individual, location coordiantes (longitude, latitude) and other properties of the location. For better readability, only properties (columns) with (non-NA) information in at least one row are retained. This table is returned as an artefact named `data.csv`.

### Input data
moveStack in Movebank format

### Output data
moveStack in Movebank format

### Artefacts
`data.csv`: input data set as csv table, including only columns that are not all NA

### Parameters 
no parameters

### Null or error handling:
**Data:** The full input data set is returned for further use in a next App and cannot be empty.