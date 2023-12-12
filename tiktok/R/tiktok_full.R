## Functions to scrape TikTok ## 

tiktok_full <- function(handle) {
  pacman::p_load(tidyverse, janitor, here, glue)
  source(here("tiktok", "R", "clean_links.R"))
  source(here("tiktok", "R", "tiktok_scrape.R"))
  
  data_path <- here('tiktok','tiktok_data', "links")
  filename <- dir(data_path, pattern = handle)
  loc <- file.path(data_path, filename)
  urls <- clean_links(loc, handle)
  
  #-- scrap tiktok urls
  out <- tiktok_scrape(urls)
  
  out <- out |> 
    distinct(id, .keep_all = TRUE) |> 
    arrange(desc(timestamp))
  
  # save files
  saveRDS(out, here('tiktok', 'tiktok_data', "processed", glue::glue('{handle}-{Sys.Date()}.rds')))
  openxlsx::write.xlsx(out, here('tiktok', 'tiktok_data', "processed", glue::glue('{handle}-{Sys.Date()}.xlsx')))
}

# example 
# tiktok_full("bmw")





