ig_clean_posts <- function(data) {
  data |> 
    dplyr::mutate(url = glue::glue("https://www.instagram.com/p/{shortcode}"),
                  media_link = ifelse(!is.na(video_url), video_url, src),
                  link_expiry = as.POSIXct(strtoi(urltools::param_get(media_link)$oe, base = 16), 
                                           origin = "1970-01-01", tz = "PST8PDT"),
                  post_type = ifelse(is_video == "TRUE", "Video", "Static"),
                  post_date = as.POSIXct(taken_at, origin = "1970-01-01", tz = "PST8PDT"),
                  hashtags = map_chr(caption, ~ paste(str_extract_all(.x, "#\\S+")[[1]], collapse = ", ")),
                  collaborators = map_chr(tagged_users, ~ paste(.x, collapse = ", "))) |> 
    select(post_date, url, caption, views, plays, likes, comments, video_duration, collaborators, hashtags,
           media_link, link_expiry)
}






