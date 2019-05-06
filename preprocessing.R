rm(list=ls())

# Load data ----
advanced_all_nba <- read.csv("advancedallnba.csv", stringsAsFactors = F)
advanced_all_star <- read.csv("advancedallstars.csv", stringsAsFactors = F)
per36_all_nba <- read.csv("per36allnba.csv", stringsAsFactors = F)
per36_all_star <-  read.csv("per36allstars.csv", stringsAsFactors = F)
per100_all_nba <- read.csv("per100allnba.csv", stringsAsFactors = F)
per100_all_star <-  read.csv("per100allstars.csv", stringsAsFactors = F)
team_data <- read.csv("teamdata.csv", stringsAsFactors = F)

# Clean individual sets ----
# We only need Season/Tm to join and W.L. is the only actual data we want
team_data_small <- subset(team_data, select = c("Season", "Tm", "W.L."))

# Add all star/all nba value ----
advanced_all_nba$allnba <- rep(1, nrow(advanced_all_nba))
per36_all_nba$allnba <- rep(1, nrow(per36_all_nba))
per100_all_nba$allnba <- rep(1, nrow(per100_all_nba))
advanced_all_star$allstar <- rep(1, nrow(advanced_all_star))
per36_all_star$allstar <- rep(1, nrow(per36_all_star))
per100_all_star$allstar <- rep(1, nrow(per100_all_star))

# Join data sets ----
# testing seems to indicate that per_100 stats get better results
# probably due to how the pace of nba has changed over time
# however it seems like per 100 stats aren't available at all times (may have to wait
# until a certain part of the season)
per_100 <- TRUE
if (per_100) {
  all_nba <- merge(advanced_all_nba, per100_all_nba)
  all_star <- merge(advanced_all_star, per100_all_star)
} else {
  all_nba <- merge(advanced_all_nba, per36_all_nba)
  all_star <- merge(advanced_all_star, per36_all_star)
}

all <- merge(all_nba, all_star, all = T)
all <- merge(all, team_data_small, all.x = T)

# Snubs Section ----
# in case you want to manually add data from any all star snubs on the year you are trying
# to predict, save them in a file called snubs.csv with the same format as the all dataframe
snubs <- TRUE
if (snubs) {
  snubs <- read.csv("snubs.csv")
  all <- rbind(all, snubs) 
}

# Fill missing values for allnba/allstar ----
all[is.na(all[,"allnba"]), "allnba"] <- 0
all[is.na(all[,"allstar"]), "allstar"] <- 0

# Output final data set ----
write.csv(all, "finalData.csv")
