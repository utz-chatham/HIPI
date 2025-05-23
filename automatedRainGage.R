##### Set the working directory. If you are on a PC, it may be that the only thing you need to adjust below is the user name. 

userName <- 'utzry' 

setwd(paste("C:/Users/", userName, "/OneDrive - Chatham University/NSFEmbrace/HIPIStudents2025", sep=''))

#####

##### Import and clean up the data.

fileName <- '5G106743 12May25-1418' # Place the file name here. No need for the extension. 

d <- readxl::read_excel(paste(fileName,'.xls', sep=''), skip=2) # There are two useless lines that the data recorder includes, which explains the "skip=" argument. 

d <- d[,1:2] # Kick out the data portals that don't have any information.

colnames(d) <- c('dateTime', 'pulse') # Rename the column headers.

d$dateTime <- as.POSIXct(d$dateTime) # Teach R that this is a date/time column. This seems to come in the right way automatically, but just in case we have this line.

d$precip.mm <- d$pulse * 0.01 * 25.4 # 0.1 inches of precip / pulse; 25.4 mm of water / inch.

#####

##### Plot the data 

# Daily plot

library(ggplot2)

d$date <- as.Date(d$dateTime)

dDailyPrecip <- data.frame(aggregate(data=d, precip.mm~date, sum))

ggplot(dDailyPrecip, aes(x=date, y=precip.mm) )+
  geom_col(color='black', fill='gray80')+
  labs(x='Date', y='Total precipitation, mm')+
  scale_y_continuous(expand=c(0,0))+
  theme_classic()

#####
