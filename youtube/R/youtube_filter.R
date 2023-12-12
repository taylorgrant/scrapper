# filter out any non watch urls #
youtube_filter <- function(file_loc) {
  tmp <- read_csv(file_loc) |> 
    filter(str_detect(links, "^https://www.youtube.com/watch?")) |> 
    distinct(links) |> 
    pull()
}