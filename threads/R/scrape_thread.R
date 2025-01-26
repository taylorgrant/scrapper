scrape_thread <- purrr::possibly(function(url) {
  source_python("~/R/scrapper/threads/python/scrape_thread.py")
  
  tmp <- scrape_thread(url)
  
  # thread data 
  thread_data <- tibble(
    username = tmp$thread$username,
    user_id = tmp$thread$user_id,
    date = as.POSIXct(tmp$thread$published_on, origin = "1970-01-01", tz = "PST8PDT"),
    text = tmp$thread$text,
    replies = tmp$thread$reply_count,
    likes = tmp$thread$likes,
    url = tmp$thread$url
  )
  
  replies_data <- map_df(tmp$replies, ~{
    tibble(
      text = .x$text,
      published_on = as.POSIXct(.x$published_on, origin = "1970-01-01", tz = "PST8PDT"),
      username = .x$username,
      like_count = .x$like_count,
      url = .x$url
    )
  })
  
  list(thread_data = thread_data, replies_data = replies_data)
}, otherwise = NULL)


# Example Use
# urls <- c("https://www.threads.net/@natgeo/post/DFSt1c2soIH",
#           "https://www.threads.net/@natgeo/post/DFPwfxNt-Fv")

# Apply safe_scrape_thread to the list of URLs
# results <- map(urls, scrape_thread)

# Filter out failed results
# results <- compact(results)

# Combine the results
# all_threads <- map_df(results, ~.x$thread_data)
# all_replies <- map_df(results, ~.x$replies_data)
