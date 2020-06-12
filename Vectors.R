## VECTORS

library(tidyverse)

## VECTOR BASICS
typeof(letters)
typeof(1:10)
x <- list("a", "b", 1:10);length(x) 

## IMPORTANT TYPES OF ATOMIC VECTOR

# LOGICAL
1:10 %% 3 == 0
c(TRUE, TRUE, FALSE, NA)

# NUMERIC
typeof(1) # double
typeof(1L) # integer

x <- sqrt(2)^2
x
x - 2
c(-1,0,1)/0

# CHARACTER
x <- "This is a reasonably long string." 
pryr::object_size(x) 
y <- rep(x, 1000) 
pryr::object_size(y) 

# MISSING VALUES
NA #logical
NA_integer_ # integer
NA_real_ # double
NA_character_ # character

## Exercise
z <- c(Inf, 10)
is.finite(z) ## looking for finite values
!is.infinite(z) ## strictly looking for values that are not infinite

?readr
x1 <- 1:10
as.integer(x1)

## USING ATOMIC VECTORS
x <- sample(20, 100, replace = TRUE) 
y <- x > 10 
sum(y) ## how many are greater than 10
mean(y) ## what proportion is greater than 10?
# when combining two different types of vectors, the more complex type is outputted
typeof(c(TRUE,1L))
typeof(c(1L,1.5))
typeof(c(1.5,"a"))

## SCALAR AND RECYCLING RULES
sample(10) + 100
runif(10) > 0.5 
1:10 + 1:2 
tibble(x = 1:4, y = 1:2)
tibble(x = 1:4, y = rep(1:2,2))
tibble(x = 1:4, y = rep(1:2, each = 2)) 

## NAMING VECTORS
c(x=1,y=2,z=3)
set_names(1:3, c("a", "b", "c")) 

## SUBSETTING
x <- c("one", "two", "three", "four", "five") 
x[c(3, 2, 5)] ## for calling vectors in those positions
x[c(-1, -3, -5)] ## for calling other vectors except those ones
x[c(1, -1)] ## mixing negative and positive numbers results in an error
x1 <- c(10, 3, NA, 5, 8, 1, NA)
x1[!is.na(x1)]
x1[x1 %% 2 == 0]
x <- c(abc = 1, def = 2, xyz = 3)
x[c('abc','def')]

## EXERCISE
mean(is.na(x1)) ## It tells us which portion of the vector are NA values
?is.vector
?is.atomic
x <- c(-1,3,4,-4,5,7)
x[-which(x > 0)] 
x[x <= 0]
# They are different because the first one removes the elements which are greater than 0
# and the second one looks for element that are less than or equal to zero

last_val <- function(v) {
  v[[length(v)]]
}
last_val(x)
even_val <- function(v) {
  v[v %% 2 == 0 & !is.na(v)]
}
even_val(x)
last_val_not <- function(v) {
  v[1:length(v)-1]
}
last_val_not(x)
even_ele <- function(v) {
  y <- seq(2, length(v),2)
  v[c(y)]
}
even_ele(x)

## RECURSIVE VECTORS (LISTS)
x <- list(1,2,3)
str(x) 
x_named <- list(a = 1, b = 2, c = 3);str(x_named)
y <- list("a", 1L, 1.5, TRUE) 
str(y) 
z <- list(list(1, 2), list(3, 4));str(z) ## str() is used to get the structure of the list

## VISUALIZING LISTS
x1 <- list(c(1, 2), c(3, 4)) 
x2 <- list(list(1, 2), list(3, 4)) 
x3 <- list(1, list(2, list(3))) 

## SUBSETTING
a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5))
str(a[1:2]) 
str(a[4])
str(y[[1]]) 
str(y[[4]])
a$a

## LISTS OF CONDIMENTS
a[4]
a[[4]][[1]]

## ATTRIBUTES
x <- 1:10 
attr(x, "greeting") 
attr(x, "greeting") <- "Hi!" 
attr(x, "farewell") <- "Bye!" 
attributes(x) 
as.Date
methods("as.Date")
getS3method("as.Date", "default")

## AUGMENTED VECTORS

# Factors
x <- factor(c("ab", "cd", "ab"), levels = c("ab", "cd", "ef")) 
typeof(x)
attributes(x)

# Date and Date-Times
x <- as.Date("1971-01-01")
unclass(x)
typeof(x)
attributes(x)
y <- ymd_hm("1970-01-01 01:00")
unclass(y)
typeof(y)
attributes(y)
attr(y, "tzone") <- "US/Pacific"
attr(x, "tzone") <- "US/Eastern" 
y <- as.POSIXlt(x);typeof(y)
attributes(y) 

## TIBBLES
lb <- tibble(x = 1:5, y = 5:1)
typeof(lb)
attributes(lb)

## Exercise
time <- hms::hms(3600)
attributes(time)

?timezones
OlsonNames()
strftime(now(), "It's %I:%M%p on %A %d %B, %Y.") 

