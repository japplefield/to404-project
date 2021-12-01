library(tidyverse)
library(janitor)
library(lubridate)
library(geosphere)

bike <-
    list.files(pattern = "*citibike*") %>% 
    map_df(~read_csv(., col_types = cols('start station id'='d', 'end station id'='d')))

bike <- clean_names(bike)
bike$usertype <- as.factor(bike$usertype)
bike$gender <- ifelse(bike$gender == 1, "male", ifelse(bike$gender == 2, "female", "unknown"))
bike$gender <- as.factor(bike$gender)

samplefrac <- 0.01
bike <- sample_frac(bike, samplefrac)

bike$startDate <- as.Date(bike$starttime)
bike$stopDate <- as.Date(bike$stoptime)
bike$startMonth <- month(bike$starttime)
bike$stopMonth <- month(bike$stopDate)
bike$startMonthFactor <- as.factor(month(bike$startDate))
bike$stopMonthFactor <- as.factor(month(bike$stopDate))
bike$numWeekday <- as.factor(wday(bike$startDate))
bike$weekNum <- as.numeric(strftime(bike$startDate, format = "%V"))

bike$distMeters <- distHaversine(cbind(bike$start_station_latitude, bike$start_station_longitude), cbind(bike$end_station_latitude, bike$end_station_longitude))

bike$speedMetersperSec <- bike$distMeters / bike$tripduration
bike$age <- 2020 - bike$birth_year

bike$start.station.id <- as.factor(bike$start_station_id)
bike$end.station.id <- as.factor(bike$end_station_id)
bike$bikeid <- as.factor(bike$bikeid)

bike$day <- as.Date(bike$starttime)
bike$dayid <- as.factor(ifelse(as.numeric(bike$numWeekday) < 6, "Weekday", "Weekend"))

weather <- read_csv("NYCWeather2019.csv")
weather$STATION <- NULL
weather$NAME <- NULL
weather$DATE <- as.Date(weather$DATE, format="%m/%d/%Y")
weather$TAVG <- (weather$TMAX + weather$TMIN) / 2
