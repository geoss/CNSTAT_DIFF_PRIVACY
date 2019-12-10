#Prep Tract Data

library(tidyverse)
library(here)
library(OasisR)
library(sf)
data_path <- here("data/")

# load nhgis extract to create tract to CBSA crosswalk 
tct_cbsa_xwalk <- read_csv(paste0(data_path, "nhgis1263_ds172_2010_tract.csv"), 
                           col_types = "ccccccccccccccccccccccccccccccccccccccci")

# join type to xwalk and then keep only gisjoin, cbsa and type
tct_cbsa_xwalk <- tct_cbsa_xwalk %>%
  select(GISJOIN, CBSAA)


# This chunk creates a small df that classifies each CBSA into micro vs. metro area

# assign type (micro vs. metro) to each CBSAA
cbsa_type <- read_csv(paste0(data_path, "wide_dp1_310.csv"))
cbsa_type <- cbsa_type %>%
  mutate(CBSAA = str_sub(gisjoin, 2,6),
         type = case_when(str_detect(name_dp, "Micro") ~ "Micro",
                          str_detect(name_dp, "Metro") ~ "Metro")) %>%
  select(CBSAA, type)

# load wide_dp1_140.csv into df 
df <- read_csv(paste0(data_path, "wide_dp1_140.csv"))

#This chunk retains necessary columns for segregation computation. I only need to keep the P5 variables (H7Z* variables).
pop_data <- df %>%
  mutate(dp_totpop = H7Z001_dp,
         dp_white = H7Z003_dp,
         dp_black = H7Z004_dp,
         dp_other = H7Z005_dp + H7Z006_dp + H7Z007_dp + H7Z008_dp + H7Z009_dp,
         dp_hisp = H7Z010_dp,
         sf_totpop = H7Z001_sf,
         sf_white = H7Z003_sf,
         sf_black = H7Z004_sf,
         sf_other = H7Z005_sf + H7Z006_sf + H7Z007_sf + H7Z008_sf + H7Z009_sf,
         sf_hisp = H7Z010_sf) %>%
  select(gisjoin, dp_totpop:sf_hisp)

# This chunk joins the tct_cbsa crosswalk to the pop_data df
pop_data <- pop_data %>%
  left_join(tct_cbsa_xwalk, by=c("gisjoin" = "GISJOIN"))

# This chunk creates a list (vector) of unique CBSAs. I will use it to loop over all CBSAs to compute seg indices
cbsa <- pop_data %>%
  filter(CBSAA != "99999") %>%
  distinct(CBSAA) 

cbsa_list <- cbsa$CBSAA


# This chunk reads in the tract shapefile as a sf object

tct <- st_read(paste0(data_path, "US_tract_2010.shp"))
# This chunk joins the pop_data df to the shapfile

tct <- tct %>%
  left_join(pop_data, by=c("GISJOIN" = "gisjoin"))
rm(df)
rm(pop_data)
rm(tct_cbsa_xwalk)

tct$pop_diff = tct$dp_totpop - tct$sf_totpop
tct$white_diff = tct$dp_white - tct$sf_white
tct$black_diff = tct$dp_black - tct$sf_black
tct$hisp_diff = tct$dp_hisp - tct$sf_hisp
tct$other_diff = tct$dp_other - tct$sf_other

#make some DC
DC <- subset(tct, tct$CBSAA==47900)
