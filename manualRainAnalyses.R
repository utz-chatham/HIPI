##### Set up the basics. If you are on a PC, it may be that the only thing you need to adjust below is the user name for the working directory. 

technician <- 'Ryan Utz' # Put your name here.

userName <- 'utzry' # Put your computer's name here.

fileName <- 'manualPrecipIndividualPlants' # Place the file name here. No need for the extension. 

#####

#### Import the data. 

setwd(paste("C:/Users/", userName, "/OneDrive - Chatham University/NSFEmbrace/dataFiles", sep=''))

d <- readxl::read_excel(paste(fileName,'.xlsx', sep='')) # Bring in the manual rain gage data from the master file.

d$dateTime <- as.POSIXct(paste(d$date, substr(d$time, 12, 16)))

d$throughfall_mm <- d$throughfall_in*25.4

d2 <- read.csv('mainPrecip.csv')
