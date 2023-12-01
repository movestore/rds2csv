# Write CSV
MoveApps

Github repository: *github.com/movestore/rds2csv*

## Description
Movement data are transformed into a table in csv format and provided as an artefact for download. The original moveStack is also passed on as output for use by a subsequent App. 

## Documentation
The input Movement dataset (a moveStack object in R's rds format) is transformed into a table (data frame) with a row for each location and columns indicating the timestamp, individual, location coordinates (longitude, latitude) and other properties of each event record. For better readability, only properties (columns) with (non-NA) information in at least one row are retained. This table is returned as an artefact named `data.csv`.

### Input data
moveStack in Movebank format

### Output data
moveStack in Movebank format

### Artefacts
`data.csv`: input data set as csv table, including only columns that are not all NA

### Settings
no settings

### Null or error handling:
**Data:** The full input data set is returned for further use in a next App and cannot be empty.
