## RELATIONAL DATA WITH DPLYR

library(tidyverse)
library(nycflights13)

# datasets associated with nycflights13
airlines 
airports
planes
weather
print(weather, n = 10, width = Inf)

## Keys
planes %>%  
  count(tailnum) %>%  
  filter(n > 1)
weather %>%  
  count(year, month, day, hour, origin) %>%  
  filter(n > 1) 
flights %>%  
  count(year, month, day, flight) %>%  
  filter(n > 1) 
flights %>%  
  count(year, month, day, tailnum) %>%  
  filter(n > 1) 

## Exercise
flights <- mutate(flights, row_number())
Lahman::Batting
# playerID, year ID and stint is the primary key
# install.packages('babynames')
babynames::babynames
library(babynames)
babynames %>%
  count(year, sex, name) %>%
  filter(n > 1)
# year, sex and name is the primary key
# install.packages('nasaweather')
nasaweather::atmos 
library(nasaweather)
atmos %>%
  count(lat, long, year, month) %>%
  filter(n > 1)
# lat, long, year and month is the primary key
# install.packages('fueleconomy')
library(fueleconomy)
vehicles
vehicles %>%
  count(id) %>%
  filter(n > 1)
# id is the primary key
library(ggplot2)
diamonds
diamonds %>%
  mutate(row_number()) %>%
  count(row_number()) %>%
  filter(n > 1)
# no primary key

## MUTATING JOINS
flights2 <- flights %>%  
  select(year:day, hour, origin, dest, tailnum, carrier) 
flights2 
flights2 %>%  
  select(-origin, -dest) %>%  
  left_join(airlines, by = "carrier") 
flights2 %>%  
  select(-origin, -dest) %>%  
  mutate(name = airlines$name[match(carrier, airlines$carrier)]) 

# UNDERSTANDING JOINS
x <- tribble(~key, ~val_x,     
             1, "x1",     
             2, "x2",     
             3, "x3" )
y <- tribble(~key, ~val_y,     
             1, "y1",     
             2, "y2",     
             4, "y3" ) 

# INNER JOINs
inner_join(x, y, by = "key") ## retains only information from matching keys

# OUTER JOINS
left_join(x,y, by = "key") ## retains all the keys from x
right_join(x, y, by = "key") ## retains all the keys from y
full_join(x, y, by = "key") ## retains all the keys

# DUPLICATE KEYS
x <- tribble(~key, ~val_x,    
             1, "x1",    
             2, "x2",     
             2, "x3",     
             1, "x4") 
y <- tribble(~key, ~val_y,    
             1, "y1",     
             2, "y2") 
left_join(x, y, by = "key")
x <- tribble(~key, ~val_x,     
             1, "x1",     
             2, "x2",     
             2, "x3",     
             3, "x4") 
y <- tribble(~key, ~val_y,     
             1, "y1",     
             2, "y2",     
             2, "y3",     
             3, "y4") 
left_join(x,y, by = "key")

# DEFINING THE KEY COLUMNS
flights2 %>%  
  left_join(weather)
flights2 %>%  
  left_join(planes, by = "tailnum") 
flights2 %>%  
  left_join(airports, c("dest" = "faa")) # for joining similar columns with different column names
flights2 %>%  
  left_join(airports, c("origin" = "faa"))

## Exercise
flights
flights1 <- flights %>%
  group_by(year, month, day, hour, dest) %>%
  summarize(delay = mean(arr_delay, na.rm = TRUE))
flights1
airports %>%  
  inner_join(flights1, c("faa" = "dest")) %>%  
  ggplot(aes(lon, lat)) + borders("state") + geom_point(mapping = aes(color = delay)) + coord_quickmap() 

airport_loc <- airports %>%
  select(faa, lat, lon)
airport_loc
flights %>%
  select(year:day, hour, origin, dest) %>%
  left_join(airport_loc, by = c("origin" = "faa")) %>%
  left_join(airport_loc, by = c("dest" = "faa"))

## MERGING

merge(x,y, by = "key") # inner join
merge(x, y, all.x = TRUE) # left join
merge(x,y, al.y = TRUE) # right join
merge(x,y, all.x = TRUE, all.y = TRUE) # full join

## FILTERING JOINS
top_dest <- flights %>%  
  count(dest, sort = TRUE) %>%  
  head(10) 
top_dest 
flights %>%  
  filter(dest %in% top_dest$dest) 
flights %>%  
  semi_join(top_dest, by = "dest") ## keeps rows that have a match on LHS
flights %>%  
  anti_join(planes, by = "tailnum") %>%  # keeps rows that don't have a match
  count(tailnum, sort = TRUE) 

## SET OPERATIONS
df1 <- tribble(~x, ~y,  
               1,  1,   
               2,  1) 
df2 <- tribble(~x, ~y,   
               1,  1,   
               1,  2)
intersect(df1,df2) # retuns common obsevations
union(df1,df2) # returns all observations
setdiff(df1,df2) # returns observations in LHS
setdiff(df2,df1)
