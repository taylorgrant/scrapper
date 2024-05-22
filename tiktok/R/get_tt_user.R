#' Scrape TikTok User Details
#'
#' @param handle TikTok handle of user to get details for
#'
#' @return Dataframe with user data and the date all details were pulled
#' @export
#'
#' @examples
get_tt_user <- function(handle) {
  pacman::p_load(tidyverse)
  handle <- sub("^@", "", handle) # drop @ if it's there
  link <- glue::glue("https://www.tiktok.com/@{handle}?lang=en")

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

  tmpout <- httr::content(res) |>
    rvest::html_elements("script#__UNIVERSAL_DATA_FOR_REHYDRATION__") |>
    rvest::html_text() |>
    jsonlite::fromJSON()

  out <- tmpout$`__DEFAULT_SCOPE__`$`webapp.user-detail`$userInfo

  # build out a table of user data
  tibble::tibble(name = out$user$nickname,
         handle = out$user$uniqueId,
         signature = out$user$signature,
         verified = out$user$verified,
         biolink = out$user$bioLink$link,
         region = out$user$region,
         followers = out$stats$followerCount,
         following = out$stats$followingCount,
         hearts = out$stats$heartCount,
         videos = out$stats$videoCount,
         diggs = out$stats$diggCount,
         friends = out$stats$friendCount,
         date_pulled = Sys.Date())
}

# adre <- get_tt_user("addisonre")









