# Author: Jonathan Schroeder
library(ggplot2)
library(dplyr)

setwd("Y:/misc/census-das/dp2010")

decile <- read.csv("data/decile.csv")
names(decile)

decile$geolvl <- factor(decile$geolvl, 
                        levels=c("state", "county", "tract", "blk_grp", "county_sub", "place", "sldl", "sldu"))
levels(decile$geolvl) = c("States", "Counties", "Tracts", "Block Groups", "County Subs", "Places", "SLDLs", "SLDUs")
summary(decile$geolvl)

# Remove SLDL & SLDU
decile <- subset(decile, geolvl %in% levels(geolvl)[1:6])

decile$pct_gt5_totpop <- 100 * decile$n_gt5_totpop / decile$num_units_decile
decile$pct_gt10_totpop <- 100 * decile$n_gt10_totpop / decile$num_units_decile
decile$pct_gt10_hhblack <- 100 * decile$n_gt10_hhblack / decile$num_units_decile
decile$pct_gt10_age65plus <- 100 * decile$n_gt10_age65plus / decile$num_units_decile
decile$pct_gt10_hisp <- 100 * decile$n_gt10_hisp / decile$num_units_decile
decile$pct_gt10_hhsize1 <- 100 * decile$n_gt10_hhsize1 / decile$num_units_decile
decile$pct_gt25_totpop <- 100 * decile$n_gt25_totpop / decile$num_units_decile
decile$pct_gt25_hhblack <- 100 * decile$n_gt25_hhblack / decile$num_units_decile
decile$pct_gt25_age65plus <- 100 * decile$n_gt25_age65plus / decile$num_units_decile
decile$pct_gt25_hisp <- 100 * decile$n_gt25_hisp / decile$num_units_decile
decile$pct_gt25_hhsize1 <- 100 * decile$n_gt25_hhsize1 / decile$num_units_decile

summary(decile[,36:46])

# Plot only one geolvl
ggplot(subset(decile, geolvl=="Block Groups"), 
       aes(x=decile_sf, y=pct_gt10_totpop, label=round(mean_sf1_tot))) +
  geom_bar(stat="identity") +
  coord_flip() +
  geom_text(y=99, hjust=1) +
  scale_x_discrete(name="Decile", limits=1:10, expand=c(0.01,0.01)) +
  scale_y_continuous(name="Percent of discrepancies > 10%",
                     expand=c(0,0),
                     limits=c(0,100),
                     breaks=c(10,25,50,100),
                     minor_breaks=5)

# Plot all geolvls as facets
ggplot(decile, aes(x=decile_sf, y=pct_gt10_totpop, 
           label=format(signif(mean_sf1_tot, 2), big.mark=",", scientific=FALSE))) +
  geom_bar(stat="identity") +
#  theme_bw() +
  theme(panel.grid.major.y = element_blank()) +
  coord_flip() +
  geom_text(y=98, hjust=1, alpha=0.5) +
  scale_x_discrete(name="Population Decile", limits=1:10, expand=c(0.01,0.01)) +
  scale_y_continuous(name="Percent of Discrepancies > 10%",
                     expand=c(0,0),
                     limits=c(0,100),
                     breaks=c(10,25,50,75),
                     minor_breaks=NULL) +
  facet_grid(cols=vars(geolvl)) +
  ggtitle("2010 SF1 vs. Demo: Total Population")


# Function to plot all geolvls as facets
demo.comp.by.geog.dec <- function(barval, diffsize, statlabel, outstat=NULL){
  ggplot(decile, aes(x=decile_sf, y=barval, 
             label=format(signif(mean_sf1_tot, 2), big.mark=",", scientific=FALSE))) +
    geom_bar(stat="identity") +
    #  theme_bw() +
    theme(panel.grid.major.y = element_blank(),
          strip.text.x = element_text(size=12)) +
    coord_flip() +
    geom_text(y=98, hjust=1, alpha=0.5, size=3) +
    scale_x_discrete(name="Population Decile", limits=1:10, expand=c(0.01,0.01)) +
    scale_y_continuous(name=paste("Percent of Discrepancies > ", diffsize, "%", sep=""),
                       expand=c(0,0),
                       limits=c(0,100),
                       breaks=c(10,25,50,75),
                       minor_breaks=NULL) +
    facet_grid(cols=vars(geolvl)) +
    ggtitle(paste("2010 SF1 vs. Demo:", statlabel))
  
  if (!is.null(outstat)) {
    ggsave(paste("images/geogdeciles_", outstat, "_diffgt", diffsize, ".png", sep=""), width=10, height=5.625, dpi=150)
  }
}

demo.comp.by.geog.dec(decile$pct_gt5_totpop, 5, "Total Population", "totpop")
demo.comp.by.geog.dec(decile$pct_gt10_totpop, 10, "Total Population", "totpop")
demo.comp.by.geog.dec(decile$pct_gt25_totpop, 25, "Total Population", "totpop")
demo.comp.by.geog.dec(decile$pct_gt10_hhblack, 10, "Black Householders", "hhblack")
demo.comp.by.geog.dec(decile$pct_gt25_hhblack, 25, "Black Householders", "hhblack")
demo.comp.by.geog.dec(decile$pct_gt10_age65plus, 10, "Persons 65 Years and Over", "age65plus")
demo.comp.by.geog.dec(decile$pct_gt25_age65plus, 25, "Persons 65 Years and Over", "age65plus")
demo.comp.by.geog.dec(decile$pct_gt10_hisp, 10, "Hispanic/Latino Population", "hisp")
demo.comp.by.geog.dec(decile$pct_gt25_hisp, 25, "Hispanic/Latino Population", "hisp")
demo.comp.by.geog.dec(decile$pct_gt10_hhsize1, 10, "Single-Person Households", "hhsize1")
demo.comp.by.geog.dec(decile$pct_gt25_hhsize1, 25, "Single-Person Households", "hhsize1")
