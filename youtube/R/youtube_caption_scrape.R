# this will scrape YouTube subtitles and all comments on a video
# data should be in a dataframe - link and title
# if don't want user comments, change to FALSE

# scraper uses yt-dlp (pip install yt-dlp); ffmpeg (brew install ffmpeg); and ripgrep (brew install ripgrep)
youtube_caption_scrape <- function(link, title, comments=TRUE) {
  if (comments == TRUE) {
    x <- glue::glue("yt-dlp --sub-lang en --skip-download --write-auto-sub --sub-format vtt --write-info-json --write-comments --output 'youtube/yt_caption_data/{title}' '{link}'")
  } else {
    x <- glue::glue("yt-dlp --sub-lang en --skip-download --write-auto-sub --sub-format vtt --write-info-json --output 'youtube/yt_caption_data/{title}' '{link}'")
  }
  system(x)
  y <- glue::glue("ffmpeg -i 'youtube/yt_caption_data/{title}.en.vtt' youtube/yt_caption_data/{title}.srt")
  system(y)
  # glue messes up this command for some reason; using paste instead #
  z <- paste0("rg -v '^[[:digit:]]+$|^[[:digit:]]{2}:|^$', youtube/yt_caption_data/",title, ".srt | tr -d '\r' | rg -N '\\S' | uniq > youtube/yt_caption_data/clean_",title, ".txt")
  system(z)
}


# TO USE: -----------------------------------------------------------------

# DATA STRUCTURE
# dat <- tibble(url = c("https://www.youtube.com/watch?v=Lz33OZf4Yx0", 
#                       "https://www.youtube.com/watch?v=-H5CCsOnjyc"),
#        title = c("dmb", "turturo"))

# map2(dat$url[1], dat$title[1], youtube_scrape)

# TO EXTRACT COMMENTS 
# out <- jsonlite::fromJSON(glue::glue("youtube/yt_caption_data/{title}.info.json"))
# comments <- out$comments |> 
#   mutate(text = str_replace_all(text, "\n", " "),
#          text = str_replace_all(text, "  ", " "),
#          timestamp = lubridate::as_datetime(as.numeric(timestamp, tz = "America/Los_Angeles")))

# PULL THE CHAPTERS 
# out$chapters

# PERFORMANCE METRICS
# out$comment_count
# out$like_count


