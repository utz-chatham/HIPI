##### Set up the basics. If you are on a PC, it may be that the only thing you need to adjust below is the user name for the working directory. 

technician <- 'Ryan Utz' # Put your name here.

userName <- 'rutz' # Put your computer's name here.

studentOrProf <- 'prof' # type here "student" or "prof" depending on who you are.

fileName <- '5G106743 26May25-1108' # Place the file name here. No need for the extension. 

##### 

##### Import and clean up the data. 

if (studentOrProf == 'prof') {
setwd(paste("C:/Users/", userName, "/OneDrive - Chatham University/NSFEmbrace/dataFiles", sep='')) 
  }

if (studentOrProf == 'student'){
  setwd(paste("C:/Users/", userName, "/Chatham University/Jill Riddell - NSFEmbrace/dataFiles", sep=''))
}

d <- readxl::read_excel(paste(fileName,'.xls', sep=''), skip=2) # There are two useless lines that the data recorder includes, which explains the "skip=" argument. 

d <- d[,1:2] # Kick out the data portals that don't have any information.

colnames(d) <- c('dateTime', 'pulse') # Rename the column headers.

d$dateTime <- as.POSIXct(d$dateTime) # Teach R that this is a date/time column. This seems to come in the right way automatically, but just in case we have this line.

d$precip.mm <- d$pulse * 0.01 * 25.4 # 0.1 inches of precipitation / pulse; 25.4 mm of water / inch.

d$date <- as.Date(d$dateTime) # Create a field that is just the date.

#####

##### Integrate the new data into the master rainfall data file + send the new file into the archive folder.

dAll <- read.csv('mainPrecip.csv') # Read in the master precipitation file.

dAll$dateTime <- as.POSIXct(dAll$dateTime, format = '%Y-%m-%d %H:%M:%S') # Format the dates / times in the above so R recognizes them for what they are. 

dAll$date <- as.Date(dAll$date, format = '%Y-%m-%d') # Format the dates in the above so R recognizes them for what they are. 

dAll <- rbind(dAll, d) # Bind the two data frames. 

dupRows <- which(duplicated(dAll)) # Identify which, if any, rows are duplicated. 

if (length(dupRows) != 0) {
  print(paste('Heads up: there are', length(dupRows), 'duplicate rows in master precipitation data frame. This is not a problem if you downloaded previously archived readings. These will be removed before archiving the new data.' ))
  
  dAll <- dAll[-dupRows, ] # Remove these duplicate rows.
}

write.csv(dAll, 'mainPrecip.csv', row.names = F) # Overwrite the master precipitation data file with the formerly archived + new data. Removing the row names is important here! These are useless integers R automatically puts into every data frame.

file.rename(paste(fileName,'.xls',sep=''), paste(getwd(),'/archivedPrecip/',paste(fileName,'.xls',sep=''),sep='')) # This takes the file that was just integrated into the master file and plunks it into the archive file. 

# Archiving the data collection:

archiveLine <- data.frame(name=technician, file=fileName, date=Sys.Date()) 

archives <- read.delim('historyPrecip.txt', sep = " ") # Pull in the data records.

archives <- rbind(archives, archiveLine) # Bind the new one with the old one.
 
write.table(archiveLine, 'historyPrecip.txt', row.names=F) # Write the updated archives.

#

#####

##### (optional) Plot the data 

# Daily plot

library(ggplot2)

dDailyPrecip <- data.frame(aggregate(data=dAll, precip.mm~date, sum))

ggplot(dDailyPrecip, aes(x=date, y=precip.mm) )+
  geom_col(color='black', fill='gray80')+
  labs(x='Date', y='Total precipitation, mm')+
  scale_y_continuous(expand=c(0,0))+
  theme_classic()

#####
