## FUNCTIONS

df <- tibble::tibble(
  a = rnorm(10),  
  b = rnorm(10), 
  c = rnorm(10),  
  d = rnorm(10)
)

## Manipulating the columns of the tibble individually may seem a bit too stressful and can lead to errors
df$a <- (df$a - min(df$a, na.rm = TRUE)) /  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) /  (max(df$a, na.rm = TRUE) - min(df$b, na.rm = TRUE)) 
df$c <- (df$c - min(df$c, na.rm = TRUE)) /  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE)) 
df$d <- (df$d - min(df$d, na.rm = TRUE)) /  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE)) 

## With a function, the process becomes much easier and less strenuous
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)  
  (x - rng[1]) / (rng[2] - rng[1]) 
} 
rescale01(c(0, 5, 10)) 
df <- tibble::tibble(
  a = rnorm(10),  
  b = rnorm(10), 
  c = rnorm(10),  
  d = rnorm(10)
)
df$a <- rescale01(df$a) 
df$b <- rescale01(df$b) 
df$c <- rescale01(df$c) 
df$d <- rescale01(df$d) 

## Exercise
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE) 
  if (x == -Inf) {
    x = 0
  } else if (x == Inf) {
    x = 1
  }
  (x - rng[1]) / (rng[2] - rng[1]) 
} 

mean1 <- function(x) {
  mean(x, na.rm = TRUE)
}
indiv <- function(x) {
  x/sum(x, na.rm = TRUE)
}
cv <- function(x) {
  sd(x, na.rm = TRUE)/mean(x, na.rm = TRUE)
}
mean1(c(1,2,3,4))
indiv(c(1,2,3,4))
cv(c(1,2,3,4))
x <-c(1,2,3,4)
length(x)
both_na <- function(x,y) {
  j = 0
  if(length(x) == length(y)) {
    for (i in x) {
      if(is.na(x[i]) & is.na(y[i])) {
        j = j + 1
      }
    }
    print(j)
  }
}
x <- sample(c(NA,1,2), 200, replace = TRUE)
y <- sample(c(NA,1,2), 200, replace = TRUE)
both_na(x,y)
length(x)
length(y)

library(stringr)

## CONDITIONAL EXECUTION
has_name <- function(x) {  
  nms <- names(x)  
  if (is.null(nms)) {    
    rep(FALSE, length(x))
  } else {
    !is.na(nms) & nms != ' '
  }
}

## CONDITIONS
if (c(TRUE, FALSE)) {} 
if(NA) {}
identical(0L, 0)
x <- sqrt(2)^2
x == 2
x - 2

## MULTIPLE CONDITIONS
# Examples of good formatted if statements
if (y < 0 && debug) {message("Y is negative") }
if (y == 0) {  log(x) } else {  y ^ x }

## Exercise
library(lubridate)
library(tidyverse)
if (between(hour(now()), 6, 12)) {
  message('Good Morning!')
} else if (between(hour(now()),12, 16)) {
  message('Good Afternoon!') 
} else if (between(hour(now()), 16, 20)) {
  message('Good Evening!')
} else {
  message('How are you?')
}
x <- 12
if((x %% 3 == 0) & (x %% 5 == 0)) {
  message('fizzbuzz')
} else if (x %% 5 == 0) {
  message('buzz')
} else if (x %% 3 == 0) {
  message('fizz')
} else {
  message(x)
}

## FUNCTION ARGUMENTS
# Compute confidence interval around 
# mean using normal approximation
## x becomes an important variable input and conf is a fixed default input that doesn't need to be called
mean_ci <- function(x, conf = 0.95) {   
  se <- sd(x) / sqrt(length(x))  
  alpha <- 1 - conf  
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2)) 
}
x <- runif(100) 
mean_ci(x) 
mean_ci(x, conf = 0.99) 

mean(1:10, na.rm = TRUE)

## CHECKING VALUES
wt_mean <- function(x, w) {  
  sum(x * w) / sum(x) 
} 
wt_var <- function(x, w) {  
  mu <- wt_mean(x, w)  
  sum(w * (x - mu) ^ 2) / sum(w) 
} 
wt_sd <- function(x, w) {  
  sqrt(wt_var(x, w)) 
} 

## In order to ensure proper compilation of the codes above, they can be written to ensure that the right values are used
wt_mean <- function(x, w) {  
  if (length(x) != length(w)) {    
    stop("`x` and `w` must be the same length", call. = FALSE)  
  }  
  sum(w * x) / sum(x)
} 

## Dot-dot-dot
sum(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
stringr::str_c("a", "b", "c", "d", "e", "f") 
commas <- function(...) {
  stringr::str_c(..., collapse = ", ") 
}
commas(letters[1:10]) 
rule <- function(..., pad = "-") {  
  title <- paste0(...)  
  width <- getOption("width") - nchar(title) - 5
  cat(title, " ", stringr::str_dup(pad, width), "\n", sep = "") 
} 
rule("Important output")

## EXERCISE
commas(letters, collapse = "-") ## doesn't work because there is no extra argument in the collapse function

?trim
mean(1:10, trim = 0)

## RETURN VALUES
## EXPLICIT RETRUN STATEMENTS
complicated_function <- function(x, y, z) {  
  if (length(x) == 0 || length(y) == 0) {    
    return(0) 
    }
  # Complicated code here 
} 

## WRITING PIPEABLE FUNCTIONS
show_missings <- function(df) {  
  n <- sum(is.na(df))  
  cat("Missing values: ", n, "\n", sep = "")
  invisible(df) 
} 
mtcars %>%  
  show_missings() %>%  
  mutate(mpg = ifelse(mpg < 20, NA, mpg)) %>% 
  show_missings()

## ENVIRONMENT
f <- function(x) {
  x + y
}
y <- 100
f(10)
