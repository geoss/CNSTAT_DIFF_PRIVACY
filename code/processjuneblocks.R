# Get data from NHGIS
states <-  c("AL", "AK",  "AZ", "AR",  "CA", "CO",  "CT", "DE",  "DC", "FL",  "GA", "HI",  "ID", "IL",  "IN", "IA",  "KS", "KY",  "LA", "ME",  "MD", "MA",  "MI", "MN",  "MS", "MO",  "MT", "NE",  "NV", "NH",  "NJ", "NM",  "NY", "NC",  "ND", "OH",  "OK", "OR",  "PA", "RI",  "SC", "SD",  "TN", "TX",  "UT", "VT",  "VA", "WA",  "WV", "WI", "WY")

urlPattern <- 'https://assets.nhgis.org/differential-privacy/v20210608/nhgis_ppdd_20210608_block_'
urlextension <- '.zip'

buildNHGISurl <- function(state, aurlPattern = urlPattern, aurlextension = urlextension) paste0(aurlPattern,state,aurlextension)
dowload_list <- function(file_list) {
  return(lapply(download.file(file_list)))
}
dfiles <- sapply(states, buildNHGISurl, USE.NAMES = FALSE)

for (i in dfiles) download.file(i, destfile = paste0('/Users/sesp7465/Dropbox/CNSTAT_DIFF_PRIVACY/data/blocks020821/', substring(i, 57, 84), '.zip'), method = 'wget')

for (i in list.files('/Users/sesp7465/Dropbox/CNSTAT_DIFF_PRIVACY/data/blocks020821/', pattern = '.*(.zip)')){
  uzcmd <- paste0("unzip -o /Users/sesp7465/Dropbox/CNSTAT_DIFF_PRIVACY/data/blocks020821/", i, " -d /Users/sesp7465/Dropbox/CNSTAT_DIFF_PRIVACY/data/")
  system(uzcmd)
}

# NHGIS BLOCK FILES
# H72001:      Total
# H72003:      Population of one race: White alone
# H72004:      Population of one race: Black or African American alone
# H72005:      Population of one race: American Indian and Alaska Native alone
# H72006:      Population of one race: Asian alone
# H72007:      Population of one race: Native Hawaiian and Other Pacific Islander alone
# H72008:      Population of one race: Some Other Race alone
# H72009:      Two or More Races
# H73002:      Hispanic or Latino

sfiles <- paste0('/Users/sesp7465/Dropbox/CNSTAT_DIFF_PRIVACY/data/processed_blocks/nhgis_ppdd_20210608_block_', states, '.csv')

for (afile in sfiles){
  print(afile)
  
  #read head
  astate <- read.csv(afile, nrows = 10)
  #exit loop if file alread processed
  if("white_popchange" %in% colnames(astate)){
    print(dim(astate))
    next
  }
  
  astate <- read.csv(afile)
  
  #compute pop change by race + hispanic
  astate$white_popchange    <- astate$H72003_dp - astate$H72003_sf
  astate$black_popchange    <- astate$H72004_dp - astate$H72004_sf
  astate$aian_popchange     <- astate$H72005_dp - astate$H72005_sf
  astate$asian_popchange    <- astate$H72006_dp - astate$H72006_sf
  astate$nhpi_popchange     <- astate$H72007_dp - astate$H72007_sf
  astate$other_popchange    <- astate$H72008_dp - astate$H72008_sf
  astate$twoplus_popchange  <- astate$H72009_dp - astate$H72009_sf
  astate$hispanic_popchange <- astate$H73002_dp - astate$H73002_sf

  #compute percent by race + hispanic for dp
  astate$white_pct_dp       <- astate$H72003_dp/astate$H72001_dp
  astate$black_pct_dp       <- astate$H72004_dp/astate$H72001_dp
  astate$aian_pct_dp        <- astate$H72005_dp/astate$H72001_dp
  astate$asian_pct_dp       <- astate$H72006_dp/astate$H72001_dp
  astate$nhpi_pct_dp        <- astate$H72007_dp/astate$H72001_dp
  astate$other_pct_dp       <- astate$H72008_dp/astate$H72001_dp
  astate$twoplus_pct_dp     <- astate$H72009_dp/astate$H72001_dp
  astate$hispanic_pct_dp    <- astate$H73002_dp/astate$H72001_dp
  
  #compute percent by race + hispanic for sf
  astate$white_pct_sf       <- astate$H72003_sf/astate$H72001_sf
  astate$black_pct_sf       <- astate$H72004_sf/astate$H72001_sf
  astate$aian_pct_sf        <- astate$H72005_sf/astate$H72001_sf
  astate$asian_pct_sf       <- astate$H72006_sf/astate$H72001_sf
  astate$nhpi_pct_sf        <- astate$H72007_sf/astate$H72001_sf
  astate$other_pct_sf       <- astate$H72008_sf/astate$H72001_sf
  astate$twoplus_pct_sf     <- astate$H72009_sf/astate$H72001_sf
  astate$hispanic_pct_sf    <- astate$H73002_sf/astate$H72001_sf
  
  #compute change in race group as a percent of that races total pop in 2010
  astate$white_pct_change <- astate$white_popchange/astate$H72003_sf
  astate$black_pct_change <- astate$black_popchange/astate$H72004_sf
  astate$aian_pct_change <- astate$aian_popchange/astate$H72005_sf
  astate$asian_pct_change <- astate$asian_popchange/astate$H72006_sf
  astate$nhpi_pct_change <- astate$nhpi_popchange/astate$H72007_sf
  astate$other_pct_change <- astate$other_popchange/astate$H72008_sf
  astate$twoplus_pct_change <- astate$twoplus_popchange/astate$H72009_sf
  astate$hispanic_pct_change <- astate$hispanic_popchange/astate$H73002_sf
  
  #TODO variables to save c("X", "gisjoin", "name", "state",     
  
  write.csv(astate, file = afile) }

