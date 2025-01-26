scrape_profile <- function(url){
  source_python("~/R/scrapper/threads/python/scrape_profile.py")
  source_python("~/R/scrapper/threads/python/scrape_thread.py")
  
  tmp <- scrape_profile(url)
  
  profile_data <- tibble(
    full_name = tmp$user$full_name,
    username = tmp$user$username,
    bio = tmp$user$bio,
    bio_link = tmp$user$bio_links,
    followers = tmp$user$followers
  )
  
  recent_threads <- map_df(tmp$threads, ~{
    tibble(
      text = .x$text,
      published_on = as.POSIXct(.x$published_on, origin = "1970-01-01", tz = "PST8PDT"),
      username = .x$username,
      like_count = .x$like_count,
      url = .x$url
    )
  })
  
    list(profile_data = profile_data, 
         recent_threads = recent_threads)
}

