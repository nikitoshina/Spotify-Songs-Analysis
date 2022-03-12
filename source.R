str(cleanedComplete)
cleanedComplete = read.csv("Spotify 19252 Tracks.csv")
# Delete disk_number
cleanedComplete = cleanedComplete[,-1]
cleanedComplete$mode = factor(cleanedComplete$mode)
library(lubridate)
# Some the tracks have only year as their date 
# One track is 2049.25 years old, when in fact it is from 2013
cleanedComplete[151,]
cleanedComplete[151, "album.release_date"] = as.character(2013-01-27)

# Get dates
Date = cleanedComplete$album.release_date

# Create a copy of a vector
dates <- Date

# convert all ymd dates
dates = ymd(dates)

# convert all the year format dates (shows up as NA in dates)
dates[is.na(dates)] <- as.Date(paste(as.character(Date[is.na(dates)]), 5, 15, sep = "-"))  
which(is.na(dates))
cleanedComplete$album.release_date = dates

# Convert into numeric 
cleanedComplete$popularity = as.numeric(cleanedComplete$popularity)

# Replace Date with a number of days
cleanedComplete  =  cleanedComplete %>%
  mutate(album.release_date = as.numeric(today()-album.release_date))
colnames(cleanedComplete )[colnames(cleanedComplete ) == "album.release_date"] <- "days_from_release"

# Factor key
cleanedComplete$key = as.factor(cleanedComplete$key)

# Convert into numeric
cleanedComplete$popularity = as.numeric(cleanedComplete$popularity)

# Convert ms into second
cleanedComplete$duration_ms.x = cleanedComplete$duration_ms.x/1000
colnames(cleanedComplete )[colnames(cleanedComplete ) == "duration_ms.x"] <- "duration_sec"

# Adjusted dates 
# cleanedComplete$days_from_release <- cleanedComplete$days_from_release -716

# Create a function
makePlot = function(x,y){
  ggplot(as.data.frame(x), aes_string(x = y, y="popularity"))+
    geom_point(alpha = 0.03)+
    theme_minimal()+
    labs(colour=NULL)+
    theme(legend.position = "none") #removes legends so they do not overwhelm
}

# columns for plotting
cols = c(2,6:17)

# Duration in Seconds
plot.1 = ggplot(cleanedComplete,aes(x = duration_sec , y=popularity))+
  xlim(0,750)+
  geom_point(alpha = 0.01)+
  geom_density2d(alpha = 1)+
  theme_minimal()+
  labs(colour=NULL)+
  theme(legend.position = "none")
  
# Days from release and popularity
plot.2 =  ggplot(as.data.frame(cleanedComplete), aes(x = days_from_release, y=popularity))+
  geom_point(alpha = 0.03)+
  theme_minimal()+
  labs(colour=NULL)+
  theme(legend.position = "none")+
  geom_smooth()+ 
  geom_vline(aes(xintercept=20))+
  geom_hline(aes(yintercept = 37.5))+
  geom_hline(aes(yintercept = 87.5))+
  xlim(0,200)


plot.3 = makePlot(cleanedComplete, names(cleanedComplete)[7])+
  geom_density2d()

table(cleanedComplete[,"mode"])

plot.4 = ggplot(cleanedComplete, aes( x = mode, y = popularity))+
  geom_boxplot(alpha = 0.5)+
  geom_jitter(alpha = 0.01, binaxis = "y", stackdir = "center", fill = T)+
  theme_minimal()+
  theme(legend.position = "none")

# Energy
plot.5 = makePlot(cleanedComplete, names(cleanedComplete)[8])+
    geom_density2d()

# Key
plot.6 = makePlot(cleanedComplete, names(cleanedComplete)[9])+
    geom_boxplot(alpha = 0.4)

# speechiness
plot.7 = makePlot(cleanedComplete, names(cleanedComplete)[12])+
    geom_density2d(alpha = 0.4) +
    geom_vline(aes(xintercept = 0.025))+
    geom_vline(aes(xintercept = 0.055))+
    xlim(0,.5)

# acousticness
plot.8 = makePlot(cleanedComplete, names(cleanedComplete)[13])+
    geom_density2d(alpha = 0.4)

# instrumentalness most of the songs are not instrumental
plot.9 = cleanedComplete%>%
  filter(instrumentalness <= 0.001)%>%
  count()

#instrumentalness
plot.10 = makePlot(cleanedComplete, names(cleanedComplete)[14])+
  xlim(0,0.001)

# liveness
plot.11 = makePlot(cleanedComplete, names(cleanedComplete)[15])+
    geom_density2d()

# valence
plot.12 = makePlot(cleanedComplete, names(cleanedComplete)[16])+
  geom_vline(aes(xintercept = 0.035))+
  geom_density2d()

# tempo
plot.13 = makePlot(cleanedComplete, names(cleanedComplete)[17])+
  geom_density2d()

# loudness
plot.14 = makePlot(cleanedComplete, names(cleanedComplete[10]))+
  geom_density2d()

# install.packages('cowplot')
library(cowplot)

### put all the plots side to side (no plot.9)
plot_grid(plot.1, plot.2, plot.3, plot.4, plot.5, plot.6,
          plot.7, plot.8, plot.10, plot.11, plot.12, plot.13, plot.14)

#### Density graphs
cols = c(2,5:17)
dens = function(b){  
  c = density(cleanedComplete[,names(cleanedComplete)[b]])$x[which.max(density(cleanedComplete[,names(cleanedComplete)[b]])$y)]
  ggplot(cleanedComplete, aes_string(x= names(cleanedComplete)[b]))+
  geom_density()+
    #creates a vlines at the highest y
    geom_vline(aes(xintercept = c))+
    geom_text(aes(x = round(c,2), label = round(c,2) ,y =0), angle = 0, vjust = -0.2, colour = "black")+
    theme_minimal()
}
# Duration
dens.1 = dens(2)+
  xlim(0,750)
#The longest track is Mama, I'm Coming Home by Ozzy Osbourne
cleanedComplete[max(cleanedComplete$duration_sec),]

density(cleanedComplete$duration_sec)

# Popularity
dens.2 = dens(5)

# Days from release
dens.3 = dens(6)

# Danceability
dens.4 = dens(7)

# Energy
dens.5 = dens(8)

# Key ***
dens.6 = ggplot(cleanedComplete,aes(key))+
  geom_bar()+
  theme_minimal()

# Loudness
dens.7 = dens(10)

# Mode ***
dens.8 = ggplot(cleanedComplete, aes(mode))+
  geom_bar()+
  theme_minimal()

# Speechiness
dens.9 = dens(12)

# Acousticness
dens.10 = dens(13)

# instrumentalness ***
dens.11 = dens(14)

# Liveness
dens.12 = dens(15)

# valence
dens.13 = dens(16)

# tempo
dens.14 = dens(17)

plot_grid(dens.1,dens.2,dens.3,dens.4,dens.5,dens.6,dens.7,dens.8,
          dens.9,dens.10,dens.11,dens.12,dens.13,dens.14)

### Heat data for correlation
# Choose numeric data
heat_data <- cleanedComplete[,-c(1,3,4,9,11)]

# Create correlation matrix
cormat <- round(cor(heat_data),2)
head(cormat)

# Melt correlation data
library(reshape2)
melted_cormat <- melt(cormat)
head(melted_cormat)

# Plot
ggplot(melted_cormat, aes(x=Var1,y=Var2,fill=value))+
  geom_tile()+
  geom_text(aes(label = round(value, 3)))+
  scale_fill_gradient(low = "white", high = "red") 

### Lets see only songs that are above 75%
cleanedComplete %>%
  filter(popularity >= 75)%>%
  ggplot( aes(x = days_from_release))+
  geom_bar()+
  xlim(0,2500)

### Lets have a look at the popularity and days from releaes graph again
  makePlot(cleanedComplete, names(cleanedComplete)[6])+
  geom_smooth()+ 
  geom_vline(aes(xintercept=20))+
  geom_hline(aes(yintercept = 37.5))+
  geom_hline(aes(yintercept = 87.5))+
  geom_hline(aes(yintercept = 75))+
  xlim(0,1500)

# we can notice 2 significant breakes, at 37.5 is the lower limit
# everything below that level will not be picked up by the algorithm
# and second is around 75, everything above 75 can be considered popular
# also there is a break around 87.5, above which new popular songs lay
# Because the data is not random as it is provided by the spotifies algorithm
# Using it to predict numeric popularity of a song is impossible. 
# So lets try to devide songs into groups of unpopular, popular, and hits

ratings = cleanedComplete %>%
  select(popularity)%>%
  mutate(popularity = if_else(popularity >=87.5, 4,
                              if_else(popularity <87.5 & popularity >=75, 3, 
                                      if_else(popularity < 75 & popularity >= 37.5,2,
                                              if_else(popularity <37.5, 1, 1)))))
# Check if numbers match
table(ratings)
count(cleanedComplete[cleanedComplete$popularity >= 87.5,])

RatedData = cleanedComplete
RatedData$popularity = factor(ratings$popularity, levels = c(2,1,3,4))

### Now we are dealing with a classification problem
# Manual feature selection
features = c(2,5:13)

# Date partition
set.seed(228)
ind = createDataPartition(RatedData$popularity, times = 1, p = 0.8, list = F)
train_df = RatedData[ind, features]
test_df = RatedData[-ind, features]
# Set predictors and target
names(train_df)
train_X = train_df[, -2]
train_Y = train_df[,"popularity"]

test_x = test_df[, -2]
test_y = test_df[, 2]


# Control
set.seed(228)
my_control <- trainControl(method = 'cv', # for “cross-validation”
                           number = 2, # number of k-folds
                           savePredictions = 'final',
                           allowParallel = TRUE)

# Create method list of algorithms we will be using
method_list = c("rf")

# train
set.seed(228)
#package for making ensembles of caret models
library(caretEnsemble)
model_list = caretList(train_X,
                        train_Y,
                        trControl = my_control,
                        methodList = method_list,
                        tuneList = NULL,
                        continue_on_fail = FALSE, 
                        preProcess = c('center','scale'))
model_list$rf # 90% accuracy not bad, but 
y_pred = predict(model_list$rf, test_x)
df = table(y_pred, test_y)
df[c(2,1,3,4),c(2,1,3,4)]

# puts confusion matrix into txt file
sink(file = "confusion_matrix.txt")
confusionMatrix(y_pred,test_y)
sink(file = NULL)

# The data set in imbalanced, so it looks like the algorith just throws everything into second zone
# Lets use undersampling and see if it works
# Undersampling decreased accuracy to 70% (used 2000,1500,5000 number of observations), didnot increase true positives of very popular songs
# What if we devide data set in very popular and not very popular, will it increase the accuracy?
makePlot(cleanedComplete, names(cleanedComplete)[6])+
  geom_smooth()+ 
  geom_vline(aes(xintercept=15))+
  geom_hline(aes(yintercept = 75))+
  xlim(0,10000)

two_classes = RatedData

levels(two_classes$popularity) = c(1,1,2,2)
table(two_classes$popularity)

RatedData = two_classes # go back to previews algorithm
# awful we get only 4 (2,2) algorithm just throws everything into 1
# Lets apply donwn sampling again, accuract went even lowen and P-value is 1, howabout oversampling?
# trainUS = cbind(train_X, train_Y)
# TrainUS = upSample( x = trainUS[,-ncol(trainUS)],
#                         y = trainUS$train_Y)
# names(TrainUS)[10] <- 'popularity'
# train_X = TrainUS[,-10]
# train_Y = TrainUS[,10]
# UpSampling has a better result but still not even close to being usable
# Tried method ada, did not work