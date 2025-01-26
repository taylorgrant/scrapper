#' Scrape Instagram Posts
#'
#' @param user_name The handle of the user to scrape
#' @param max_pages The number of pages to scrape. Each page has 12 posts
#'
#' @returns Dataframe with post level data
#' @export
#'
#' @examples
#' \dontrun{
#' bmw_ig <- scrape_instagram("bmw", max_pages = 8)
#' }
scrape_instagram <- function(user_name, max_pages) {
  
  pacman::p_load(tidyverse, janitor, here, glue, reticulate)
  
  if (max_pages > 10) {
    sleep_time <- 5L
  } else {
    sleep_time <- 2L
  }
  
  # LOAD FUNCTIONS ----------------------------------------------------------
  # R FUNCTIONS
  source("~/R/scrapper/instagram/R/ig_scrape_user.R") # scrapes the user
  source("~/R/scrapper/instagram/R/ig_parse_user.R") # parsed the user data into a list 
  source("~/R/scrapper/instagram/R/ig_clean_posts.R")
  # PYTHON FUNCTIONS
  source_python("~/R/scrapper/instagram/python/ig_parse_post.py")
  source_python("~/R/scrapper/instagram/python/ig_scrape_single_post.py")
  source_python("~/R/scrapper/instagram/python/ig_scrape_user_posts_detail.py")
  
  # 1. GET USER DATA --------------------------------------------------------
  # this is necessary to get the user ID 
  user <- ig_scrape_user(user_name)
  parsed_user <- ig_parse_user(user)
  
  # 2. GET POST DATA --------------------------------------------------------
  httpx <- import("httpx") # Create a Python session using httpx
  session <- httpx$Client(timeout = httpx$Timeout(20.0)) # Create an HTTPX session object in Python
  post_df <- ig_scrape_user_posts_detail(
    user_id = parsed_user$account_data$id,
    session = session,
    page_size = 12L,
    max_pages = max_pages,            # Optional: Limit the number of pages to scrape
    sleep_time = sleep_time
  )
  session$close()
  # 3. CLEAN THE DATA AND RETURN  -------------------------------------------
  clean_posts <- ig_clean_posts(post_df)
  return(clean_posts)
}

# TO USE # 
# test <- scrape_instagram("bmw", max_pages = 8)



