## FACTORS WITH FORCATS

library(tidyverse)
## install.packages('forcats')
library(forcats)

## CREATING FACTORS
x1 <- c("Dec", "Apr", "Jan", "Mar") 

sort(x1)
month_levels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun",  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec") # creating a level
y1 <- factor(x1, levels = month_levels) 
y1
x2 <- c("Dec", "Apr", "Jam", "Mar") 
library(readr)
y2 <- parse_factor(x2, levels = month_levels) 
factor(x1) ## using factor without levels, sets the levels in alphabetical order
f1 <- factor(x1, levels = unique(x1)) 
f1 
f2 <- x1 %>% 
  factor() %>% 
  fct_inorder()
f2
levels(f2) 

## GENERAL SOCIAL SURVEY
gss_cat
gss_cat %>%
  count(race)
ggplot(gss_cat, aes(race)) +  geom_bar()
ggplot(gss_cat, aes(race)) +  geom_bar() +  scale_x_discrete(drop = FALSE)

## Exercise
select(gss_cat, rincome)
ggplot(gss_cat, aes(rincome)) + geom_bar() + coord_flip() + labs(x = "Respondents' Income")
?ticks

gss_cat %>%
  count(relig, sort = TRUE)
gss_cat %>%
  count(partyid, sort = TRUE)
select(gss_cat, relig, denom)
gss_cat %>%
  count(denom, relig, sort = TRUE) 
ggplot(gss_cat, aes(relig,denom)) + geom_count() + coord_flip() + theme(axis.text.x = element_text(angle = 90))

## MODIFYING FACTOR ORDER
relig1 <- gss_cat %>%  
  group_by(relig) %>%  
  summarize(age = mean(age, na.rm = TRUE), tvhours = mean(tvhours, na.rm = TRUE), n = n())
relig1
ggplot(relig1, aes(tvhours, relig)) + geom_point()
ggplot(relig1, aes(tvhours, fct_reorder(relig, tvhours))) +  geom_point()
relig1 %>%  
  mutate(relig = fct_reorder(relig, tvhours)) %>% 
  ggplot(aes(tvhours, relig)) + geom_point() 
rincome1 <- gss_cat %>%  
  group_by(rincome) %>%  
  summarize(age = mean(age, na.rm = TRUE), tvhours = mean(tvhours, na.rm = TRUE), n = n())
ggplot(rincome1, aes(age, fct_reorder(rincome, age))) + geom_point() ## fct_reorder reorders the entire level based on a continuous variable
ggplot(rincome1, aes(age, fct_relevel(rincome, "Not applicable"))) +  geom_point() ## fct_relevel moves the element to the beginning of the levels
by_age <- gss_cat %>%  
  filter(!is.na(age)) %>%  
  group_by(age, marital) %>%  
  count() %>%  
  mutate(prop = n / sum(n))
ggplot(by_age, aes(age, prop, color = marital)) +  geom_line(na.rm = TRUE)
ggplot(by_age, aes(age, prop, color = fct_reorder2(marital, age, prop))) + geom_line() + labs(color = "marital") 
gss_cat %>%  
  mutate(marital = marital %>% 
           fct_infreq() %>% 
           fct_rev()) %>%  
  ggplot(aes(marital)) + geom_bar()

sd(gss_cat$tvhours, na.rm = TRUE)

## Exerise
## It is a good summary as the values do not deviate so much from each other
levels(gss_cat$marital) ## arbitrary
summary(gss_cat)
levels(gss_cat$race) ## principled
levels(gss_cat$rincome) ## arbitrary
levels(gss_cat$partyid) ## arbitrary
levels(gss_cat$relig) ## principled
levels(gss_cat$denom) ## principled

## It gets to the bottom of the plot because ggplot outputs the graph based on how the levels are primarily ordered i.e from first to last in ascending order

## MODIFYING FACTOR LEVELS
gss_cat %>%
  count(partyid) 
gss_cat %>%  
  mutate(partyid = fct_recode(partyid,"Republican, strong" = "Strong republican","Republican, weak" = "Not str republican","Independent, near rep" = "Ind,near rep", "Independent, near dem" = "Ind,near dem", "Democrat, weak" = "Not str democrat",  "Democrat, strong" = "Strong democrat")) %>%  ## fct_recode is used to rename the factor levels 
  count(partyid)
gss_cat %>%  
  mutate(partyid = fct_recode(partyid,"Republican, strong" = "Strong republican", "Republican, weak" = "Not str republican","Independent, near rep" = "Ind,near rep","Independent, near dem" = "Ind,near dem","Democrat, weak" = "Not str democrat","Democrat, strong" = "Strong democrat", "Other" = "No answer","Other" = "Don't know", "Other" = "Other party")) %>% ## fct_recode can also be used to combine levels under a new one  
  count(partyid) 
gss_cat %>%  
  mutate(partyid = fct_collapse(partyid, other = c("No answer", "Don't know", "Other party"),rep = c("Strong republican", "Not str republican"), ind = c("Ind,near rep", "Independent", "Ind,near dem"),dem = c("Not str democrat", "Strong democrat"))) %>%  ## fct_collapse works like fct_recode but combines all the levels using a vector
  count(partyid)
gss_cat %>%  
  mutate(relig = fct_lump(relig)) %>% ## fct_lump() is used to bring all the smaller levels together
  count(relig)
gss_cat %>%  
  mutate(relig = fct_lump(relig, n = 10)) %>%  ## n signifies how many groups we intend to keep
  count(relig, sort = TRUE) %>%  
  print(n = Inf) 

## Exercise
levels(gss_cat$rincome)
gss_cat %>%
  mutate(rincome = fct_collapse(rincome, inconcl = c("No answer", "Don't know", "Refused"), zero_to_10000 = c("$10000 - 14999", "$8000 to 9999",  "$7000 to 7999",  "$6000 to 6999","$5000 to 5999","$4000 to 4999","$3000 to 3999","$1000 to 2999","Lt $1000"), fifteen_to_25000 = c("$25000 or more","$20000 - 24999","$15000 - 19999"),N_A = "Not applicable")) %>%
  count(rincome, sort = TRUE)
