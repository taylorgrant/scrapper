# YouTube metrics and comments # 

# 1. start with LinkGopher to extract all urls
# 2. add links to a csv with the column name "links"
# 3. save csv as "[handle_name]_yt_links.csv" in the "yt_link_data" folder
# 4. run this function 

youtube_full <- function(name) {
  # load packages
  pacman::p_load(tidyverse, janitor, here, glue)
  
  # load functions
  reticulate::source_python(here::here('youtube', 'py_functions', 'youtube_dl_info.py'))
  source(here('youtube','R', 'youtube_filter.R'))
  source(here('youtube','R', "youtube_extract.R"))
  
  loc <- here('youtube','youtube_data', "links", glue("{name}.csv"))
  urls <- youtube_filter(loc)
  
  # map over function and save to environment for safe processing
  tmpdata <- urls |>
    purrr::map(youtube_dl_info)
  
  # clean and add to reactive values
  out <- youtube_extract(tmpdata)
  
  outlist <- list(summary = out$summary, comments = out$comments)
  
  saveRDS(outlist, here("youtube", "youtube_data", "processed", glue::glue("{name}_{Sys.Date()}.rds")))
  openxlsx::write.xlsx(outlist, here("youtube","youtube_data", "processed", glue::glue("{name}_{Sys.Date()}.xlsx")))
}

# example: to run:
# youtube_full("frozendumplings")
