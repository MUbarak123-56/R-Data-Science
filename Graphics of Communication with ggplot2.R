## Graphics for communication with ggplot2

library(tidyverse)
## install.packages('ggrepel')
## install.packages('viridis')

## LABELS

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(title = paste("Fuel efficiency generally decresaes engine size")) 
## labs can be used to add labels like title; Avoid using mundane title like 
## A scatterplot of fuel efficiency vs engine size

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) + 
  geom_smooth(se = FALSE) + 
  labs(title = paste("Fuel efficiency generally decresaes engine size"),
       subtitle = paste("Two seaters (sports cars) were an exception because
                        of their light weight"),
       caption = "Data from fueleconomy.gov")

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) + 
  geom_smooth(se = FALSE) + 
  labs(x = "Engine displacement (L)", 
       y = "Highway fuel economy (mpg)",
       color = "Car type"
       )

df <- tibble(
  x = runif(10),
  y = runif(10)
)
ggplot(df, aes(x,y)) +
  geom_point() +
  labs(
    x = quote(sum(x[i]^2, i == 1, n)),
    y = quote(alpha + beta + frac(delta, theta))
  )

## ANNOTATIONS
best_in_class <- mpg %>% 
  group_by(class) %>% 
  filter(row_number(desc(hwy)) == 1)
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) + 
  geom_text(aes(label = model), data = best_in_class)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_label(
    aes(label = model),
    data = best_in_class,
    nudge_y = 2,
    alpha = 0.5
  )

ggplot(mpg, aes(displ, hwy)) +  
  geom_point(aes(color = class)) +  
  geom_point(size = 3, shape = 1, data = best_in_class) +  
  ggrepel::geom_label_repel(aes(label = model), data = best_in_class)

class_avg <- mpg %>% 
  group_by(class) %>% 
  summarize(displ = median(displ), hwy = median(hwy))

ggplot(mpg, aes(displ, hwy, color = class)) +
  ggrepel::geom_label_repel(aes(label = class),
                            data = class_avg,
                            size = 6,
                            label.size = 0,
                            segment.color = NA
                            ) +
  geom_point() +
  theme(legend.position = "none")

label <- mpg %>% 
  summarize(
    displ = max(displ),
    hwy = max(hwy),
    label = paste("Increasing engine size is \nrelated to decreasing fuel economy")
  )

ggplot(mpg, aes(displ, hwy)) +
  geom_point() + 
  geom_text(
    aes(label = label),
    data = label,
    vjust = "top",
    hjust = "right"
  )

label <- tibble(
  displ = Inf,
  hwy = Inf,
  label = paste("Increasing engine size is \nrelated to decreasing fuel economy")
)

ggplot(mpg, aes(displ, hwy)) +  
  geom_point() +  
  geom_text(    
    aes(label = label),   
    data = label,    
    vjust = "top",    
    hjust = "right"  
    )

## SCALES
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_color_discrete()

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class))

### Axis Ticks and Legend keys
ggplot(mpg, aes(displ, hwy)) + 
  geom_point() +  
  scale_y_continuous(breaks = seq(15, 40, by = 5))
## This shows only the relevant ticks from 15 to 40

ggplot(mpg, aes(displ, hwy)) +  
  geom_point() +  
  scale_x_continuous(labels = NULL) +  
  scale_y_continuous(labels = NULL)
## setting labels to NULL prevents the ticks from showing

presidential %>% 
  mutate(id = 33 + row_number()) %>% 
  ggplot(aes(start, id)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_x_date(
    NULL,
    breaks = presidential$start,
    date_labels = "'%y")

### LEGEND LAYOUT
base <- ggplot(mpg, aes(displ, hwy)) +  
  geom_point(aes(color = class))
base + theme(legend.position = "left") 
base + theme(legend.position = "top") 
base + theme(legend.position = "bottom") 
base + theme(legend.position = "right") # the default\
# theme(legend.position = ) is used to decide where the legend should be
# on the graph

ggplot(mpg, aes(displ, hwy)) +  
  geom_point(aes(color = class)) +  
  geom_smooth(se = FALSE) +  theme(legend.position = "bottom") + 
  guides(
    color = guide_legend(     
      nrow = 1,      
      override.aes = list(size = 2)))
# guides with guide_legend can be used to tweak the legends

## REPLACING A SCALE
ggplot(diamonds, aes(carat, price)) +  
  geom_bin2d()
ggplot(diamonds, aes(log10(carat), log10(price))) +  
  geom_bin2d()
ggplot(diamonds, aes(carat, price)) +  
  geom_bin2d() +  
  scale_x_log10() +  
  scale_y_log10()
# a scale can be transformed with the use of scale_x_<TAB> or scale_y_<TAB>

ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = drv))

ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = drv)) +  
  scale_color_brewer(palette = "Set1")
## transforming the color scale

ggplot(mpg, aes(displ, hwy)) +  
  geom_point(aes(color = drv, shape = drv)) +  
  scale_color_brewer(palette = "Set1")

presidential %>% 
  mutate(id = 33 + row_number()) %>%  
  ggplot(aes(start, id, color = party)) +    
  geom_point() +    
  geom_segment(aes(xend = end, yend = id)) + 
  scale_colour_manual(values =c(Republican = "red", Democratic = "blue"))

df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)

ggplot(df, aes(x, y)) +  
  geom_hex() +  
  coord_fixed() 
ggplot(df, aes(x, y)) +  
  geom_hex() +  
  viridis::scale_fill_viridis() +  
  coord_fixed()

## ZOOMING

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5,7), ylim = c(10,30))
mpg %>%  
  filter(displ >= 5, displ <= 7, hwy >= 10, hwy <= 30) %>% 
  ggplot(aes(displ, hwy)) +  
  geom_point(aes(color = class)) +  
  geom_smooth()

suv <- mpg %>% filter(class == "suv") 
compact <- mpg %>% filter(class == "compact")
ggplot(suv, aes(displ, hwy, color = drv)) +  geom_point()
ggplot(compact, aes(displ, hwy, color = drv)) +  geom_point()
x_scale <- scale_x_continuous(limits = range(mpg$displ))
y_scale <- scale_y_continuous(limits = range(mpg$hwy)) 
col_scale <- scale_color_discrete(limits = unique(mpg$drv))
# limits can be used to adjust the length of the scale

ggplot(suv, aes(displ, hwy, color = drv)) +  
  geom_point() +  
  x_scale +  
  y_scale +  
  col_scale

ggplot(compact, aes(displ, hwy, color = drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale

## THEMES
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme_bw()
## theme_<TAB> can be used to design the template of the graph

ggsave('new-plot.pdf')
## saves most recent plot