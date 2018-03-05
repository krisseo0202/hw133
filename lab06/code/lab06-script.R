# ===================================================================
# Title: Cleaning Data
# Description:
#   This script performs manipulating and visualizing data frames.
# Input(s): data file 'raw-data.csv'
# Output(s): data file 'clean-data.csv'
# Author: Kris Seo
# Date: 3-2-2018
# ===================================================================

library(readr)    
library(dplyr)    
library(ggplot2)


dat <- read_csv('/users/krisseo/hw133/lab06/data/nba2017-players.csv')
warriors <- filter(dat , team == 'GSW')
warriors_sorting_sal <- warriors[with(warriors, order(salary)), ]

write.csv(warriors_sorting_sal, file = "/users/krisseo/hw133/lab06/data/warriors.csv",row.names=FALSE)

lakers <- filter(dat , team == 'LAL')
lakers_sorting_sal <- lakers[with(lakers, order(-experience)), ]
write.csv(lakers_sorting_sal, file = "/users/krisseo/hw133/lab06/data/lakers.csv",row.names=FALSE)

##Exporting some R output

sink(file = '/users/krisseo/hw133/lab06/output/data-structure.txt')
str(dat['player'])
sink()

sink(file = '/users/krisseo/hw133/lab06/output/summary-warriors.txt')
summary(warriors)
sink()

sink(file = '/users/krisseo/hw133/lab06/output/summary-lakers.txt')
summary(lakers)
sink()

png(filename = "/users/krisseo/hw133/lab06/images/scatterplot-height-weight.png")
plot(dat$height, dat$weight, pch = 20, 
     xlab = 'Height', ylab = 'Height')
dev.off()

png(filename = "/users/krisseo/hw133/lab06/images/high-res-scatterplot-height-weight.png", res = 300)
plot(dat$height, dat$weight, pch = 20, 
     xlab = 'Height', ylab = 'Height')
dev.off()

jpeg(filename = "/users/krisseo/hw133/lab06/images/age.png", width = 600, height = 400)
hist(dat$age, main="Histogram for Age of Players", xlab="Age")
dev.off()

pdf(file = "/users/krisseo/hw133/lab06/images/age.pdf" , width = 7, height = 5)
hist(dat$age, main="Histogram for Age of Players", xlab="Age")
dev.off()




gg_pts_salary <-ggplot(dat, aes(x=points, y=salary)) + geom_point()
ggsave(filename = "/users/krisseo/hw133/lab06/images/points_salary.pdf", width = 7 , height = 5, units = 'in')

gg_ht_wt_positions <- ggplot(dat, aes(x = height, y= weight)) + geom_point()
gg_ht_wt_positions + facet_grid(position ~ .)
ggsave(filename = "/users/krisseo/hw133/lab06/images/height_weight_by_position.pdf", width = 6 , height = 4, units = 'in')

#display the player names of Lakers 'LAL'.
print(dat %>% 
  group_by(player)
)

#display the name and salary of GSW point guards 'PG'.
pg_gsw <- dat %>%
  filter(grepl('GSW',team), position == 'PG') %>%
  select(player,salary)
print(pg_gsw)

#dislay the name, age, and team, of players with more than 10 years of experience, making 10 million dollars or less.
more_making_10 <- dat %>%
  filter(experience > 10 & salary <= 10000000) %>%
  select(player,age,team)

print(more_making_10)


#select the name, team, height, and weight, of rookie players, 20 years old, displaying only the first five occurrences (i.e. rows).
rookie_20 <- dat %>%
  filter(grepl(1, experience), age == 20) %>%
  select(player,team,height,weight)

print(head(rookie_20,5))

#create a data frame gsw_mpg of GSW players, that contains variables for player name, experience, and min_per_game (minutes per game), sorted by min_per_game (in descending order).
min_per_game <- glimpse(mutate(dat,min_per_game = minutes/games))
gsw_mpg <- min_per_game %>%
  filter(team == 'GSW') %>%
  select(player, experience, min_per_game) %>%
  arrange(desc(min_per_game))
print(gsw_mpg)
  
#display the average triple points by team, in ascending order, of the bottom-5 teams (worst 3pointer teams).
avg_triple <- dat %>%
  group_by(team) %>%
  select(points3) %>%
  summarise(avg_3pts = mean(points3,na.rm = TRUE)) %>%
  arrange(avg_3pts)
print(head(avg_triple,5))

#obtain the mean and standard deviation of age, for Power Forwards, with 5 and 10 years (including) of experience.
avg_pf_5_yr <- dat %>%
  filter(experience == 5 & position == 'PF') %>%
  select(age) %>%
  summarise (
    avg_age = mean(age, na.rm = TRUE),
    sd_age = sd(age, na.rm = TRUE)
  )

avg_pf_10_yr <- dat %>%
  filter(experience == 10 & position == 'PF') %>%
  select(age) %>%
  summarise (
    avg_age = mean(age, na.rm = TRUE),
    sd_age = sd(age, na.rm = TRUE)
  )




