# to get data out of the returned lists # 
youtube_extract <- function(datalist) {
  # get summary data about the video (like count no longer included in data)
  summary <- purrr::map_dfr(datalist, 
                            magrittr::extract, 
                            c("uploader", "upload_date", "title", "description", "categories",
                              "duration_string", "view_count", "like_count", "comment_count", "original_url")) |> 
    dplyr::rename(duration = duration_string) |> 
    dplyr::mutate(upload_date = lubridate::ymd(upload_date))
  # get the comments
  x <- purrr::map(datalist, "comments")
  # drop empty lists (no comments)
  x <- Filter(length, x)
  
  comments <- NULL
  for (i in 1:length(x)) {
    print(i)
    tmp <- x[[i]] %>% 
      data.table::rbindlist(fill = TRUE) |> 
      dplyr::as_tibble() |> 
      dplyr::mutate(timestamp = lubridate::as_datetime(as.numeric(timestamp, tz = "America/Los_Angeles"))) |>
      dplyr::select(c(text, timestamp, like_count, author)) |> 
      dplyr::mutate(video = summary$title[i],
                    timestamp = as.Date(timestamp)) |> 
      dplyr::rename(date = timestamp)
    comments <- rbind(comments, tmp)
    tmp <- NULL
  }
  out <- list(summary = summary, comments = comments)
}
