###
# File Import Script ####
###

library(EcotaxaTools)
library(suncalc)

raw_data <- ecopart_import("~/BATS_data/export_all/export_raw_2023", trim_to_zoo = T)

# |- Meta data management -----------------------

# need to edit some stationId by hand
corrected_meta <- read.csv('~/BATS_data/export_all/cast_names_raw.csv')
raw_data$meta$stationid <- corrected_meta$stationid
raw_data$meta$ctd_origfilename <- corrected_meta$ctdref
raw_data$meta$programid <- corrected_meta$proj_id



# apply tod calcs
# There's sometimes I wrote 6 instead of 3 on the latitude
for(i in 1:length(raw_data$meta$latitude)) {
  if(raw_data$meta$latitude[i] > 60) {
    raw_data$meta$latitude[i] <- raw_data$meta$latitude[i] - 30
  }
}

# |- Assign Time of Day -----
raw_data$meta$tod <- rep(NA, nrow(raw_data$meta))
for(i in 1:length(raw_data$meta$tod)) {
  casttime <- raw_data$meta$sampledate[i]
  suntimes <- getSunlightTimes(
    date = as.Date(casttime),
    lat = raw_data$meta$latitude[i],
    lon = raw_data$meta$longitude[i],
    tz = 'UTC'
  )
  
  if(casttime < suntimes$nauticalDawn | casttime > suntimes$nauticalDusk) {
    raw_data$meta$tod[i] <- 'night'
  } else if (casttime > suntimes$nauticalDawn & casttime < suntimes$nauticalDusk) {
    raw_data$meta$tod[i] <- 'day'
  } else {
    raw_data$meta$tod[i] <- 'twilight'
  }
}

# |- Trichodesmium --------------------------------

tricho_only <- raw_data |>
  mod_zoo(func = names_keep, keep_names = 'Trichodesmium', keep_children = T)



saveRDS(tricho_only, './data/00_tricho-casts.rds')
