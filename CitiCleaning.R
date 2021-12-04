citi <- read.csv("citibike.csv", stringsAsFactors = FALSE)
str(citi)
citi$X <- NULL
citi$start.station.id <- as.factor(citi$start.station.id)
citi$end.station.id <- as.factor(citi$end.station.id)
citi$bikeid <- as.factor(citi$bikeid)
citi$usertype <- as.factor(citi$usertype)
# Fix gender
citi$gender <- ifelse(citi$gender == 1, "male", ifelse(citi$gender == 2, "female", "unknown"))
citi$gender <- as.factor(citi$gender)
# Create a column for approximate age
citi$age <- 2021 - citi$birth.year


library(lubridate)
citi$starttime <- as.POSIXct(strptime(citi$starttime, "%Y-%m-%d %H:%M:%S"))
citi$stoptime <- as.POSIXct(strptime(citi$stoptime, "%Y-%m-%d %H:%M:%S"))
citi$starthour <- hour(citi$starttime)
citi$day <- date(citi$starttime)
citi$month <- as.factor(month(citi$starttime))
citi$numWeekday <- wday(citi$starttime)
citi$dayid <- as.factor(ifelse(citi$numWeekday < 6, "Weekday", "Weekend"))
citi$weekNum <- week(citi$starttime)

library(geosphere)
citi$distmeters <- distHaversine(cbind(citi$start.station.latitude, citi$start.station.longitude), cbind(citi$end.station.latitude, citi$end.station.longitude))
citi$speed <- citi$distmeters / citi$tripduration


library(ggplot2)
citi %>%
  group_by(starthour) %>%
  summarize(
    count = n(),
    dist = mean(distmeters, na.rm = TRUE),
    dur = mean(tripduration, na.rm = TRUE),
    speed = dist / dur
  ) %>%
  ggplot(aes(x = starthour, y = count, fill = count)) +
  geom_col()

citi %>%
  group_by(month) %>%
  summarize(
    count = n(),
    dist = mean(distmeters, na.rm = TRUE),
    dur = mean(tripduration, na.rm = TRUE),
    speed = dist / dur
  ) %>%
  ggplot(aes(x = month, y = count, fill = count)) +
  geom_col()


# Merging Datasets
weather <- read.csv("NYCWeather2019.csv")
weather$STATION <- NULL
weather$NAME <- NULL
weather$DATE <- as.Date(weather$DATE, format = "%m/%d/%Y")
weather$TAVG <- (weather$TMAX + weather$TMIN) / 2



citiday <- citi %>%
  group_by(day, gender, dayid) %>%
  summarize(
    count = n(),
    dist = mean(distmeters, na.rm = TRUE),
    dur = mean(tripduration, na.rm = TRUE),
    speed = dist / dur
  )

combined_gender <- merge(citiday, weather, by.x = "day", by.y = "DATE")

ggplot(combined_gender, aes(x = TAVG, y = count)) +
  geom_point(size = 2, alpha = 0.5, color = "yellowgreen") +
  geom_smooth(color = "darkgreen") +
  facet_wrap(~gender)
ggplot(combined_gender, aes(x = TAVG, y = count)) +
  geom_point(size = 2, alpha = 0.5, color = "yellowgreen") +
  geom_smooth(color = "darkgreen") +
  facet_wrap(~dayid)
ggplot(combined_gender, aes(x = TAVG, y = dist)) +
  geom_point(size = 2, alpha = 0.5, color = "yellowgreen") +
  geom_smooth(color = "darkgreen")
ggplot(combined_gender, aes(x = TAVG, y = speed)) +
  geom_point(size = 2, alpha = 0.5, color = "yellowgreen") +
  geom_smooth(color = "darkgreen")