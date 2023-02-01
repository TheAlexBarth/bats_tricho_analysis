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

# Integrate cast profiles

intg_casts <-tricho_conc |>
    lapply(integrate_all, need_format= TRUE, subdivisions=1000) |>
      lapply(intg_to_tib) |>
        list_to_tib('profileid')


# Average casts by station
avg_tricho <- average_casts(name_map=name_map, zoo_conc_list = tricho_conc)


# Create a plot for the average profile
s
  
#