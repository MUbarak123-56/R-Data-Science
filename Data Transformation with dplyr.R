## DATA TRANSFORMATION WITH DPLYR

## install.packages("nycflights13")
library(nycflights13) 
library(tidyverse) 

flights
View(flights)

## dplyr Basics

## Filter is used to filter rows in a dataset
filter(flights, month == 1, day == 1)
jan1 <- filter(flights, month == 1, day == 1)
dec25 <- filter(flights, month == 12, day == 25)

# comparisons

sqrt(2) ^ 2 == 2 # reports false due to precision error
1/49 * 49 == 1 # reports false due to precision error

# near is a better approach to use
near(sqrt(2)^2,2) 
near(1/49*49, 1)

# Logical operators
filter(flights, month == 11 | month == 12)
nov_dec <- filter(flights, month %in% c(11, 12)) ## rewriting the code above
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120) ## rewriting the code above

# Missing Variables 
NA > 5
NA == 10
NA + 10
# anything associated with NA will output NA
x <- NA
y <- NA
x == y
is.na(x)
df <- tibble(x = c(1,NA,3))
filter(df, is.na(x) | x > 1) ## filtering out NA values

## Exercise
filter(flights, arr_delay >= 120)
filter(flights, dest == 'HOU' | dest == 'IAH')
filter(flights, carrier %in% c('UA', 'AA', 'DL'))
filter(flights, month %in% c(7,8,9))
unique(flights$month)
filter(flights, arr_delay > 120 , dep_delay < 120)
filter(flights, dep_time >= 000 & dep_time <= 600)
filter(flights, (arr_delay > 60 | dep_delay > 60) & (arr_time - dep_time > sched_arr_time - sched_dep_time + 30))
?between
between(1:12, 7, 9)
flights[is.na(flights$dep_time),]

NA^0
NA*0
NA | TRUE
FALSE & NA

## Arrange rows with Arrange()
arrange(flights, year, month, day)
arrange(flights, desc(arr_delay)) ## desc arranges a column descending order
df <- tibble(x = c(5, 2, NA))
# missing values always come last
arrange(df, x)
arrange(df, desc(x))

## Exercise
arrange(flights, desc(is.na(dep_time)))
arrange(flights, desc(arr_delay), desc(dep_delay), dep_time)
arrange(flights, arr_delay, dep_delay)
arrange(flights, desc(air_time))
arrange(flights,air_time)

## SELECT COLUMN WITH SELECT()
select(flights, year, month, day)
select(flights, year:day) ## selecting all the columns between year and day
select(flights, -(year:day)) ## selecting all the columns except those from year to day
select(flights, starts_with('dep'))
select(flights, ends_with('time'))
?select
rename(flights, tail_num = tailnum) ## renaming a column
select(flights, time_hour, air_time, everything()) ## moves time_hour and air_time to the start of the data frame

## Exercise
select(flights, dep_delay, arr_time, dep_time, arr_delay)
select(flights, starts_with('dep'), starts_with('arr'))
var <- c('dep_delay', 'dep_time', 'arr_time', 'arr_delay')
select(flights, one_of(var))
select(flights, year, year)
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))
select(flights, contains("TIME"))

## Add new variables with mutate
flights_sml <- select(flights,  year:day,  ends_with("delay"),  distance,  air_time )
mutate(flights_sml, gain = arr_delay - dep_delay, speed= distance/air_time * 60)
mutate(flights_sml,  gain = arr_delay - dep_delay,  hours = air_time / 60,  gain_per_hour = gain / hours) ## newly created columns can be referred to.
transmute(flights,  gain = arr_delay - dep_delay,  hours = air_time / 60,  gain_per_hour = gain / hours ) ## transmute is used to keep the new columns only.


## Useful creation fucntions
# Modular arithmetic
transmute(flights,  dep_time,  hour = dep_time %/% 100,  minute = dep_time %% 100) 
# Offsets
(x <- 1:10)
lag(x)
lead(x)
# Cumulative or rolling arguments
cumsum(x)
cumprod(x)
cummean(x)
cummin(x)
cummax(x)
# Ranking
y <- c(1, 2, 2, 3, 4, NA)
min_rank(y)
min_rank(desc(y))
row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

# Exercise
transmute(flights, dep_time, sched_dep_time, minute_mid = (dep_time %/% 100)* 60 + (dep_time %% 100), sched_mid = (sched_dep_time %/% 100)* 60 + (sched_dep_time %% 100)  )
transmute(flights, air_time, gain = arr_time - dep_time)
?min_rank
flight1 <- arrange(flights, min_rank(desc(flights$dep_delay)))
select(flight1, dep_delay)
??trig

## GROUPED SUMMARIES WITH SUMMARIZE()
summarize(flights, delay = mean(dep_delay, na.rm = TRUE))
by_day <- group_by(flights, year, month, day) 
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))

# combining multiple operations with the pipe
by_dest <- group_by(flights, dest)
delay <- summarize(by_dest, count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE)) 
delay <- filter(delay, count > 20, dest != "HNL")                                                      
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +  geom_point(aes(size = count), alpha = 1/3) +  geom_smooth(se = FALSE) 
delay

delays <- flights %>%  
  group_by(dest) %>%  
  summarize(count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE)) %>% 
  filter(count > 20, dest != "HNL") 
# Missing Values
flights %>%  
  group_by(year, month, day) %>%  
  summarize(mean = mean(dep_delay))
flights %>%  
  group_by(year, month, day) %>%  
  summarize(mean = mean(dep_delay, na.rm = TRUE)) ## na.rm = TRUE is used to remove missing values
not_cancelled <- flights %>%  
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>%  
  group_by(year, month, day) %>%  
  summarize(mean = mean(dep_delay)) 

# Counts
delays <- not_cancelled %>%  
  group_by(tailnum) %>%  
  summarize(delay = mean(arr_delay))
ggplot(data = delays, mapping = aes(x = delay)) +  geom_freqpoly(binwidth = 10)
delays <- not_cancelled %>%  
  group_by(tailnum) %>%  
  summarize(delay = mean(arr_delay, na.rm = TRUE), n = n())
ggplot(data = delays, mapping = aes(x = n, y = delay)) +  geom_point(alpha = 1/10)
delays %>%  
  filter(n > 25) %>%  
  ggplot(mapping = aes(x = n, y = delay)) + geom_point(alpha = 1/10)
##install.packages('Lahman')
library(Lahman)
batting <- as_tibble(Lahman::Batting)
batters <- batting %>%  
  group_by(playerID) %>%  
  summarize(ba = sum(H, na.rm = TRUE)/sum(AB, na.rm = TRUE),ab = sum(AB, na.rm = TRUE))
batters %>%  
  filter(ab > 100) %>%  
  ggplot(mapping = aes(x = ab, y = ba)) + geom_point() + geom_smooth(se = FALSE) #> `geom_smooth()` using method 
batters %>%  
  arrange(desc(ba))

# Useful Summary Functions
## Measures of location 
not_cancelled %>%  
  group_by(year, month, day) %>% 
  summarize(avg_delay1 = mean(arr_delay), avg_delay2 = mean(arr_delay[arr_delay > 0])) 
## Measures of spread sd(x), IQR(x), mad(x)
not_cancelled %>%  
  group_by(dest) %>%  
  summarize(distance_sd = sd(distance)) %>%  
  arrange(desc(distance_sd))
## Measures of rank min(x), quantile(x, 0.25), max(x)
not_cancelled %>%  
  group_by(year, month, day) %>%  
  summarize(first = min(dep_time), last = max(dep_time)) 
## Measures of position first(x), nth(x, 2), last(x) 
not_cancelled %>%  
  group_by(year, month, day) %>%  
  summarize(first_dep = first(dep_time), last_dep = last(dep_time)) 
not_cancelled %>%  
  group_by(year, month, day) %>%  
  mutate(r = min_rank(desc(dep_time))) %>%  
  filter(r %in% range(r))
## Counts
not_cancelled %>%  
  group_by(dest) %>% 
  summarize(carriers = n_distinct(carrier)) %>%  
  arrange(desc(carriers)) 
not_cancelled %>%  
  count(dest)
not_cancelled %>%  
  count(tailnum, wt = distance)
## Counts and proportions of logical values sum(x > 10), mean(y == 0) 
not_cancelled %>%  
  group_by(year, month, day) %>%  
  summarize(n_early = sum(dep_time < 500)) 
# GROUPING WITH MULTIPLE VARIABLES
daily <- group_by(flights, year, month, day) 
(per_day   <- summarize(daily, flights = n())) 
(per_month <- summarize(per_day, flights = sum(flights))) 
(per_year  <- summarize(per_month, flights = sum(flights))) 
## Continuous summary analysis upon grouped variables will peel off a column as they are summarized

# Ungrouping
daily %>%  
  ungroup() %>%             # no longer grouped by date  
  summarize(flights = n())  # all flights 

## Exercise
fly <- filter(flights, arr_delay == -15 | arr_delay == 15)
delay15 <- group_by(fly, flight)
summarize(delay15,median15 = quantile(arr_delay,0.5))

not_cancelled %>%
  group_by(dest) %>%
  summarize(count = n())
not_cancelled %>%
  group_by(tailnum) %>%
  summarize(count = sum(distance))
flights %>%
  group_by(carrier) %>%
  summarize(delay_d = max(dep_delay, na.rm = TRUE), delay_a = max(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(delay_d))
flights %>% 
  group_by(carrier, dest) %>%
  summarize(count = n())
flights %>%
  filter(dep_delay < 60) %>%
  group_by(carrier) %>%
  summarize(count = n())
not_cancelled %>%  
  count(dest)
  
delayed <-
  flights %>%
  group_by(flight) %>%
  summarise(count = n(),early15 = mean(arr_delay == -15, na.rm = T),late15 = mean(arr_delay == 15, na.rm = T),always10 = mean(arr_delay == 10, na.rm = T),early30 = mean(arr_delay == -30, na.rm = T),late30 = mean(arr_delay == 30, na.rm = T), on_time = mean(arr_delay == 0, na.rm = T),twohours = mean(arr_delay > 120, na.rm = T)) %>%
  map_if(is_double, round, 2) %>%
  as_tibble()
delayed
delayed %>%
  filter(early15 == 0.5, late15 == 0.5)
delayed %>%
  filter(always10 == 1)
delayed %>%
  filter(early30 == 0.5 & late30 == 0.5)
delayed %>%
  filter(on_time == 0.99 & twohours == 0.01)

# Group Mutates and Filter
flights_sml %>%  
  group_by(year, month, day) %>%  
  filter(rank(desc(arr_delay)) < 10)
popular_dests <- flights %>%  
  group_by(dest) %>%  
  filter(n() > 365) 
popular_dests
popular_dests %>%  
  filter(arr_delay > 0) %>%  
  mutate(prop_delay = arr_delay/sum(arr_delay)) %>%  
  select(year:day, dest, arr_delay, prop_delay) 
