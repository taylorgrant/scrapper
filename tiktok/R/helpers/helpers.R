# read, clean, and filter urls from link gopher
lg_clean <- function(file_loc, handle) {
  handle <- stringr::str_remove_all(handle, "@") # remove at handle if attached
  tmp <- read_csv(file_loc) |>  
    filter(str_detect(links, glue::glue("tiktok.com/@{handle}/video"))) |> 
    pull()
  # reverse order of urls
  tmp <- rev(tmp)
}