# read, clean, and filter urls from link gopher
filter_links <- function(file_loc, handle = NULL, hashtag = NULL) {
  handle <- stringr::str_remove_all(handle, "@") # remove at handle if attached
  hashtag <- stringr::str_remove_all(hashtag, "#") # remove at handle if attached
  
  if (str_detect(file_loc, ".csv")) {
    tmp <- read_csv(file_loc) |>  
      filter(str_detect(links, pattern = regex("@[^/]+/video"))) |> 
      pull()
  } else {
    tmp <- readxl::read_excel(file_loc) |> 
      filter(str_detect(links, pattern = regex("@[^/]+/video")))  |> 
      pull()
  }
  
  # reverse order of urls
  tmp <- rev(tmp)
}
