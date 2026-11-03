library(dplyr)
library(tidyr)
library(ggplot2)
library(ggrepel)

league_data <- read.csv("data/premier_league_season_2026-2027_stats.csv")

league_data <- league_data %>% filter(status == "FT")

league_data <- league_data %>%
  mutate(npxgot_over_npxg = xgot_non_penalty / xg_non_penalty) %>%
  mutate(npxgot_minus_npxg = xgot_non_penalty - xg_non_penalty)

club_results <- league_data %>% group_by(team) %>%
  summarize(
    total_npXG = sum(xg_non_penalty),
    avg_npxG = mean(xg_non_penalty),
    avg_npxGOT = mean(xgot_non_penalty),
    total_npxGOT_to_npXG_ratio = sum(xgot_non_penalty) / sum(xg_non_penalty),
    total_npxGOT_npXG_diff = sum(npxgot_minus_npxg),
    matches = n()
  )

sum(club_results[["total_npxGOT_npXG_diff"]])

write.csv(club_results, "pl_xgot_table.csv")
ggplot(club_results, aes(x = avg_npxG, y = avg_npxGOT, label=team)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", colour = "grey60") +
  geom_point() +
  geom_text_repel(size = 3, max.overlaps = Inf) +
  expand_limits(x = 0.5, y = 0.5) +
  coord_equal()
ggplot(club_results, aes(x = avg_npxG, y = total_npxGOT_to_npXG_ratio, label=team)) +
  geom_hline(yintercept = 1, linetype = "dashed", colour = "grey60") +
  geom_point() +
  geom_text_repel(size = 3, max.overlaps = Inf)
ggplot(club_results, aes(x = avg_npxG, y = total_npxGOT_npXG_diff, label=team)) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
  geom_point() +
  geom_text_repel(size = 3, max.overlaps = Inf)
