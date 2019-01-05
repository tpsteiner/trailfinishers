library(tidyverse)
library(lubridate)


hiker_data <- read_csv("data/hiker_data.csv")

# Show the data
sample_n(hiker_data, 5)


# How do Finishers hike the AT?
hiker_data %>%
  count(direction) %>%
  arrange(desc(n)) %>%
  mutate(`proportion_of_hikers` = paste0(100*round(n/sum(.$n), 2),"%"))


# Which countries do most Finishers come from?
hiker_data %>%
  mutate(country = if_else(country == "USA", "USA", "Other")) %>%
  count(country) %>%
  arrange(desc(n)) %>%
  mutate(`% of hikers` = 100*round(n/sum(.$n), 2))


# What countries do international hikers come from?
hiker_data %>%
  filter(!(country %in% c("USA", "", NA))) %>%
  count(country) %>%
  arrange(desc(n)) %>%
  mutate(`% of international hikers` = 100*round(n/sum(.$n), 4)) %>%
  head(20)


# Most common trail names (full)
hiker_data %>%
  group_by(trail_name) %>%
  count() %>%
  arrange(desc(n))


# Most common trail names (first word)
hiker_data %>%
  mutate(trail_name = str_extract(trail_name, "\\S+")) %>%
  group_by(trail_name) %>%
  count() %>%
  arrange(desc(n))


# Most common real names (first name)
hiker_data %>%
  group_by(first_name) %>%
  count() %>%
  arrange(desc(n))


# Most common real names (last name)
hiker_data %>%
  group_by(last_name) %>%
  count() %>%
  arrange(desc(n))


# Most common date to finish (2015 and earlier)
hiker_data %>%
  mutate(month = month(mdy(finish_date), label = TRUE, abbr = FALSE)) %>%
  group_by(direction, month) %>%
  count() %>%
  group_by(direction) %>%
  mutate("% of direction total" = str_c(round(n/sum(n)*100), "%")) %>%
  top_n(3, n)

#TODO
# Number of finishers per year
hiker_data %>%
  group_by(year = as.numeric(year)) %>%
  count() #%>%
  #mutate(change = n/)


# Most commonly represented states each year
hiker_data %>%
  group_by(year, state) %>%
  count() %>%
  group_by(year) %>%
  top_n(3, n) %>%
  arrange(desc(year))

