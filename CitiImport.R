#Data Joining and Sampling Script - HT> Evan
library(dplyr)
samplefrac <- 0.01
Jan <- read.csv("201901-citibike-tripdata.csv")
Jan <- sample_frac(Jan, samplefrac)
Feb <- read.csv("201902-citibike-tripdata.csv")
Feb <- sample_frac(Feb, samplefrac)
Mar <- read.csv("201903-citibike-tripdata.csv")
Mar <- sample_frac(Mar, samplefrac)
Apr <- read.csv("201904-citibike-tripdata.csv")
Apr <- sample_frac(Apr, samplefrac)
May <- read.csv("201905-citibike-tripdata.csv")
May <- sample_frac(May, samplefrac)
Jun <- read.csv("201906-citibike-tripdata.csv")
Jun <- sample_frac(Jun, samplefrac)
Jul <- read.csv("201907-citibike-tripdata.csv")
Jul <- sample_frac(Jul, samplefrac)
Aug <- read.csv("201908-citibike-tripdata.csv")
Aug <- sample_frac(Aug, samplefrac)
Sep <- read.csv("201909-citibike-tripdata.csv")
Sep <- sample_frac(Sep, samplefrac)
Oct <- read.csv("201910-citibike-tripdata.csv")
Oct <- sample_frac(Oct, samplefrac)
Nov <- read.csv("201911-citibike-tripdata.csv")
Nov <- sample_frac(Nov, samplefrac)
Dec <- read.csv("201912-citibike-tripdata.csv")
Dec <- sample_frac(Dec, samplefrac)


#Merging the Dataset (bind function just combines datasets with same columns)
citibike <- rbind(Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec)

rm(Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec)

#Saves it as new CSV to be referenced in the future  
write.csv(citibike, "citibike.csv")
rm(citibike, samplefrac)
# End of File