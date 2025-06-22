##### Set up the basics. If you are on a PC, it may be that the only thing you need to adjust below is the user name for the working directory. 

technician <- 'Ryan Utz' # Put your name here.

userName <- 'utzry' # Put your computer's name here.

studentOrProf <- 'prof' # type here "student" or "prof" depending on who you are.

##### Import and clean up the data. 

if (studentOrProf == 'prof') {
  setwd(paste("C:/Users/", userName, "/OneDrive - Chatham University/NSFEmbrace/dataFiles", sep='')) 
}

if (studentOrProf == 'student'){
  setwd(paste("C:/Users/", userName, "/Chatham University/Jill Riddell - NSFEmbrace/dataFiles", sep=''))
}

files <- list.files('./newMoisture/') # List all of the moisture files.

# Function that imports all of the above and puts it into one data frame:

getAll <- function (file){
  
  temp <- read.csv(paste('./newMoisture/',file, sep='')) # Reads in the file.
  
  colnames(temp)[2:4] <- c('dateTime','waterContent.m3m3','temp.C') # Renames column headers.
  
  temp$dateTime <- as.POSIXct(temp$dateTime, format = '%m/%d/%Y %H:%M:%S') # Formats to date and time. 
  
  temp$site <- sub("^([0-9]+).*", "\\1", file) # Gets all of the digits before the first space.
  
  nameCol <- which(colnames(temp) == 'site') # Sometimes the file includes battery data, sometimes not. So, we need to find the column number where the site is for the line below.
  
  temp <- temp [,c(nameCol,2:4)] # Re-arrange to get site first, then date/time, then moisture and temperature.
  
  return(temp)
}

allData <- do.call(rbind, lapply(files, getAll)) # Put all of the data together in allData.

write.csv(allData, 'mainMoisture.csv')


