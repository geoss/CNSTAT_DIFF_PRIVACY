# Descriptive Plots
require(ggplot2)

if (exists("tct")){
  print("tract data loaded already")
} else {
  source("~/Dropbox/segregation/r_docs/tract_data_prep.R")
}

ggsave(
  filename = "./figures/tract_total_pop.png",
  plot = qplot(
    tct$pop_diff, 
    xlim = c(-300, 300),
    main = "Difference Total Population: All US Tracts",
    xlab = ""))

ggsave(
  filename = "./figures/tract_white_pop.png",
  plot = qplot(
    tct$white_diff, 
    xlim = c(-300, 300),
    main = "Difference White Population: All US Tracts",
    xlab = ""))
  
ggsave(
  filename = "./figures/tract_black_pop.png",
  plot = qplot(
    tct$black_diff, 
    xlim = c(-300, 300),
    main = "Difference Black Population: All US Tracts",
    xlab = ""))
  
ggsave(
  filename = "./figures/tract_hisp_pop.png",
  plot = qplot(
    tct$hisp_diff, 
    xlim = c(-300, 300), 
    main = "Difference Hispanic Population: All US Tracts",
    xlab = ""))

ggsave(
  filename = "./figures/tract_other_pop.png",
  plot = qplot(
    tct$other_diff, 
    xlim = c(-300, 300),
    main = "Difference Other Race Population: All US Tracts",
    xlab = "")
    )

ggsave(
  filename = "./figures/tract total pop dp_sf ratio.png",
  plot = qplot(
    tct$dp_totpop / tct$sf_totpop,
    xlim = c(.25, 1.75),
    main = "Ratio of Decennial Total Pop to DP Total Pop\nAll US Tracts",
    xlab = ""
  )
)

ggsave(
  filename = "./figures/tract white pop dp_sf ratio.png",
  plot = qplot(
    tct$dp_white / tct$sf_white,
    xlim = c(.25, 1.75),
    main = "Ratio of Decennial White Pop to DP White Pop\nAll US Tracts",
    xlab = ""
  )
)

ggsave(
  filename = "./figures/tract black pop dp_sf ratio.png",
  plot = qplot(
    tct$dp_black / tct$sf_black,
    xlim = c(.25, 1.75),
    main = "Ratio of Original Black Pop to DP Black Pop\nAll US Tracts",
    xlab = ""
  )
)

ggsave(
  filename = "./figures/tract hisp pop dp_sf ratio.png",
  plot = qplot(
    tct$dp_hisp / tct$sf_hisp,
    xlim = c(.25, 1.75),
    main = "Ratio of Original Hispanic Pop to DP Hispanic Pop\nAll US Tracts",
    xlab = ""
  )
)

ggsave(
  filename = "./figures/tract other pop dp_sf ratio.png",
  plot = qplot(
    tct$dp_other / tct$sf_other,
    xlim = c(.25, 1.75),
    main = "Ratio of Original to DP Other Race Pop\nAll US Tracts",
    xlab = ""
  )
)

