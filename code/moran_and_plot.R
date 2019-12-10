#Test Spatial Autocorrelation
require(spdep)
DC_w <- poly2nb(DC)
wlist <- nb2listw(DC_w, style="W", zero.policy = TRUE)
nsim <- 999
set.seed(1234)
DC_mi_black <- moran.mc(DC$black_diff, listw=wlist, nsim=nsim, zero.policy = TRUE)
ggsave(
  filename = "./figures/DC_black_pop_difference_moransI.png",
  plot = qplot(DC_mi_black$res[1:nsim],
               main = "DC Spatial Pattern in Differences in the Black pop\nObserved Moran's I Compared 999 Random Maps",
               xlab = ""
               ) + geom_vline(xintercept = DC_mi_black$statistic, col="red")
    )

DC_mi_white <- moran.mc(DC$white_diff, listw=wlist, nsim=nsim, zero.policy = TRUE)
ggsave(
  filename = "./figures/DC_white_pop_difference_moransI.png",
  plot = qplot(DC_mi_white$res[1:nsim],
               main = "DC Spatial Pattern in Differences in the White pop\nObserved Moran's I Compared 999 Random Maps",
               xlab = ""
  ) + geom_vline(xintercept = DC_mi_white$statistic, col="red")
)  

tct_w <- poly2nb(tct)
tct_wlist <- nb2listw(tct_w, style="W", zero.policy = TRUE)
nsim <- 999
set.seed(1234)
US_mi_white <- moran.mc(tct$white_diff, listw=tct_wlist, nsim=nsim, zero.policy = TRUE)
ggsave(
  filename = "./figures/US_white_pop_difference_moransI.png",
  qplot(US_mi_white$res[1:nsim],
        main = "National Spatial Pattern in Differences in the White pop\nObserved Moran's I Compared 999 Random Maps",
        xlab = "") + geom_vline(xintercept = US_mi_white$statistic, col="red")
)


US_mi_totpop <- moran.mc(tct$pop_diff, listw=tct_wlist, nsim=nsim, zero.policy = TRUE)
ggsave(
  filename = "./figures/US_tot_pop_difference_moransI.png",
  qplot(US_mi_totpop$res[1:nsim],
        main = "National Spatial Pattern in Differences in total pop\nObserved Moran's I Compared 999 Random Maps",
        xlab = "") + geom_vline(xintercept = US_mi_totpop$statistic, col="red")
)

US_mi_black <- moran.mc(tct$black_diff, listw=tct_wlist, nsim=nsim, zero.policy = TRUE)
ggsave(
  filename = "./figures/US_black_difference_moransI.png",
  qplot(US_mi_black$res[1:nsim],
        main = "National Spatial Pattern in Differences in black pop\nObserved Moran's I Compared 999 Random Maps",
        xlab = "") + geom_vline(xintercept = US_mi_black$statistic, col="red")
)
