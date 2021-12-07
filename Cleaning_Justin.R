library(tidyverse)
library(janitor)
library(lubridate)
library(geosphere)

citibike <-
    list.files(pattern = "*citibike*") %>%
    map_df(~ read_csv(.))

citibike <- clean_names(citibike)

citibike$X <- NULL
citibike$start_station_id <- as.factor(citibike$start_station_id)
citibike$end_station_id <- as.factor(citibike$end_station_id)
citibike$bikeid <- as.factor(citibike$bikeid)
citibike$usertype <- as.factor(citibike$usertype)
# Fix gender
citibike$gender <- ifelse(citibike$gender == 1, "male", ifelse(citibike$gender == 2, "female", "unknown"))
citibike$gender <- as.factor(citibike$gender)
# Create a column for approximate age
citibike$age <- 2021 - citibike$birth_year


citibike$starthour <- hour(citibike$starttime)
citibike$day <- date(citibike$starttime)
citibike$month <- as.factor(month(citibike$starttime))
citibike$numWeekday <- wday(citibike$starttime)
citibike$dayid <- as.factor(ifelse(citibike$numWeekday < 6, "Weekday", "Weekend"))
citibike$weekNum <- week(citibike$starttime)

citibike$distmeters <- distHaversine(cbind(citibike$start_station_latitude, citibike$start_station_longitude), cbind(citibike$end_station_latitude, citibike$end_station_longitude))
citibike$speed <- citibike$distmeters / citibike$tripduration