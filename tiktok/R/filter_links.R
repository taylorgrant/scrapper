# read, clean, and filter urls from link gopher
filter_links <- function(file_loc, handle = NULL) {
  # hashtag <- stringr::str_remove_all(hashtag, "#") # remove at handle if attached
  
  if (stringr::str_detect(file_loc, ".csv")) {
    tmp <- readr::read_csv(file_loc)
  } else {
    tmp <- readxl::read_excel(file_loc)
  }
  
  if (is.null(handle)) {
    tmp <- tmp |> 
      dplyr::filter(stringr::str_detect(links, pattern = glue::glue("[a-z]/video"))) |> 
      dplyr::pull()
  } else {
    handle <- stringr::str_remove_all(handle, "@") # remove at handle if attached
    tmp <- tmp |> 
      dplyr::filter(stringr::str_detect(links, pattern = glue::glue("{handle}/video"))) |> 
      dplyr::pull()
  }
  
  # reverse order of urls
  tmp <- rev(tmp)
}
