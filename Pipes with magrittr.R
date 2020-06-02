## PIPES WITH MAGRITTR

install.packages('magrittr')
library(magrittr)

## Piping Alternatives
library(ggplot2)
 
diamonds2 <- diamonds %>% 
  dplyr::mutate(price_per_carat = price / carat)
## install.packages('pryr')
pryr::object_size(diamonds) ## pryr is used to report how much memory is occupied by its argument
pryr::object_size(diamonds2)
pryr::object_size(diamonds, diamonds2)

diamonds$carat[1] <- NA 
pryr::object_size(diamonds)
pryr::object_size(diamonds2)
pryr::object_size(diamonds, diamonds2)

## Function Composition

assign("x", 10) 
"x" %>%
  assign(100) ## This doesn't work
x
env <- environment()
"x" %>%
  assign(100, envir = env) ## This works because we are explicit about the environment
x

tryCatch(stop("!"), error = function(e) "An error")
stop("!") %>%  
  tryCatch(error = function(e) "An error") ## Doesn't compile because the functional argument was computed before calling it

## Other tools for magrittr
rnorm(100) %>%  
  matrix(ncol = 2) %>%  
  plot() %>%  
  str() 
rnorm(100) %>%  
  matrix(ncol = 2) %T>%  ## %T>% makes it possible to continue piping functions that normally cause termination
  plot() %>%  
  str() 
mtcars %$%  
  cor(disp, mpg) ## %$% explodes out variables so they can be used explicitly

mtcars <- mtcars %>%  
  transform(cyl = cyl * 2) 
mtcars %<>% transform(cyl = cyl*2) ## This is a shorter form of the code above
