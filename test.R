readRDS('./data/00_tricho-casts.RDS')
bin_format()
cast1_copepod_conc <- ecopart_obj |>
uvp_zoo_conc(cast_name='bats_tricho_analysis', breaks=seq(0,500,100), func_col='biovol',func=sum)
