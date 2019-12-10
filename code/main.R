require(foreach)
require(doMC)

source('~/Dropbox/segregation/r_docs/tract_data_prep.R')
source('~/Dropbox/segregation/r_docs/descriptive_plots.R')
source('~/Dropbox/segregation/r_docs/calc_local_diffs.R')

stats = c("white", "black", "hisp", "other", "totpop")
stat_type = c("sf_", "dp_")
same_type_inputs <- c()
for (agroup in stats) {
  for (atype in stat_type) {
    same_type_inputs <- append(same_type_inputs, paste0(atype, agroup))}}

registerDoMC(8)
cross_sf_dp_neighbor_diff <- foreach (agroup=stats, .combine=cbind, .errorhandling = "pass") %dopar% (crossdiffprocess(agroup))

registerDoMC(8)
same_type_neighbor_diff <- foreach (agroup=same_type_inputs, .combine=cbind, .errorhandling = "pass") %dopar% (diffprocess(agroup))


registerDoMC(8) #STB
DC_DIFF_TCTs <- foreach (agroup=same_type_inputs, .combine=cbind) %dopar% (max_diff_process(agroup))
DC_DIFF_TCTs$idx <- 1:nrow(DC_DIFF_TCTs)
DC$idx <- 1:nrow(DC)
newDC <- merge(DC, DC_DIFF_TCTs, by = "idx")
newDC$rel_change_max_diff_black <- newDC$dp_black_maxdiff/newDC$sf_black_maxdiff
newDC$rel_change_max_diff_white <- newDC$dp_white_maxdiff/newDC$sf_white_maxdiff
newDC$rel_change_max_diff_totpop <- newDC$dp_totpop_maxdiff/newDC$sf_totpop_maxdiff
newDC$abs_rel_change_max_diff_black <- 0
newDC <- newDC %>% mutate(abs_rel_change_max_diff_black = ifelse(rel_change_max_diff_black < 1, 1-rel_change_max_diff_black,rel_change_max_diff_black-1 ))
newDC$abs_rel_change_max_diff_totpop <- 0
newDC <- newDC %>% mutate(abs_rel_change_max_diff_totpop = ifelse(rel_change_max_diff_totpop < 1, 1-rel_change_max_diff_totpop,rel_change_max_diff_totpop-1 ))
newDC$abs_rel_change_max_diff_white <- 0
newDC <- newDC %>% mutate(abs_rel_change_max_diff_white = ifelse(rel_change_max_diff_white < 1, 1-rel_change_max_diff_white,rel_change_max_diff_white-1 ))
st_write(newDC, dsn = "./output_data/DC_W_MAX_DIFFS.geojson", driver = "geoJSON")

neigh_pairs <- cbind(cross_sf_dp_neighbor_diff, same_type_neighbor_diff)
write_csv(cbind(cross_sf_dp_neighbor_diff, same_type_neighbor_diff), "~/Dropbox/segregation/output_data/all_place_to_place_diffs_in_DC.csv")


ggsave(
  filename = "./figures/neigh_pairs_DC_totpop.png",
  qplot(
    (neigh_pairs$sf_totpop_to_sf_totpop - neigh_pairs$dp_totpop_to_dp_totpop) / neigh_pairs$sf_totpop_to_sf_totpop, 
    xlim = c(-1, 1),
    xlab = "",
    main = "Relative Difference Among Adjacent Census Tracts in the DC Metro \nTotal Population"))

ggsave(
  filename = "./figures/neigh_pairs_DC_other.png",
  qplot(
  (neigh_pairs$sf_other_to_sf_other - neigh_pairs$dp_other_to_dp_other) / neigh_pairs$sf_other_to_sf_other, 
  xlim = c(-1, 1),
  xlab = "",
  main = "Relative Difference Among Adjacent Census Tracts in the DC Metro \nOther Race Population"))

ggsave(
  filename = "./figures/neigh_pairs_DC_white.png",
  qplot(
  (neigh_pairs$sf_white_to_sf_white - neigh_pairs$dp_white_to_dp_white) / neigh_pairs$sf_white_to_sf_white, 
  xlim = c(-1, 1),
  xlab = "",
  main = "Relative Difference Among Adjacent Census Tracts in the DC Metro \nWhite  Population"))

ggsave(
  filename = "./figures/neigh_pairs_DC_black.png",
  qplot(
  (neigh_pairs$sf_black_to_sf_black - neigh_pairs$dp_black_to_dp_black) / neigh_pairs$sf_black_to_sf_black, 
  xlim = c(-1, 1),
  xlab = "",
  main = "Relative Difference Among Adjacent Census Tracts in the DC Metro \nBlack Population"))

ggsave(
  filename = "./figures/neigh_pairs_DC_hisp.png",
  qplot(
    (neigh_pairs$sf_hisp_to_sf_hisp - neigh_pairs$dp_hispe_to_dp_hisp) / neigh_pairs$sf_hisp_to_sf_hisp, 
    xlim = c(-1, 1),
    xlab = "",
    main = "Relative Difference Among Adjacent Census Tracts in the DC Metro \nHispanic  Population"))



#DC <- cbind(DC, DC_DIFF_TCTs)
#DC_DIFF_TCTs$diff_ratio = (DC_DIFF_TCTs$dp_max_diff/DC_DIFF_TCTs$sf_max_diff) - 1

#for (agroup in stats) {
#for (atype in stat_type) {
#  astat <- paste0(atype, agroup)
#  pairs_name <- paste0(atype, "to_", atype, agroup)
#  print(paste("starting", pairs_name))
#  #all_pairs_diff(aplace = DC, astat = astat)
#  assign(pairs_name, all_pairs_diff(aplace = DC, astat = astat))
#}}