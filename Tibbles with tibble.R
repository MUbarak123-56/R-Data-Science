## TIBBLES WITH TIBBLE

library(tidyverse)
as_tibble(iris) ## for converting a dataframe to a tibble
tibble(x = 1:5, y = 1, z = x ^ 2 + y)  ## creating a new tibble
tb <- tibble(`:)` = "smile",` ` = "space",`2000` = "number" ) ## tibbles can have weird names
tb
tribble(~x, ~y, ~z, "a", 2, 3.6,  "b", 1, 8.5 ) ## a tribble creates a transposed tibble
tibble(a = lubridate::now() + runif(1e3) * 86400, b = lubridate::today() + runif(1e3) * 30, c = 1:1e3, d = runif(1e3), e = sample(letters, 1e3, replace = TRUE) )
nycflights13::flights %>% 
  print(n = 10, width = Inf) # The print option can be used to print as many rows as possible
nycflights13::flights %>% 
  View() 
## Subsetting
df <- tibble(x = runif(5),y = rnorm(5))
df$x 
df[['x']]
df[[1]] 
# pipes can also be used
df %>%
  .$x
df %>%
  .[['x']]
class(as.data.frame(tb)) ## to transform back to tibble

## Exercise
mtcars
class(mtcars)
df <- data.frame(abc = 1, xyz = "a")
df$x 
df[, "xyz"] 
df[, c("abc", "xyz")]
df <- tibble(abc = 1, xyz = "a")
df$xyz
df[,'xyz']
## dataframe still prints out something when the command is incomplete and it tends to group strings by levels automatically
tibble::enframe()
var <- "mpg"
mtcars[[var]]
print(as_tibble(mtcars), n = 10, width = Inf)
## n controls how many rows are printed
annoying <- tibble(`1` = 1:10,`2` = `1` * 2 + rnorm(length(`1`))) 
annoying[['1']]
annoying[['2']]
ggplot(annoying, aes(x = '1',y = '2')) + geom_point(position = 'jitter') + coord_fixed()
annoying[['3']] = annoying[['2']]/annoying[['1']]
annoying[['3']]
annoying
annoying = rename(annoying, one = '1', two = '2', three = '3')
annoying
