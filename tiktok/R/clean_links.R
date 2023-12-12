# read, clean, and filter urls from link gopher
clean_links <- function(file_loc, handle) {
  handle <- stringr::str_remove_all(handle, "@") # remove at handle if attached
  
  if (str_detect(file_loc, ".csv")) {
    tmp <- read_csv(file_loc) |>  
      filter(str_detect(links, glue::glue("tiktok.com/@{handle}/video"))) |> 
      pull()
  } else {
    tmp <- readxl::read_excel(file_loc) |> 
      filter(str_detect(links, glue::glue("tiktok.com/@{handle}/video"))) |> 
      pull()
  }
  
  # reverse order of urls
  tmp <- rev(tmp)
}
