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
  average_casts(name_map = tod_map) |> 
  lapply(bin_format)
 
#ggplot here 

ggplot()+
  geom_rect(data = avg_conc$night,colour = "#232323",fill="#FADADD",
            aes(xmin = min_d, xmax = max_d,
                ymin = 0, ymax = -mean)) +
  geom_errorbar(data = avg_conc$night,
                aes(x = mp, ymin = -mean, ymax = -(mean+sd)),
                alpha = .25) +
  geom_rect(data = avg_conc$day,colour = "#232323",fill="#FFA7A6",
            aes(xmin = min_d, xmax = max_d,
                ymin = 0, ymax = mean)) +
  geom_errorbar(data = avg_conc$day,
                aes(x = mp, ymin = mean, ymax = (mean+sd)),
                alpha = .25)+
  labs(x = 'Depth [m]', y = 'Concentration [colonies/m3]')+
  coord_flip()+
  scale_x_reverse(expand = c(0,0))+
  scale_y_continuous(position = 'right',
                     labels = abs) +
    theme_gray() 

