## TIDY DATA WITH TIDYR

library(tidyverse)

## Tidy data
table1
table2
table3
table4a
table4b

# Computing rate per 10000
table1 %>%  
  mutate(rate = cases / population * 10000)

# Compute cases per year
table1 %>%  
  count(year, wt = cases) 

# Visualize changes over time
library(ggplot2)
ggplot(table1, aes(year, cases)) +  geom_line(aes(group = country), color = "grey50") +  geom_point(aes(color = country))

## Exercise

table2_1 <- filter(table2, type == 'cases')
table2_1 <- rename(table2_1, cases = count)
table2_1
table2_2 <- filter(table2, type == 'population')
table2_2 <- rename(table2_2, population = count)
table2_2
table2_3 <- cbind(table2_1,table2_2)
table2_4 <- table2_3[-5:-7]
table2_4 <- table2_4[-3]
table2_4 <- mutate(table2_4, rate = (cases/population)*10000)
ggplot(table2_4, aes(year, cases)) +  geom_line(aes(group = country), color = "grey50") +  geom_point(aes(color = country))
## I needed to transform the data set

library(reshape2)
table4a1 <- melt(table4a, id.vars = 'country', measure.vars = c('1999', '2000'))
table4b1 <- melt(table4b, id.vars = 'country', measure.vars = c('1999', '2000'))
table4 <- cbind(table4a1, table4b1)
table4 <- table4[-4:-5]
table4 <- rename(table4, year = variable, cases = value, population = value.1)
table4
table4 <- mutate(table4, rate = (cases/population)*10000)
table4

## Spreading and Gathering

# Gathering
rm(table4a, table4b)
gather(table4a, '1999','2000', key = 'year', value = 'cases') ## used for tidying a data set that has its variable scattered across columns
gather(table4b, '1999', '2000', key ='year', value = 'population')
tidy4a <- table4a %>%  
  gather(`1999`, `2000`, key = "year", value = "cases") 
tidy4b <- table4b %>%  
  gather(`1999`, `2000`, key = "year", value = "population") 
left_join(tidy4a, tidy4b) ## used for joining two dataframes together

# Spreading
rm(table2)
table2
spread(table2, key = type, value = count) ## used for tidying a data set that has its variables scattered/repeated across rows

## Exercise
stocks <- tibble(year = c(2015, 2015, 2016, 2016), half = c(1, 2, 1, 2), return = c(1.88, 0.59, 0.92, 0.17)) 
stocks %>%  
  spread(year, return) %>%  
  gather("year", "return", `2015`:`2016`)
u1 <- spread(stocks, year, return)
gather(u1, '2015', '2016', key = year, value = return)
?spread
## It switched up the orientation/arrangement of the columns and it changed year from a double to a character
stocks
table4a %>%  
  gather(1999, 2000, key = "year", value = "cases")
## It fails becuase 1999 and 2000 are supposed to character not integers
people <- tribble(~name,             ~key,    ~value,  
                  #-----------------|--------|-----  
                  "Phillip Woods",   "age",       45,  
                  "Phillip Woods",   "height",   186,  
                  "Phillip Woods",   "age",       50,  
                  "Jessica Cordero", "age",       37, 
                  "Jessica Cordero", "height",   156) 
people
spread(people, key = key, value = value)
## It fails because there is two ages for one of the observations
preg <- tribble(~pregnant, ~male, ~female,  
                "yes",     NA,    10, 
                "no",      20,    12)
preg
preg %>%
  gather(male, female, key = gender, value = yeet)

## Separating and Pull
table3
separate(table3, rate, into = c('cases', 'population'), sep= "/", convert = TRUE)
table3 %>%  
  separate(year, into = c("century", "year"), sep = 2) ## using an integer with sep, separates the column at that integer's index

## Unite
table5
unite(table5, new, century, year)
unite(table5, new, century, year, sep = "") ## used to ensure that there is no automatic symbol in between united values

## Exercise
?separate
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%  
  separate(x, c("one", "two", "three"), extra = "drop")
## extra can be used to drop unnecessary values
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%  
  separate(x, c("one", "two", "three"), fill = "right") 
## fill can be used to fill in missing values in case of empty values
separate(table3, rate, into = c('cases', 'population'), sep= "/", convert = TRUE, remove = FALSE)
## remove is used to decide whether or not to keep the original column that is intended for separation. By setting
## remove to FALSE, it will not remove original column
unite(table5, new, century, year, sep = "", remove = FALSE)
## The same application for remove with separate is used for unite

?extract
?separate
?unite

## Missing Values
stocks <- tibble(year = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),qtr = c(1, 2, 3, 4, 2, 3, 4), return = c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66)) 
stocks %>%  
  spread(year, return) ## making implicit missing values explicit
stocks %>%  
  spread(year, return) %>%  
  gather(year, return, `2015`:`2016`, na.rm = TRUE) ## getting rid of missing values
stocks %>%  
  complete(year, qtr) ## making implicit values explicit
treatment <- tribble(~ person,           ~ treatment, ~response,  
                     "Derrick Whitmore", 1,           7, 
                     NA,                 2,           10,  
                     NA,                 3,           9,  
                     "Katherine Burke",  1,           4)
treatment %>%
  fill(person) ## fills in the previous value in the new positions of the missing values

## Exercise
?spread
stocks %>%
  spread(year,return, fill = 1.5) ## it replaces all missing values with 1.5
?complete
stocks %>%
  complete(year, qtr, fill = list(value1 = 1.4,value2 = 1.5)) ## it takes a list and replaces it accordingly with all missing values


## CASE STUDY
who
who1 <- who %>%  
  gather(new_sp_m014:newrel_f65, key = "key", value = "cases",  na.rm = TRUE  ) 
who1 %>%  
  count(key) 
who2 <- who1 %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel")) 
who2 
who3 <- who2 %>%  
  separate(key, c("new", "type", "sexage"), sep = "_") 
who3 
who4 <- who3 %>%  
  select(-new, -iso2, -iso3)
who5 <- who4 %>%  
  separate(sexage, c("sex", "age"), sep = 1)
who5
who %>%  
  gather(code, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>%  
  mutate(code = stringr::str_replace(code, "newrel", "new_rel")) %>%  
  separate(code, c("new", "var", "sexage")) %>%  select(-new, -iso2, -iso3) %>%  
  separate(sexage, c("sex", "age"), sep = 1)
