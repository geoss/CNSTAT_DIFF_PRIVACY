require(sf)

# NOTES: GOAL is for a focal geomatery to find the determine if how the most differetn neighor changes
# one way to do this is to simply note if the most different geometry changes 
# another way to do this is look at the differences in sf and dp values...
# for the latter option needs to thik it through

a_place_diff <- function(focal_geom, area_geoms = DC, astat = "sf_white"){
  nlist <- st_touches(focal_geom, area_geoms)
  focal_stat <- pull(focal_geom, astat)
  neigh_stats <- pull(area_geoms[nlist[[1]],], astat)
  neigh_diff <- focal_stat - neigh_stats
  if (length(neigh_diff) == 0) neigh_diff <- NA
  return(neigh_diff)
}

all_pairs_diff <- function(astat, aplace = DC){
  pb <- txtProgressBar(style = 3, min=1, max = nrow(aplace))
  astat_to_astat_pairs <- vector()
  for (i in 1:nrow(aplace)){
    pairs_list_sf <- a_place_diff(aplace[i,], aplace, astat)
    astat_to_astat_pairs <- append(astat_to_astat_pairs, pairs_list_sf)
    setTxtProgressBar(pb, i)
  }
  close(pb)
  return(astat_to_astat_pairs)
} 

a_place_diff_cross <- function(focal_geom, area_geoms = DC, astat = "white"){
  sf_stat = paste0("sf_", astat)
  dp_stat = paste0("dp_", astat)
  nlist <- st_touches(focal_geom, area_geoms)
  focal_sf <- pull(focal_geom, sf_stat)
  neigh_stat_dp <- pull(area_geoms[nlist[[1]],], dp_stat)
  neigh_diff_sf_to_dp <- focal_sf - neigh_stat_dp
  if (length(neigh_diff_sf_to_dp) == 0){
    neigh_diff_sf_to_dp <- NA }
  return(neigh_diff_sf_to_dp)
}

all_pairs_cross_diff <- function(astat, aplace = DC){
  pb <- txtProgressBar(style = 3, min=1, max = nrow(aplace))
  astat_to_astat_pairs <- vector()
  for (i in 1:nrow(aplace)){
    pairs_list_cross <- a_place_diff_cross(aplace[i,], aplace, astat)
    astat_to_astat_pairs <- append(astat_to_astat_pairs, pairs_list_cross)
    setTxtProgressBar(pb, i)
  }
  close(pb)
  return(astat_to_astat_pairs)
} 

maxdiff <- function(focal_geom, area_geoms = DC, astat) {
  nlist <- st_touches(focal_geom, area_geoms)
  maxdiffs <- data.frame()
      neigh_diff <-
        pull(focal_geom, astat) - pull(area_geoms[nlist[[1]], ], astat)
      #dp_neighbor_diff <- pull(focal_geom, dp_stat) - pull(area_geoms[nlist[[1]],], dp_stat)
      max_stat_name <- paste0(astat, "_neigh_max")
      if (length(neigh_diff) == 0){
        maxdiffs[1, max_stat_name] <- NA
      } else {
        max_abs_diff <- neigh_diff[which.max(abs(neigh_diff))]
        maxdiffs[1, max_stat_name] <- max_abs_diff
        }
  return(maxdiffs)
}

all_max_diffs <- function(area_geoms = DC, astat){
  pb <- txtProgressBar(style = 3, min=1, max = nrow(area_geoms))
    maxes <- data.frame()
    for (i in 1:nrow(area_geoms)){
      max_diff_place <- maxdiff(area_geoms[i,], area_geoms, astat)
      maxes <- rbind(maxes, max_diff_place)
      setTxtProgressBar(pb, i)
    }
    close(pb)
    names(maxes) = paste0(astat, "_maxdiff")
    return(maxes)
} 

max_diff_process <- function(agrouptype){
  tmp_df <- all_max_diffs(area_geoms = DC[,], astat = agrouptype)
  return(tmp_df)
}

crossdiffprocess <- function(agroup){
  pairs_name <- paste0("sf_to_dp_", agroup)
  tmp_df <- data.frame(all_pairs_cross_diff(agroup, aplace = DC[,]))
  names(tmp_df) <- pairs_name
  return(tmp_df)
} 

diffprocess <- function(agrouptype){
  pairs_name <- paste0(agrouptype, "_to_", agrouptype)
  tmp_df <- data.frame(all_pairs_diff(aplace = DC[,], astat = agrouptype))
  names(tmp_df) <- pairs_name
  return(tmp_df)
} 
