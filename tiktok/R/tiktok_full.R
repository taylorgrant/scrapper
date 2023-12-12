## Functions to scrape TikTok ## 

tiktok_full <- function(handle = NULL, hashtag = NULL) {
  pacman::p_load(tidyverse, janitor, here, glue)
  source(here("tiktok", "R", "filter_links.R"))
  source(here("tiktok", "R", "tiktok_scrape.R"))
  
  data_path <- here('tiktok','tiktok_data', "links")
  if (is.null(handle)) {
    filename <- dir(data_path, pattern = hashtag)
    loc <- file.path(data_path, filename)
    urls <- filter_links(loc, hashtag)
  } else {
    filename <- dir(data_path, pattern = handle)
    loc <- file.path(data_path, filename)
    urls <- filter_links(loc, handle)
  }
  
  #-- scrap tiktok urls
  out <- tiktok_scrape(urls)
  
  out <- out |> 
    distinct(id, .keep_all = TRUE) |> 
    arrange(desc(timestamp))
  
  # save files
  if (is.null(handle)) {
    saveRDS(out, here('tiktok', 'tiktok_data', "processed", glue::glue('hashtag_{hashtag}-{Sys.Date()}.rds')))
    openxlsx::write.xlsx(out, here('tiktok', 'tiktok_data', "processed", glue::glue('hashtag_{hashtag}-{Sys.Date()}.xlsx')))
  } else {
    saveRDS(out, here('tiktok', 'tiktok_data', "processed", glue::glue('{handle}-{Sys.Date()}.rds')))
    openxlsx::write.xlsx(out, here('tiktok', 'tiktok_data', "processed", glue::glue('{handle}-{Sys.Date()}.xlsx')))
  }
  
}

# example 
tiktok_full(hashtag = "bmw")





