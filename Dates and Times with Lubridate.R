## DATES AND TIMES WITH LUBRIDATE

library(tidyverse)
library(lubridate) 
library(nycflights13)

## CREATING DATES AND TIMES
today()
now()

## From Strings
ymd("2017-01-31")
mdy("January 31st, 2017")
dmy("31-Jan-2017")
ymd(20170131) 
ymd_hms("2017-01-31 20:11:59") 
mdy_hm("01/31/2017 08:01")
ymd(20170131, tz = "UTC") 
ymd(20170131, tz = "UTC") 
dmy("It's the 1st of June, 2020")

## From Individual components
flights %>%  
  select(year, month, day, hour, minute) 
flights %>%  
  select(year, month, day, hour, minute) %>%  
  mutate(departure = make_datetime(year, month, day, hour, minute))
make_datetime_100 <- function(year, month, day, time) {make_datetime(year, month, day, time %/% 100, time %% 100)}
flights_dt <- flights %>%  
  filter(!is.na(dep_time), !is.na(arr_time)) %>%
  mutate(dep_time = make_datetime_100(year, month, day, dep_time), arr_time = make_datetime_100(year, month, day, arr_time), sched_dep_time = make_datetime_100(year, month, day, sched_dep_time), sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)) %>%  
  select(origin, dest, ends_with("delay"), ends_with("time"))
flights_dt
flights  
flights_dt %>%  
  ggplot(aes(dep_time)) +  geom_freqpoly(binwidth = 86400) # 86400 seconds = 1 day
flights_dt %>%  
  filter(dep_time < ymd(20130102)) %>%  
  ggplot(aes(dep_time)) +  geom_freqpoly(binwidth = 600) # 600 s = 10 minutes

## From Other Types
as_datetime(today())
as_date(now())
as_datetime(60 * 60 * 10) 

## Exercise
ymd(c("2010-10-10", "bananas")) 
## sends a warning message
d1 <- "January 1, 2010" 
d2 <- "2015-Mar-07" 
d3 <- "06-Jun-2017" 
d4 <- c("August 19 (2015)", "July 1 (2015)") 
d5 <- "12/30/14" # Dec 30, 2014
mdy(d1)
ymd(d2)
dmy(d3)
mdy(d4)
mdy(d5)

## DATE-TIME COMPONENTS

# Getting components
datetime <- ymd_hms("2016-07-08 12:34:56")
year(datetime) 
month(datetime) ## month's day
mday(datetime)
day(datetime)
hour(datetime)
minute(datetime)
second(datetime)
yday(datetime) ## the year's day
wday(datetime) ## weekday
month(datetime, label = TRUE) ## setting label to TRUE outputs it alphabetical value
wday(datetime, label = TRUE, abbr = FALSE)
flights_dt %>%  
  mutate(wday = wday(dep_time, label = TRUE)) %>%  
  ggplot(aes(x = wday)) + geom_bar()
flights_dt %>%  
  mutate(minute = minute(dep_time)) %>%  
  group_by(minute) %>%  
  summarize(avg_delay = mean(arr_delay, na.rm = TRUE), n = n()) %>%  
  ggplot(aes(minute, avg_delay)) + geom_line()
sched_dep <- flights_dt %>%  
  mutate(minute = minute(sched_dep_time)) %>%  
  group_by(minute) %>%  
  summarize(avg_delay = mean(arr_delay, na.rm = TRUE), n = n())
ggplot(sched_dep, aes(minute, avg_delay)) +  geom_line()
ggplot(sched_dep, aes(minute, n)) +  geom_line()

# ROUNDING
flights_dt %>%  
  count(week = floor_date(dep_time, "week")) %>%  
  ggplot(aes(week, n)) + geom_line()
floor_date(ymd(20101010), "week")
ceiling_date(ymd(20101010), "week")

# SETTING COMPONENTS
(datetime <- ymd_hms("2016-07-08 12:34:56")) 
year(datetime) <- 2020 
month(datetime) <- 6
day(datetime) <- 1
hour(datetime) <- 13
minute(datetime) <- 03
second(datetime) <- 34
datetime
## Alternatively,
update(datetime, year = 2020, month = 2, mday = 2, hour = 2) 
ymd("2015-02-01") %>%  
  update(mday = 30) ## if the values are too big, they will roll over
ymd("2015-02-01") %>%
  update(hour = 400)
flights_dt %>%  
  mutate(dep_hour = update(dep_time, yday = 1)) %>%  
  ggplot(aes(dep_hour)) + geom_freqpoly(binwidth = 300)
flights_dt

## Exercise
flights_dt %>%
  mutate(dep_hour = update(dep_time, yday = 1), month = factor(month(dep_time, label = TRUE))) %>%
  ggplot(aes(x = dep_hour, color = month)) + geom_freqpoly(binwidth = 3600)
flights_dt %>%
  mutate(wday1 = wday(dep_time, label = TRUE, abbr = FALSE)) %>%
  group_by(wday1) %>%
  summarize(mean = mean(dep_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = wday1, y = mean)) + geom_bar(stat = "identity")
flights_dt %>%
  mutate(wday1 = wday(dep_time, label = TRUE, abbr = FALSE)) %>%
  group_by(wday1) %>%
  summarize(mean = mean(arr_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = wday1, y = mean)) + geom_bar(stat = "identity")
## It would be saturday because that is the day with the least delay on average

## Both have more numbers at whole numbers
ggplot(diamonds, aes(carat)) + geom_histogram(binwidth = 0.05)
ggplot(flights, aes(sched_dep_time)) + geom_histogram(binwidth = 1)

print(flights_dt, width = Inf)
## The difference between arr_time and dep_time is supposed to be air_time which is measured in minutes. However,
## due to time zone changes, the air_time is greater or lesser than the difference

## TIME SPAN

# Durations: It is used to represent seconds
h_age <- today() - ymd(19791014) 
h_age
as.duration(h_age) 
dseconds(15) 
dminutes(10)
dhours(c(12,24))
ddays(0:5) 
dweeks(3) 
dyears(1)
2 * dyears(1) 
dyears(1) + dweeks(12) + dhours(15) ## Addition
tomorrow <- today() + ddays(1) ## Substraction
last_year <- today() - dyears(1)
one_pm <- ymd_hms("2016-03-12 13:00:00",  tz = "America/New_York" )
one_pm
one_pm + ddays(1)

# Periods: It is used to represent weeks and months
one_pm  
one_pm + days(1) 
seconds(15)
minutes(10)
hours(c(12,24))
days(7)
months(1:6) 
weeks(3)
years(1) 

10 * (months(6) + days(1)) 
days(50) + hours(25) + minutes(2) 
ymd("2016-01-01") + dyears(1)
ymd("2016-01-01") + years(1) ## It fixes the problem of duration
one_pm + ddays(1)
one_pm + days(1)

flights_dt %>%  
  filter(arr_time < dep_time)
flights_dt <- flights_dt %>%
  mutate(overnight = arr_time < dep_time, arr_time = arr_time + days(overnight * 1), sched_arr_time = sched_arr_time + days(overnight * 1))
flights_dt %>%  
  filter(overnight, arr_time < dep_time) 

# Intervals: It used to represent a starting and ending point
years(1)/days(1)
next_year <- today() + years(1) 
(today() %--% next_year) / ddays(1) 
(today() %--% next_year) %/% days(1)

## Exercise
# There is no dmonths() because months vary
# overnight works in a binary way of 1 or 0. Thus, if TRUE, it will be 1 and if FALSE, it will be 0
date_15 <- c("2015-01-01", "2015-02-01", "2015-03-01", "2015-04-01", "2015-05-01", "2015-06-01", "2015-07-01", "2015-08-01", "2015-09-01", "2015-10-01", "2015-11-01", "2015-12-01")
date_20 <- ymd(date_15) + years(5); date_20

hypotenuse <- function(x,y) {
  z <- x^2 + y^2
  print(z)
}
hypotenuse(3,4)
birthdate <- function(time) {
   time1 <- ymd(time)
  birthd <- ymd(19980608)
  if ((month(birthday) > month(time)) & (day(birthday) > day(time)) {
    return year(time) - year(birthday) - 1
  } else {
    return year(time) - year(birthday)
  }
}
birthdate <- function(time) {
  time1 <- ymd(time)
  birthd <- ymd(19980608)
  if ((month(birthd) >= month(time1)) & (day(birthd) > day(time1))) {
    yw <- year(time1) - year(birthd) - 1
  } else {
    yw <- year(time1) - year(birthd)
  }
  yw
}
birthdate(20200608)

## TIME ZONES

Sys.timezone()
OlsonNames() ## Complete list of time zones
length(OlsonNames()) 
head(OlsonNames()) 
(x1 <- ymd_hms("2015-06-01 12:00:00", tz = "America/New_York")) # This is used to decide which time zone should be associated with the time
(x2 <- ymd_hms("2015-06-01 18:00:00", tz = "Europe/Copenhagen")) #
(x3 <- ymd_hms("2015-06-02 04:00:00", tz = "Pacific/Auckland")) 
x1 - x2 
x1 - x3 
x4 <- c(x1, x2, x3);x4 
x4a <- with_tz(x4, tzone = "Australia/Lord_Howe");x4a # with_tz converts the time to the respective timezones
x4a - x4
x4b <- force_tz(x4, tzone = "Australia/Lord_Howe");x4b # force_tz changing the timezone without actually changing the time
x4b - x4
