library(spotifyr)
library(tidyverse)

Sys.setenv(SPOTIFY_CLIENT_ID = '20035bb304394937b0f88b4e62a30cbb')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'a1c33498102b4b4f8c91334199f58b84')

access_token = get_spotify_access_token()

# from https://medium.com/@perryjanssen/getting-random-tracks-using-the-spotify-api-61889b0c0c27
# Function to get a random track

get_random_track = function(){
  # Create a search query with a random latter of the alphabet
  # Define characters
  characters = "abcdefghijklmnopqrstuvwxyz"
  # pick a random character
  n = sample(1:26, 1)
  randChar = substring(characters,first = n, last = n)
  # get a random wild card placement 
  randomSearch = ''
  n2 = sample(0:1,1)
  if (n2==1){
    randomSearch = str_c(randChar, '%')
  }else{
    randomSearch = str_c('%', randChar, '%',sep = "",collapse = NULL)
  }
  # Create a random off set
  randOffset = sample(1:1999,1)
  # Get a random song from spotify
  search_spotify(randomSearch, type = "track", offset = randOffset, limit = 1)
}

get_random_track()


### make a Data set
DATA = data.frame()

### Choose number of tracks to add to the Data set
numOfTracks = 1:200
for (i in numOfTracks) {
  newRow = get_random_track()
  DATA = rbind(DATA, newRow)
}

NDATA <- unique(DATA$name)
identical(NDATA,DATA)# Not all of the entries are unique 
# and if we want collect more data we should approach it differently

### Create all the possible entries for api
characters = "abcdefghijklmnopqrstuvwxyz"
chars = strsplit(characters,"")[[1]]

# a%
just_that = str_c(chars, "%")

# %a%
just_this = str_c("%", just_that)

# bind them together
queries = c(just_that, just_this)

# from https://stackoverflow.com/questions/28419281/missing-last-sequence-in-seq-in-r
### function to create indexes
seqlast <- function (from, to, by) 
{
  vec <- do.call(what = seq, args = list(from, to, by))
  if ( tail(vec, 1) != to ) {
    return(c(vec, to))
  } else {
    return(vec)
  }
}

n_of_queries = seqlast(1,1980, by =20)

"100000_Songs" = data.frame()
for (i in queries){
  for (b in n_of_queries){
    d = search_spotify(i, type = "track", offset = b, limit = 20)
    `100000_Songs` = rbind(`100000_Songs`, d)
  }
}
`19337_Songs` = unique(`100000_Songs`)
trackids = `19337_Songs`$id

# Index of last ID in request
indexsofids = seqlast(99,length(trackids),by = 99)

# Index of first IDs in request
startindex = indexsofids+1

# For indexing to work right
startindex = c(1,startindex)
indexsofids = c(1,indexsofids)
# Create a DF for the data
audio_features = data.frame()
for (i in 1:(length(indexsofids)-1)){
  ids = trackids[startindex[i]:indexsofids[i+1]] # get ids of tracks to request
  b = get_track_audio_features(ids) # Make a request
  audio_features = rbind(audio_features, b) # Add the rows together
}

audio_features = unique(audio_features)
# Join it with Tracks infromation by id
Complete_Data_Set = merge(`19337_Songs`,audio_features,by="id")

# columns that we can use
ind = c(4,5,7,9,10,22,30:40)
cleanedComplete = Complete_Data_Set[,ind]

# Save the Data for future use
write.csv(cleanedComplete, file = "Spotify 19252 tracks.csv")

Complete_Data_Set = as.data.frame(Complete_Data_Set[,-c(2,20,16)])
Complete_Data_Set = as.matrix(Complete_Data_Set)
write.csv(Complete_Data_Set, file = "Spotify 19252 tracks Raw.csv")


