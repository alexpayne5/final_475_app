library('fpp3')
library('tsibble')
library('shiny')
library('dplyr')
library('ggplot2')
library('shinydashboard')
library('DT')

options <- c('seasonality', 'autocorrelation', 'decomposition')

data("us_change")