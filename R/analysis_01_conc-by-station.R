###
# Organize Profiles by Station #########
###
rm(list = ls())

# Read in the 20m bin data
tricho_conc <- readRDS('./data/01_trich-conc-20Bins.rds')
metadata <- readRDS('./data/01_tricho-trim-cast.rds')$meta

# Define names for casts to match by station
name_map <- list(
  hs = metadata$profileid[metadata$stationid == 'hs'],
  gf = metadata$profileid[which(metadata$stationid == 'gf' |
                                  metadata$stationid == 'bloom')]
)

# Average casts by station


# Integrate cast profiles
  
# Create a plot for the average profile
s
  
#