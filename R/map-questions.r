library(tigris)
library(sf)
library(tidyverse)

hiker_data <- read_csv("data/hiker_data.csv")

state_count <- hiker_data %>%
  group_by(state) %>%
  count()

states_sp <- states(cb = TRUE)
states_sf = st_as_sf(states_sp)

hiker_states <- inner_join(states_sf, state_count, by = c("STUSPS" = "state")) %>%
  filter(NAME != "Alaska", NAME != "Hawaii")

ggplot(hiker_states) +
  geom_sf(aes(fill = n)) +
  coord_sf(datum = NA) +
  theme(panel.background = element_blank())
