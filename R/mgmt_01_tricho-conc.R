library(EcotaxaTools)

readRDS('./data/00_tricho-casts.RDS')

trich_data<- readRDS('./data/00_tricho-casts.RDS')

#renaming all trichodesmium
trich_data<-trich_data |>
  add_zoo(func=names_to, col_name = "name", new_names="Trichodesmium",suppress_print=TRUE)
  
trich_conc <- trich_data |>
  uvp_zoo_conc(breaks = c(0,100,200,500,1200))



               