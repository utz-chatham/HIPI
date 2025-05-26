##### Set the working directory. If you are on a PC, it may be that the only thing you need to adjust below is the user name. 

userName <- 'utzry' 

setwd(paste("C:/Users/", userName, "/OneDrive - Chatham University/NSFEmbrace/dataFiles", sep=''))

#####

##### Import and clean up the data.

fileName <- 'test' # Place the file name here. No need for the extension. 

d <- readxl::read_excel(paste(fileName,'.xls', sep=''), skip=2) # There are two useless lines that the data recorder includes, which explains the "skip=" argument. 

d <- d[,1:2] # Kick out the data portals that don't have any information.

colnames(d) <- c('dateTime', 'pulse') # Rename the column headers.

d$dateTime <- as.POSIXct(d$dateTime) # Teach R that this is a date/time column. This seems to come in the right way automatically, but just in case we have this line.

d$precip.mm <- d$pulse * 0.01 * 25.4 # 0.1 inches of precipitation / pulse; 25.4 mm of water / inch.

d$date <- as.Date(d$dateTime) # Create a field that is just the date.

#####

##### Integrate the new data into the master rainfall data file

dAll <- read.csv('mainPrecip.csv')

dAll$dateTime <- as.POSIXct(dAll$dateTime, format = '%m/%d/%Y %H:%M')

dAll$date <- as.Date(dAll$date, format = '%m/%d/%Y')

dAll <- rbind(dAll, d)

dAll[(duplicated(dAll)),]


##### Plot the data 

# Daily plot

library(ggplot2)

dDailyPrecip <- data.frame(aggregate(data=d, precip.mm~date, sum))

ggplot(dDailyPrecip, aes(x=date, y=precip.mm) )+
  geom_col(color='black', fill='gray80')+
  labs(x='Date', y='Total precipitation, mm')+
  scale_y_continuous(expand=c(0,0))+
  theme_classic()

#####
