

cities <- c(
  "Antioch", 
  "Brentwood",  "Orinda",  
  "Clayton" 
)
df <- data.frame(city = cities)
df$community <- NA
df$joined_mce <- NA
df$co2_reduced <- 0
df$participation_rate <- as.character(0)
df$deep_green_rate <- as.character(0)
df$join_deep_green <- NA

ccc_mce_df_score <- readRDS(file = "./04_Outputs/rds/ccc_mce_df.rds")%>% 
  bind_rows(df) %>% 
  mutate(points_for_muni = case_when(!is.na(join_deep_green) ~ as.numeric("25"),
                                     TRUE ~ as.numeric("0")),
         being_apart_of_mce = case_when(!is.na(joined_mce) ~ as.numeric("50"),
                                        TRUE ~ as.numeric("0")),
         participation_rate = as.numeric(str_remove_all(participation_rate, "\\s|%")),
         participation_score = participation_rate/100 * 25,
         mce_score = points_for_muni + being_apart_of_mce + participation_score)

saveRDS(ccc_mce_df_score, file = "./04_Outputs/rds/026_ccc_mce_df_score.rds")







saveRDS(marin_mce_df, file = "./04_Outputs/rds/marin_mce_df.rds")
saveRDS( napa_mce_df, file = "./04_Outputs/rds/napa_mce_df.rds")
saveRDS( solano_mce_df, file = "./04_Outputs/rds/solano_mce_df.rds")
saveRDS( full_mce, file = "./04_Outputs/rds/full_mce.rds")