ig_scrape_user <- function(username) {
  pacman::p_load(httr)
  INSTAGRAM_APP_ID <- "936619743392459" # this is the public app id for instagram.com
  url <- paste0("https://i.instagram.com/api/v1/users/web_profile_info/?username=", username)
  response <- GET(
    url = url,
    add_headers(`x-ig-app-id` = INSTAGRAM_APP_ID)
  )
  data <- content(response, "text")
  # parse_user(data)
}
