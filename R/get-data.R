library(tidyverse)
library(rvest)
library(xml2)


url <- "http://appalachiantrail.org/home/community/2000-miler-listing"

year <- read_html(url) %>%
  html_nodes("a.accordion-section-title") %>%
  html_text()

content_html <- read_html(url) %>%
  html_nodes("div.accordion-section-content")

content_text <- content_html %>%
  map(html_text, trim = TRUE) %>%
  map(str_split, "\n") %>%
  map(unlist) %>%
  map(str_trim)

content_table <- tibble(entry = content_text, year) %>% unnest()
content_table$year <- str_trunc(content_table$year, 4, "right", ellipsis = "")

saveRDS(content_table, "data/content_table.Rds")
