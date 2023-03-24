###
rm(list = ls())
library(EcotaxaTools)
library(dplyr)
library(ggpubr)
library(ggplot2)
library(FSA)
library(lubridate)

# Read in the 20m bin data
tricho_conc <- readRDS('./data/01_trich-conc-20Bins.rds')
metadata <- readRDS('./data/01_tricho-trim-cast.rds')$meta


# Integrate cast profiles

intg_casts <- tricho_conc |>
  lapply(integrate_all, need_format= TRUE, subdivisions=1000) |>
  lapply(intg_to_tib) |>
  list_to_tib('profileid')

#create month
metadata$month <- month(metadata$sampledate)

intg_casts <- metadata |>
  select(c(profileid, stationid, month)) |> 
  right_join(intg_casts, by = 'profileid')

#rename bloom to gf
intg_casts$stationid[intg_casts$stationid == 'bloom'] <- 'gf'

# average out
mo_intg_tricho <- intg_casts |> 
  group_by(stationid, month) |> 
  summarize(mean_intg = mean(intg),
            sd = sd(intg))

# Plot
# create a bar plot

# x=  month, y=mean_intg
# you might want to use x=as.factor(month)
