## EXPLORATORY DATA ANALYSIS

library(tidyverse)

## VISUALIZING DISTRIBUTIONS
# categorical variables with bar chart
ggplot(data = diamonds) +  geom_bar(mapping = aes(x = cut))
count(diamonds, cut)

# continuous variables with histogram
ggplot(data = diamonds) +  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
diamonds %>%  
  count(cut_width(carat, 0.5)) 
# Making adjustments to the dataset can print out a different graph
smaller <- diamonds %>%  
  filter(carat < 3)
ggplot(data = smaller, mapping = aes(x = carat)) +  geom_histogram(binwidth = 0.1)

# Overlaying multiple histograms with freqpoly via grouping
ggplot(data = smaller, mapping = aes(x = carat, color = cut)) +  geom_freqpoly(binwidth = 0.1)

## TYPICAL VALUES
ggplot(data = smaller, mapping = aes(x = carat)) +  geom_histogram(binwidth = 0.01)
ggplot(data = faithful, mapping = aes(x = eruptions)) +  geom_histogram(binwidth = 0.25)

## UNUSUAL VALUES
ggplot(diamonds) +  geom_histogram(mapping = aes(x = y), binwidth = 0.5) ## outliers belong to the largest bar in the graph
ggplot(diamonds) +  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +  coord_cartesian(ylim = c(0, 50)) ## coord_cartesian is used to zoom in to the values to spot outliers

unusual <- diamonds %>%  
  filter(y < 3 | y > 20) %>%  
  arrange(y) 
unusual 

## Exercise 
ggplot(diamonds, aes(x=x)) + geom_histogram(binwidth = 0.5)
ggplot(diamonds, aes(x=y)) + geom_histogram(binwidth = 0.5)
ggplot(diamonds, aes(x=z)) + geom_histogram(binwidth = 0.5) 
# x and z are the length and depth and y is the width

n <- 500
ggplot(diamonds, aes(x = price)) + geom_histogram(binwidth = n)
count(diamonds, cut_width(price, n))

nine_nine <- diamonds %>%
  filter(carat == 0.99)
count(nine_nine)
one <- diamonds %>%
  filter(carat == 1)
count(one)
# The reason for the difference arises from the fact that most diamonds are measured as whole numbers

ggplot(diamonds, aes(x=z)) + geom_histogram() + coord_cartesian(xlim = c(0,50), ylim = c(0,50))

# It uses a default binwidth and crops the histogram based on the range of xlim and ylim values

## MISSING VALUES
diamonds2 <- diamonds %>%  
  filter(between(y, 3, 20)) 
diamonds2 <- diamonds %>%  
  mutate(y = ifelse(y < 3 | y > 20, NA, y))
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) +  geom_point(na.rm = TRUE) 

library(nycflights13)
flights %>%
  mutate(cancelled = is.na(dep_time), sched_hour = sched_dep_time %/% 100, sched_min = sched_dep_time %% 100,  sched_dep_time = sched_hour + sched_min / 60) %>%
  ggplot(aes(sched_dep_time)) + geom_freqpoly(mapping = aes(color = cancelled), binwidth = 0.25)

## Exercise
ggplot(diamonds2, aes(y)) + geom_histogram(binwidth = 0.25) ## for histogram it drops the NA values
diamonds %>%
  mutate(cut = if_else(runif(n()) < 0.1, NA_character_, as.character(cut))) %>%
  ggplot() +
  geom_bar(mapping = aes(x = cut)) ## for bar chart, it creates a new bar with NA values 

## COVARIATION
ggplot(data = diamonds, mapping = aes(x = price)) +  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +   geom_freqpoly(mapping = aes(color = cut), binwidth = 500) ## by plotting density on the y-axis, the graph becomes compares the grouped variables better

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +  geom_boxplot()
ggplot(data = mpg) +  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) 
ggplot(data = mpg, aes(x = reorder(class, hwy, FUN = median), y = hwy)) + geom_boxplot() + coord_flip()

## Exercise
new <- flights %>%
  mutate(cancelled = is.na(dep_time), sched_hour = sched_dep_time %/% 100, sched_min = sched_dep_time %% 100, sched_dep_time = sched_hour + sched_min/60)
ggplot(new, aes(sched_dep_time, y = ..density..)) + geom_freqpoly(mapping = aes(color = cancelled))
ggplot(new, aes(x = cancelled, y = sched_dep_time)) + geom_boxplot()
head(diamonds)
## carat is the best for predicting price
ggplot(diamonds, aes(carat, y = ..density..)) + geom_freqpoly(mapping = aes(color = cut))
## as carat increases, the quality of the diamond becomes worse and the price increases. This can be due to the fact
## low quality diamonds have larger carats which could lead buyers into thinking that the bigger the size, the more
## expensive the diamond

## install.packages('ggstance')
library(ggstance)
ggplot(data = mpg) +geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) + coord_flip()
ggplot(mpg) + geom_boxploth(mapping = aes(y = reorder(class, hwy, FUN = median), x = hwy))
## ggstance uses geom_boxploth which does not require coord_flip()
## install.packages('lvplot')
library(lvplot)
ggplot(diamonds) + geom_lv(mapping = aes(x = cut, y = price))
?geom_lv
ggplot(diamonds) + geom_violin(mapping = aes(x = cut, y = price)) + coord_flip()
?geom_violin
ggplot(diamonds, aes(price, ..density..)) + geom_freqpoly(mapping = aes(color = cut), binwidth = 500)
ggplot(diamonds, aes(price, ..density..)) + geom_histogram(binwidth = 500) + facet_wrap(~cut, nrow = 5)
ggplot(diamonds, aes(cut, price)) + geom_jitter()

## install.packages('ggbeeswarm')
library(ggbeeswarm)
?ggbeeswarm

## TWO CATEGORICAL VARIABLES
ggplot(data = diamonds) +  geom_count(mapping = aes(x = cut, y = color)) ## geom_count is useful for counting the number occurrences between two categorical variables
diamonds %>%
  count(cut,color)
new1 <- count(diamonds, cut, color)
ggplot(new1, aes(x = color, y = cut)) + geom_tile(mapping = aes(fill = n))

## Exercises
ggplot(new1, aes(x = color, y = cut)) + geom_tile(mapping = aes(fill = n))
ggplot(new1, aes(x = cut, y = color)) + geom_tile(mapping = aes(fill = n))
## The second is bettwe it shows how the cut elements vary for each color
diamond1 <- group_by(flights, month, dest)
summarize(diamond1, dep_delay = mean(dep_delay, na.rm = TRUE))
ggplot(diamond1, aes(dest, factor(month))) + geom_tile(mapping = aes(fill = dep_delay))

## TWO CONTINUOUS VARIABLES
ggplot(data = diamonds) +  geom_point(mapping = aes(x = carat, y = price))
ggplot(data = diamonds) +  geom_point(mapping = aes(x = carat, y = price), alpha = 1/100)
ggplot(data = smaller) +  geom_bin2d(mapping = aes(x = carat, y = price))
## install.packages('hexbin')
library(hexbin)
ggplot(data = smaller) + geom_hex(mapping = aes(x = carat, y = price))
ggplot(data = smaller, mapping = aes(x = carat, y = price)) +  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))
ggplot(data = smaller, mapping = aes(x = carat, y = price)) +  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))

## Exercise
## install.packages('viridis')
library(viridis)
ggplot(data = diamonds, mapping = aes(color = cut_number(carat, 5), x = price)) + geom_freqpoly() + labs(x = "Price", y = "Count", color = "Carat")
ggplot(data = diamonds,mapping = aes(color = cut_width(carat, 1, boundary = 0), x = price)) + geom_freqpoly() + labs(x = "Price", y = "Count", color = "Carat")
ggplot(diamonds, aes(x = cut_number(price,10)), y = carat) + geom_boxplot() + coord_flip() + xlab('Price')
ggplot(diamonds, aes(x = carat, y = price)) + geom_hex() + facet_wrap(~cut, ncol = 1) + scale_fill_viridis()
ggplot(diamonds, aes(x,y)) + geom_point() + coord_cartesian(xlim = c(4,11), ylim = c(4,11))

## PATTERNS AND MODELS
ggplot(data = faithful) +  geom_point(mapping = aes(x = eruptions, y = waiting))
## install.packages('modelr')
library(modelr)
mod <- lm(log(price)~log(carat), data = diamonds)
diamonds2 <- diamonds %>%
  add_residuals(mod) %>%
  mutate(resid = exp(resid))
ggplot(diamonds2, aes(carat,resid)) + geom_point()
ggplot(data = diamonds2) +  geom_boxplot(mapping = aes(x = cut, y = resid))

## ggplot2 calls
ggplot(mpg, aes(x = drv)) + geom_bar(mapping = aes(fill = class), position = "fill") + coord_polar() + labs(x = 'Drive', y = 'Count', fill = 'Cylinder')
