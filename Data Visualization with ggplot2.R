## DATA VISUALIZATION WITH GGPLOT2

##install.packages('tidyverse')
library(tidyverse)

## FIRST STEPS
### THE mpg dataframe
mpg

### Creating a ggplot
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy))
ggplot(mpg, aes(displ,hwy)) + geom_point()

## Exercise 
ggplot(data = mpg) ## doesn't do anything
summary(mtcars)
str(mtcars)
?mpg
ggplot(data = mpg) + geom_point(mapping = aes(x = cyl, y = hwy))

## Aesthetic mappings
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, colour = class)) ## groups classes by color
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, size = class)) ## groups classes by size
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, alpha = class)) ## groups classes by transparency
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, shape = class)) ## groups classes by shapes
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy), color = "blue") ## setting the color of the points blue

## Exercise
?mpg
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, color = cyl)) ## groups classes by shapes
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, size = class, color = class))
?geom_point
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, stroke = cyl)) 
## stroke is used to group numerical variables by size.
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, stroke = cyl)) 
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, colour = displ < 5)) 
## groups displ into two categories by color: TRUE or FALSE

## AN ALTERNATIVE WAY TO USE ggplot2
ggplot(mpg, aes(displ,hwy, color = displ < 5)) + geom_point()
ggplot(mpg, aes(displ,hwy)) + geom_point(color = "red")

## Facets
ggplot(mpg, aes(displ,hwy)) + geom_point() + facet_wrap(~class, nrow = 2) ## creating subplots based on the categorical variables of class
ggplot(mpg, aes(displ,hwy)) + geom_point() + facet_grid(drv~cyl)
?mpg
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(. ~ cyl) ## facetting using one variable without calling nrow or ncol

## Exercise
ggplot(mpg, aes(displ,hwy)) + geom_point() + facet_wrap(~cyl, nrow = 2)
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(drv ~ .) ## facetting using one variable in this manner prints by row
ggplot(mpg, aes(displ,hwy)) + geom_point() + facet_grid(. ~ cyl) ## facetting using one variable by column
?facet_wrap

## Geometric objects
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) +  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv)) ## using aesthetic
?geom_smooth
ggplot(mpg, aes(displ,hwy, group = drv)) + geom_smooth()
ggplot(data = mpg) +  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv), show.legend = FALSE)

## USING MULTIPLE GEOMS
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy)) +  geom_smooth(mapping = aes(x = displ, y = hwy))
ggplot(mpg, aes(displ,hwy)) + geom_point(mapping = aes(color = class)) + geom_smooth()
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point(mapping = aes(color = class)) + geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

## Exercise
ggplot(mpg, aes(displ,hwy)) + geom_point() + geom_smooth(se = FALSE)
ggplot(mpg, aes(displ,hwy)) + geom_point() + geom_smooth(mapping = aes(group = drv), se = FALSE)
ggplot(mpg, aes(displ,hwy)) + geom_point(mapping = aes(color = drv)) + geom_smooth(mapping = aes(color = drv), se = FALSE)
ggplot(mpg, aes(displ,hwy)) + geom_point(mapping = aes(color = drv)) + geom_smooth(se = FALSE)
ggplot(mpg, aes(displ,hwy)) + geom_point(mapping = aes(color = drv)) + geom_smooth(mapping = aes(linetype = drv), se = FALSE)
ggplot(mpg, aes(displ,hwy)) + geom_point(mapping = aes(color = drv), size = 8)

## STATISTICAL TRANSFORMATION
ggplot(data = diamonds) +  geom_bar(mapping = aes(x = cut))
ggplot(data = diamonds) +  stat_count(mapping = aes(x = cut)) ## stat_count can be used in place of geom_bar
?geom_bar
ggplot(data = diamonds) +  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1)) ## displaying a bar chart of proportion
ggplot(data = diamonds) +  stat_summary(mapping = aes(x = cut, y = depth), fun.ymin = min, fun.ymax = max, fun.y = median)

## Exercise
ggplot(data = diamonds) + geom_boxplot(mapping = aes(x = cut, y = depth))
ggplot(data = diamonds) + geom_col(mapping = aes(x = cut, y = depth))
?stat_smooth
?geom_boxplot
?stat_summary
ggplot(data = diamonds) +  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1)) 
ggplot(data = diamonds) +  geom_bar(mapping = aes(x = cut,y = ..prop.., fill = color, group = 1))

## POSITION ARGUMENT
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, color = cut))
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, fill = cut))
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, fill = clarity)) ## grouping the bars based on clarity 

## position identity places each value where they belong. This could lead to overlapping
ggplot(data = diamonds,  mapping = aes(x = cut, fill = clarity)) +  geom_bar(alpha = 1/5, position = "identity") 
ggplot(data = diamonds,  mapping = aes(x = cut, color = clarity)) +  geom_bar(fill = NA, position = "identity") 

## position fill stacks the bars and makes them equal heights so it is easier to compare them via proportions
ggplot(data = diamonds) +  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

## position dodge places each of the mini-bars next to each other to prevent over lapping
ggplot(data = diamonds) +  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

## position jitter is used for scatter plots to spread out the points in the graph so as to uncover overlapped points
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

## Exercise
ggplot(mpg, aes(cty,hwy)) + geom_point(position = "jitter")
?geom_jitter

## COORDINATE SYSTEMS 

## coord_flip(): used to flip the  x and y coordinates
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +  geom_boxplot() +  coord_flip()

## coord_quickmap(): used to set the aspect ratio for maps
## install.packages('maps')
library(maps)
nz <- map_data("nz")
ggplot(nz, aes(long, lat, group = group)) +  geom_polygon(fill = "white", color = "black")
ggplot(nz, aes(long, lat, group = group)) +  geom_polygon(fill = "white", color = "black") +  coord_quickmap()

## coord_polar(): uses polar coordinates to connect bar chart to coxcomb chart
bar <- ggplot(data = diamonds) +  geom_bar(mapping = aes(x = cut, fill = cut), show.legend = FALSE, width = 1) +  theme(aspect.ratio = 1) +  labs(x = NULL, y = NULL)
bar + coord_flip()
bar + coord_polar()

## Exercise
bar2 <- ggplot(data = diamonds) +  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")
bar2 + coord_polar()

?coord_map
?coord_quickmap

## coord_fixed sets the aspect ratio for charts
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +  geom_point() +  geom_abline() + coord_fixed()

head(diamonds)
ggplot(diamonds) + geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill") + coord_polar() + facet_wrap(~color, nrow = 2)
