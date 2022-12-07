###
# File Import Script ####
###

library(EcotaxaTools)

raw_data <- ecopart_import("~/BATS_data/export_all/raw_export", trim_to_zoo = T)

# |- Meta data management -----------------------

# need to edit some stationId by hand
corrected_meta <- read.csv('~/BATS_data/export_all/cast_names_raw.csv')
raw_data$meta$stationid <- corrected_meta$stationid
raw_data$meta$ctd_origfilename <- corrected_meta$ctdref
raw_data$meta$programid <- corrected_meta$proj_id

# |- Trichodesmium --------------------------------

tricho_only <- raw_data |>
  mod_zoo(func = names_keep, keep_names = 'Trichodesmium', keep_children = T)


saveRDS(tricho_only, './data/00_tricho-casts.rds')
