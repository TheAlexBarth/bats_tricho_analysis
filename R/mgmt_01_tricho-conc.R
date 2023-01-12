# RScript to find concentration of trichodesmium

# Delete any lingering files in your environment
rm(list = ls()) # this is good practice if you have multiple scripts!

# Read in Libraries
library(EcotaxaTools)
 
# Read in trichodesium raw observations
trich_data<- readRDS('./data/00_tricho-casts.RDS')

# |- Section for dropping ctd casts ----------------------


# trim UVP to only have above 500m
trich_data <- trich_data |> trim_ecopart_depth(500)


# There are some casts with no trichodesmium observations
# this prevents us from renaming those files, so we have to remove 
# casts where there were no trichodesium files

# Find any casts with no-tricho and assign it to an index called drop_casts
# This is a big chain of functions, each action is ran sequentally and passed on
drop_casts <- trich_data$zoo_files |> # take trichodesmium zoo_files
  sapply(nrow) |> # get the number of rows in each cast (how many tricho were observed)
  sapply(function(x) x == 0) |> # Where is it equal to 0?
  which() |>  #get the numeric index of those equal to 0
  names() # get the names just as a character vector

# Put an if statements for safety, if there are no casts to drop - this should skip
if(length(drop_casts) > 0) {
  
  # drop the par_files correponding to those casts
  trich_data$par_files <- trich_data$par_files[which(!(names(trich_data$par_files) %in% drop_casts))]
  # drop zoo_files corresponding
  trich_data$zoo_files <- trich_data$zoo_files[which(!(names(trich_data$zoo_files) %in% drop_casts))]
  # remove those casts from the metadata document
  trich_data$meta <- trich_data$meta[which(!(trich_data$meta$profileid %in% drop_casts)),]
}

# restore class structure to the object
# Note for alex: if package is fixed to true S3 structure, this might be obsolete
trich_data <- as_ecopart_obj(trich_data)


# |- Final Data Formatting -------------------------------

# renaming all trichodesmium to tricho
trich_data<-trich_data |>
  add_zoo(func=names_to, 
          col_name = "name", 
          new_names="Trichodesmium",
          suppress_print=TRUE)
  
# Get concentration of trichodesmium!
# Try multiple depth bins!

trich_conc <- trich_data |>
  uvp_zoo_conc(breaks = c(0,100,200,500))

# Try with a sequence of 20m depth bins, breaks must equal
# all values 0-500 in 20m intervals. name it trich_conc_20mBin

# Try again with 50m. trich_conc_50mBin

               