###
# Organize Profiles by Station #########
###
rm(list = ls())
library(EcotaxaTools)
library(dplyr)
library(ggplot2)
library(FSA)

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

intg_casts <- tricho_conc |>
    lapply(integrate_all, need_format= TRUE, subdivisions=1000) |>
      lapply(intg_to_tib) |>
        list_to_tib('profileid')

intg_casts <- metadata |>
  select(c(profileid, stationid)) |> 
  right_join(intg_casts, by = 'profileid')

# rename bloom casts for gf
# -

avg_intg <- intg_casts |> 
  group_by(stationid) |> 
  summarize(mean = mean(intg),
            sd = sd(intg))


# Plotting average integrated abundance

# create histogram for gf casts integrates - use intg_casts

ggplot(data= intg_casts[intg_casts$stationid=="gf",]) +
  geom_density(aes(x=intg))

# create histogram for hs casts integrates - use intg_casts

ggplot(data= intg_casts[intg_casts$stationid=="hs",]) +
  geom_density(aes(x=intg))

# create additional density plot for averages

ggplot(data= intg_casts[intg_casts$stationid!="bloom",]) +
  geom_density(aes(x=intg, color=stationid))

# create bar plot of the medians
    #standardize first from avg intg above, THEN plot

median_intg <- intg_casts |> 
  group_by(stationid) |> 
  summarize(median = median(intg),
            sd = sd(intg))

ggplot(data=median_intg)+
    geom_bar(aes(x=stationid, y=median),
             stat="identity")+
    theme_gray()+
    labs(x="Station", y="Median Integrated Trichodesmium abundance (# colonies/m^2)")

# Average casts by station
avg_tricho <- average_casts(name_map=name_map, zoo_conc_list = tricho_conc)


#TESTS to compare the medians (all observations on one group vs all in the other, NOT using medians)
    #1. Kruskal-Wallis test (like an ANOVA)
      kruskal.test(intg~stationid,
                   data=intg_casts)
        #resulting p-value of 0.003638 tells us the groups are very different. (0.03% chance they'd be the same)
      
    #then run library(FSA) up top
      
    #2. Dunn test (compares group wise, to see specifically WHICH groups are different from EACH OTHER.)
        dunnTest(intg~stationid,
                 data=intg_casts,
                 method='bonferroni')
        #interested in the adjusted p-value, see that bloom is significantly different from gf, bloom is NOT significantly different from hs, gf NOT significantly diff from hs.
        #means we also could group gf and hs for profiles.
      


  
#