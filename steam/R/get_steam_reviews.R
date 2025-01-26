#' Scrape user reviews from Steam
#'
#' Steam is kind enough to provide documentation for how to get reviews \href{https://partner.steamgames.com/doc/store/getreviews}{here}
#'  
#' @param appid The ID of the game - can be found in the url of the game's reviews
#' @param params Parameters for download - look to the url above for details. By default, it returns 20 reviews. 
#'
#' @return
#' @export
#'
#' @examples
get_reviews <- function(appid, params = list(json = 1)) {
  library(httr)
  
  headers = c(
    `sec-ch-ua` = '"Chromium";v="116", "Not)A;Brand";v="24", "Google Chrome";v="116"',
    `Referer` = "https://www.google.com/",
    `DNT` = "1",
    `Accept-Language` = "en",
    `sec-ch-ua-mobile` = "?0",
    `User-Agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
    `sec-ch-ua-platform` = '"macOS"'
  )
  
  url <- paste0('https://store.steampowered.com/appreviews/', appid)
  response <- GET(url, query = params, add_headers(.headers = headers))
  
  jsonlite::fromJSON(content(response, "text"))
}



#' Get a pre-specified number of reviews for a given game from Steam
#'
#' @param appid The ID of the game - can be found in the url of the game's reviews
#' @param n Number of reviews to gather from the Steam platform
#'
#' @return
#' @export
#'
#' @examples
get_n_reviews <- function(appid, n) {
  reviews <- NULL
  params <- list(
    json = 1,
    filter = 'recent',
    language = 'english',
    day_range = 9223372036854775807,
    review_type = 'all',
    purchase_type = 'all',
    num_per_page = 100
  )
  
  while (n > 0) {
    params$num_per_page <- min(100, n)
    n <- n - 100
    
    response <- get_reviews(appid, params)
    cursor <- response$cursor
    params$cursor <- cursor
    reviews <- dplyr::bind_rows(reviews, response$reviews)
    
    if (nrow(response$reviews) < 100) break
  }
  
  return(reviews)
}


# EXAMPLE -----------------------------------------------------------------
appid <- 1517290
# to find how many reviews are available, run this call
tmpout <- get_reviews(appid = appid, params = list(
  json = 1,
  filter = 'recent',
  language = 'english',
  day_range = 9223372036854775807,
  review_type = 'all',
  purchase_type = 'all',
  num_per_page = 20
))
n <- tmpout$query_summary$total_reviews

# to run the full thing
bf2142 <- get_n_reviews(appid = appid, n = 111270)

bf2142 <- bf2142 |> 
  dplyr::mutate(timestamp_created = lubridate::as_datetime(timestamp_created, tz = "America/Los_Angeles"),
                timestamp_updated = lubridate::as_datetime(timestamp_updated, tz = "America/Los_Angeles"))

saveRDS(bf2142, here::here("steam", "data", "battlefield2142_reviews.rds"))
