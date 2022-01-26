########################################
# read csv data from github
########################################

library(tidyverse)
source("theme-vsgls.R")
filedateprefix <- format(Sys.time(), "%Y%m%d")
figdirprefix <- '../figs/'

# data explanation and usage:
# https://fivethirtyeight.com/videos/the-ultimate-halloween-candy-power-ranking/

# data:
# https://github.com/fivethirtyeight/data/tree/master/candy-power-ranking

datraw <- read_csv(file='https://github.com/fivethirtyeight/data/raw/master/candy-power-ranking/candy-data.csv')

summary(datraw)

# nice. formatted and clean data. Except for the crappy apostrophes. Meh. Change that.

dat <- datraw %>%
		mutate(competitorname = as.factor(gsub("Õ", "\'", competitorname)))
