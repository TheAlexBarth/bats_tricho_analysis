###
rm(list = ls())
library(EcotaxaTools)
library(dplyr)
library(ggpubr)
library(ggplot2)
library(FSA)

# Read in the 20m bin data
tricho_conc <- readRDS('./data/01_trich-conc-20Bins.rds')
metadata <- readRDS('./data/01_tricho-trim-cast.rds')$meta

# Define names for casts to match by station
tod_map <- list(
  night = metadata$profileid[metadata$tod == 'night'],
  day = metadata$profileid[which(metadata$tod == 'day')]
)

# Average Casts by station

avg_conc <- tricho_conc |> 
  average_casts(name_map = station_map) |> 
  lapply(bin_format)

