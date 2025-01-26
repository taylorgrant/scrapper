tiktok_scrape <- function(link){
  pacman::p_load(tidyverse, janitor, here, glue, reticulate)
  reticulate::source_python(here::here('tiktok','py_functions', 'tiktok_info.py'))
  
    # protect the function
    try_tiktok_info <- possibly(tiktok_info, otherwise = NA)
    
    # map across all links
    tmpout <- link |> 
      map(try_tiktok_info)
  
  # remove any NA, put into tibble, and clean
  tmpout <- tmpout[!is.na(tmpout)] |>
    reduce(rbind) |>
    mutate(timestamp = lubridate::as_datetime(as.numeric(timestamp, tz = "America/Los_Angeles")),
           hashtags = str_extract_all(post_text, "#\\S+"),
           at_mentions = str_extract_all(post_text, "@\\S+"))
}

