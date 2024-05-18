#' Parse TikTok comment data
#'
#' @param l List of data pulled from the TikTok comment API
#'
#' @return Dataframe of comment data, each comment is it's own row
#' @export
#'
#' @examples
parse_comments <- purrr::possibly(function(l){
  # putting comment data into a cleaned tibble
  tibble::tibble(
    text = l$comments$text,
    comment_language = l$comments$comment_language,
    digg_count = l$comments$digg_count,
    reply_comment_count = l$comments$reply_comment_total,
    author_pin = l$comments$author_pin,
    create_time = l$comments$create_time,
    cid = l$comments$cid,
    nickname = l$comments$user$nickname,
    unique_id = l$comments$user$unique_id,
    post_id = l$comments$aweme_id
  ) |> 
    dplyr::mutate(create_time = lubridate::as_datetime(create_time, tz = "America/Los_Angeles"))
}, otherwise = NA_character_)

#' Scrape TikTok comments
#'
#' This function hits the TikTok API and requests 50 comments. Cursor is the location of the comments, starting at 0 and increasing
#' @param post_id TikTok Post ID
#' @param cursor Location to start from in length of comments
#'
#' @return If cursor = 0, a list with data for first 50 comments and the total number of comments that will be pulled
#' @export
#'
#' @examples
scrape_comments <- function(post_id, cursor) {
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
  # build url and first pull 
  base_url <- "https://www.tiktok.com/api/comment/list/?"
  params <- list(
    aweme_id = post_id,
    count = 50,
    cursor = cursor
  )
  # GET request
  res <- httr::GET(base_url, query = params, httr::add_headers(.headers = headers))
  # parse data depending on cursor location
  if (cursor == 0) {
    tmp <- httr::content(res, "text") |> 
      jsonlite::fromJSON()
    
    out <- list(comment_data = parse_comments(tmp), total_comments = tmp$total)
  } else {
    tmp <- httr::content(res, "text") |> 
      jsonlite::fromJSON()
    
    out <- parse_comments(tmp)
  }
}

#' Fetch TikTok Comments
#' 
#' This is the convenience/wrapper function that pulls all comments
#'
#' @param post_id Post ID of the original TikTok post
#'
#' @return Dataframe of comment data
#' @export
#'
#' @examples
fetch_tt_comments <- function(post_id) {
  tmp <- scrape_comments(post_id, cursor = 0)
  # get cursor starting locations
  cursors <- (1:floor(tmp$total_comments/50)*50)+1
  # map across cursor starts
  out <- purrr::map2(post_id, cursors, scrape_comments)
  out <- out[!is.na(out)]
  out <- dplyr::bind_rows(out)
  # bind all pulls together
  rbind(tmp$comment_data, out)
}








