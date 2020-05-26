## DATA IMPORT WITH READR

library(tidyverse)
heights <- read_csv("C:/Users/ganiy/OneDrive/Documents/lately.csv")
read_csv("a,b,c 
         1,2,3 
         4,5,6")
read_csv("The first line of metadata  The second line of metadata  
         x,y,z  
         1,2,3", 
         skip = 2) 
read_csv("# A comment I want to skip  
         x,y,z  
         1,2,3", comment = "#") 
read_csv("1,2,3\n4,5,6", col_names = FALSE)
read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z")) 
read_csv("a,b,c\n1,2,.", na = ".")

## Exercise

data.table::fread()
read_csv("a,b\n1,2,3\n4,5,6") ## the rows are longer than the header
read_csv("a,b,c\n1,2\n1,2,3,4") ## the rows are uneven compared to the header
read_csv("a,b\n\"1") ## same thing applies here from above
read_csv("a,b\n1,2\na,b") ## it specifies everything as character due to mixing charater and double under the same column
read_csv("a;b\n1;3")

## PARSING A VECTOR
str(parse_logical(c("TRUE", "FALSE", "NA"))) 
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1979-10-14")))
parse_integer(c("1", "231", ".", "456"), na = ".")
x <- parse_integer(c("123", "345", "abc", "123.45")) ## when parsing fails, there is a warning
problems(x) ## used to view parsing error

## NUMBERS
parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark = ",")) 
parse_number("$100") 
parse_number("20%")
parse_number("It cost $123.45") ## It strictly parses numbers
parse_number("$123,456,789")
parse_number("123.456.789",  locale = locale(grouping_mark = ".")) 
parse_number("123'456'789",  locale = locale(grouping_mark = "'")) 

## STRINGS
charToRaw("Hadley")
x1 <- "El Ni\xf1o was particularly bad this year" 
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd" 
parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))
guess_encoding(charToRaw(x1)) 
guess_encoding(charToRaw(x2))

## FACTORS
fruit <- c("apple", "banana") 
parse_factor(c("apple", "banana", "bananana"), levels = fruit) 

## DATES, DATE-TIMES AND TIMES
parse_datetime("2010-10-01T2010")
parse_datetime("20101010")
parse_date("2010-10-01") 
library(hms)
parse_time("01:10 am")
parse_time("20:10:01") 
parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y") 
parse_date("01/02/15", "%y/%m/%d") 
parse_date("2020/26/05", "%Y/%d/%m")
parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr")) 

## EXERCISES
?date_format
## date_format and time_format are used to describe the format that the date or time will be outputted as
d1 <- "January 1, 2010" 
parse_date(d1,"%B %d, %Y")
d2 <- "2015-Mar-07"
parse_date(d2,"%Y-%b-%d")
d3 <- "06-Jun-2017" 
parse_date(d3,"%d-%b-%Y")
d4 <- c("August 19 (2015)", "July 1 (2015)") 
parse_date(d4,"%B %d (%Y)")
d5 <- "12/30/14" # Dec 30, 2014 
parse_date(d5, "%m/%d/%y")
t1 <- "1705" 
parse_time(t1, "%H%M")
t2 <- "11:15:10.12 PM"
parse_time(t2,"%I:%M:%S%.%p")
parse_number("123,456,789",locale = locale(grouping_mark = ",", decimal_mark = ",")) ## It outputs a warning that they have to be different
parse_number("123.456,789",locale = locale(grouping_mark = ".", decimal_mark = ","))

## PARSING A FILE
# Strategy
guess_parser("2010-10-01")
guess_parser("15:01") 
guess_parser(c("TRUE", "FALSE")) 
guess_parser(c("1", "5", "9")) 
guess_parser(c("12,352,561"))
str(parse_guess("2010-10-10"))

## PROBLEMS
challenge <- read_csv(readr_example("challenge.csv"))
problems(challenge)
challenge <- read_csv(readr_example("challenge.csv"), col_types = cols(x = col_integer(), y = col_character())) 
challenge <- read_csv(readr_example("challenge.csv"), col_types = cols(x = col_double(), y = col_character())) 
tail(challenge) 
challenge <- read_csv(readr_example("challenge.csv"), col_types = cols(x = col_double(), y = col_date()))
tail(challenge)

## Other strategies
challenge2 <- read_csv(readr_example("challenge.csv"),  guess_max = 1001)
challenge2
challenge2 <- read_csv(readr_example("challenge.csv"),  col_types = cols(.default = col_character())) 
df <- tribble(~x,  ~y, 
              "1", "1.21",  
              "2", "2.32",  
              "3", "4.56") 
df 
type_convert(df)

## WRITING TO A FILE
write_csv(challenge, "challenge.csv") 
challenge
write_csv(challenge, "challenge-2.csv") 
read_csv("challenge-2.csv") 
write_rds(challenge, "challenge.rds") 
read_rds("challenge.rds") 
install.packages('feather')
library(feather) 
write_feather(challenge, "challenge.feather") 
read_feather("challenge.feather")
