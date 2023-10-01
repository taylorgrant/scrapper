yt_clean <- function(file_loc) {
  tmp <- read_csv(file_loc) |> 
    filter(str_detect(links, "^https://www.youtube.com/watch?")) |> 
    distinct(links) |> 
    pull()
}