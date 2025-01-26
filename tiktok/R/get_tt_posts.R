#' Get TikTok Post Data and Stats
#'
#' @param link URL to TikTok video
#'
#' @return Dataframe with data about the video, author, and stats
#' @export
#'
#' @examples
get_tt_posts <- purrr:::possibly(function(link){
  # setting headers
  headers = c(
    `Accept` = '*/*',
    `Accept-Language` = 'en-US,en;q=0.9',
    `Connection` = 'keep-alive',
    `Content-type` = 'application/x-www-form-urlencoded',
    `DNT` = '1',
    `Referer` = "https://www.google.com/",
    `Sec-Fetch-Dest` = 'empty',
    `Sec-Fetch-Mode` = 'cors',
    `Sec-Fetch-Site` = 'same-origin',
    `User-Agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
    `cache-control` = 'no-cache',
    `pragma` = 'no-cache',
    `sec-ch-ua` = '"Chromium";v="116", "Not)A;Brand";v="24", "Google Chrome";v="116"',
    `sec-ch-ua-mobile` = '?0',
    `sec-ch-ua-platform` = '"macOS"'
  )
  
  # GET request
  res <- httr::GET(link, httr::add_headers(.headers = headers))
  if (res$status_code != 200) {
    stop(paste("Error: Received status code", res$status_code))
  }
  # content and pull script
  tmpout <- httr::content(res) |>
    rvest::html_elements("script#__UNIVERSAL_DATA_FOR_REHYDRATION__") |>
    rvest::html_text() |>
    jsonlite::fromJSON()
  
  out <- tmpout$`__DEFAULT_SCOPE__`$`webapp.video-detail`$itemInfo$itemStruct
  # build out a table of user data
  tibble::tibble(id = out$id, 
                 post_text = out$desc,
                 created_time = out$createTime,
                 duration = out$video$duration,
                 author_id = out$author$id,
                 author_uniqueID = out$author$uniqueId,
                 author_nickname = out$author$nickname,
                 author_signature = out$author$signature,
                 author_verified = out$author$verified,
                 like_count = out$stats$diggCount,
                 share_count = out$stats$shareCount,
                 comment_count = out$stats$commentCount,
                 play_count = out$stats$playCount,
                 collect_count = out$stats$collectCount,
                 diversification_labels = paste(out$diversificationLabels, collapse = ", "),
                 suggested_words = paste(out$suggestedWords, collapse = ", ")) |>  
    dplyr::mutate(hashtags = stringr::str_extract_all(post_text, "#\\S+"),
                  at_mentions = stringr::str_extract_all(post_text, "@\\S+"),
                  created_time = lubridate::as_datetime(as.integer(created_time), tz = "America/Los_Angeles"))
}, otherwise = NA) 

# use
# url <- "https://www.tiktok.com/@bmw/video/7449427546816400662?lang=en"
# dat <- get_tt_posts(url)




