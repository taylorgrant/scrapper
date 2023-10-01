# reading heap data from json and export to xlsx # 

tiktok_clean <- function(file) {
  pacman::p_load(tidyverse, janitor, here, glue)
  dat <- jsonlite::fromJSON(file) |> 
    mutate(post_url = glue::glue("https://www.tiktok.com/@{nickname}/video/{id}?lang=en")) |> 
    mutate(hashtags = str_extract_all(desc, "#\\S+")) |> 
    filter(!is.na(nickname))
  nickname <- unique(dat$nickname)
  # put into tidy format (piecemeal for now)
  author_stats <- dat$authorStats |> 
    select(author_diggCount = diggCount, author_followerCount = followerCount, 
           author_followingCount = followingCount, author_heartCount = heartCount)
  post_stats <- dat$stats |> 
    select(post_collectCount = collectCount, post_commentCount = commentCount, 
           post_diggCount = diggCount, post_playCount = playCount, 
           post_shareCount = shareCount)
  video_data <- dat$video |> 
    select(definition, duration, videoQuality)
  volume_data <- dat$video$volumeInfo |> 
    select(loudness = Loudness, peak = Peak)
  music_data <- dat$music |> 
    select(music_album = album, music_authorName = authorName, 
           music_title = title, original, playUrl) |> 
    mutate(playUrl = ifelse(original == TRUE, NA, playUrl)) 
  
  
  # put together
  p1 <- dat |> select(nickname) |> 
    cbind(author_stats)
  
  p2 <- dat |> select(createTime, post_url, playlistId, desc, hashtags, 
                      duetEnabled, stitchEnabled, stickersOnItem) |> 
    cbind(post_stats, video_data, volume_data, music_data)
  
  tmp <- cbind(p1, p2) |> 
    filter(!is.na(nickname)) |> 
    mutate(createTime = lubridate::as_datetime(as.numeric(createTime, tz = "America/Los_Angeles⁠"))) |> 
    arrange(desc(createTime)) |> 
    distinct(post_url, .keep_all = TRUE)
  
  openxlsx::write.xlsx(tmp, glue::glue("~/Desktop/{nickname}_tiktok.xlsx"), overwrite = TRUE)
}

# to run the function (assume heap download is on the desktop)
# tiktok_clean("~/Desktop/tiktok_bmwusa.json")


