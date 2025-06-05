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
d2$dateTime <- as.POSIXct(d2$dateTime, format='%Y-%m-%d %H:%M:%S')

sites <- unique(d$siteNumber)

for (k in 1:length(sites)){

  temp <- d[d$siteNumber==k,]
  temp$totalPrecip.mm <- NA

  temp$event <- 1:nrow(temp)

  for (i in 2:nrow(temp)){
    start <- temp$dateTime[i-1]
    end <- temp$dateTime[i]
  
    temp2 <- d2[d2$dateTime>start & d2$dateTime<end, ]
  
    temp$totalPrecip.mm[i] <- sum(temp2$precip.mm, na.rm = T)
  }

if (!exists('d3')) {d3 <- temp[0,]}
  
  d3<-rbind(d3,temp)
  remove(temp); remove(temp2)
}


d3 <-d3[d3$event !=3,]
d3<-d3[d3$throughfallProp<1,]

d3$throughfallProp <- d3$throughfall_mm/d3$totalPrecip.mm

require(ggplot2)  

ggplot(d3, aes(y=throughfallProp, x=totalPrecip.mm))+
  geom_point()

ggplot(d3, aes(x=species, y=throughfallProp))+
  geom_boxplot()
