# Write CSV

MoveApps

Github repository: *github.com/movestore/rds2csv*

## Description
Movement data (in R-format rds) is transformed into a csv-data.frame that is returned as artefact and can be downloaded. Either two files (locations and track info) are returned or one file with locations and track info integrated. The original data set is also passed on as output to a possible next App. 

## Documentation
The input Movement data set is transformed into a table (data frame) with a row for each location and columns indicating the timestamp, track ID, location coordiantes (longitude, latitude) and other properties of the locations. Optionally, the track information will be added to this table or provided as a second artefact file. For better readability, only properties (columns) with (non-NA/non-empty) information in at least one row are retained. 

This integrated data and track info is returned as an artefact named `data_and_trackinfo.csv`. In case this is not selected, two artefacts named `data.csv` and `trackInfo.csv` are generated.

The column `timestamp` is reformatted to include three decimals in the seconds, so that the format will be fit for submission to annotation with EnvDATA in Movebank.

### Input data
move2::move2_loc object

### Output data
move2::move2_loc object - same as input data

### Artefacts
depending on the setting below, there are one or two csv artefacts:

`data_and_trackInfo.csv`: the whole data set as a csv table (including only columns that are not all NA) with track information merged to the location data. This introduces quite a lot of dupliation, but might be required in some cases.

`data.csv`: the whole data set as a csv table, including only columns that are not all NA.

`trackInfo.csv`: the track information of the data set as a csv table. Note that the key attribute is called `track`.

### Settings 
**`Merge data and track information` (track_add):** Select if the track information shall be integrated/merged with the location data and written as one csv file (TRUE). Alternatively, two files are provided (FALSE). Default: FALSE.

### Most common errors
please make an issue here if you encounter repeated problems

### Null or error handling
**Data:** The full input data set is returned for further use in a next App and cannot be empty.