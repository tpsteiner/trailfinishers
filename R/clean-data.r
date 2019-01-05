library(tidyverse)


content_table <- readRDS("data/content_table.Rds")

dirty17 <- filter(content_table, year == "2017")
dirty16 <- filter(content_table, year == "2016")
dirty_other <- filter(content_table, year < "2016" & year > "1979")

# head(dirty17, 2)
# head(dirty16, 2)
# head(dirty_other, 2)

clean17 <- dirty17 %>%
  separate(entry, c("realname_trailname", "location"), ";") %>%
  separate(location, c("state", "country", "direction"), ",", fill = "left") %>%
  separate(realname_trailname, c("real_name", "trail_name"), "'") %>%
  separate(real_name, c("last_name", "first_name"), ", ")

clean16 <- dirty16 %>%
  separate(entry, c("realname_trailname", "location"), ";") %>%
  separate(location, c("state", "country", "direction"), ", ", fill = "left") %>%
  separate(realname_trailname, c("real_name", "trail_name"), "'") %>%
  separate(real_name, c("last_name", "first_name"), ", ")

clean16$country <- ifelse(str_trim(clean16$state) %in% c(state.abb, "DC"), "USA", clean16$state)
clean16$state   <- ifelse(str_trim(clean16$state) %in% c(state.abb, "DC"), clean16$state, NA)

clean_other <- dirty_other %>%
  separate(entry, c("realname_trailname", "location", "direction_date"), "; ") %>%
  separate(direction_date, c("direction", "finish_date"), " ") %>%
  separate(realname_trailname, c("real_name", "trail_name"), "'") %>%
  separate(real_name, c("last_name", "first_name"), ", ") %>%
  separate(location, c("city", "state"), ", ")

clean_other$country <- ifelse(str_trim(clean_other$state) %in% c(state.abb, "DC"), "USA", clean_other$state)
clean_other$state   <- ifelse(str_trim(clean_other$state) %in% c(state.abb, "DC"), clean_other$state, NA)

hiker_data <- bind_rows(clean17, clean16, clean_other) %>% map_df(str_trim)  # Remove whitespace

hiker_data <- filter(hiker_data, direction %in% c("NOBO", "Section", "SOBO", "Flip"))

saveRDS(hiker_data, "data/hiker_data.Rds")
