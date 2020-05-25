getwd()
library(tidyverse)
ggplot(diamonds, aes(carat, price)) +  geom_hex() 
ggsave("diamonds.pdf") ## for saving as pdf
write_csv(diamonds, "diamonds.csv") ## for saving as csv