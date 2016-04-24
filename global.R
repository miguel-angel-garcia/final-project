# File: global.R
# Description: Data process for the Shiny app.
# Author: Miguel Ángel García
# Course: Coursera - Data Science Specialization - Final Project

# Inits libraries needed
library(shiny)
library(shinythemes)
library(quanteda)
library(data.table)
library(dplyr)

# Loads the prediction function and the data
source("prediction.R")
load("data/collTextDT.rda")