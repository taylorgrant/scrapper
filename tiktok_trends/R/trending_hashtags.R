# Tiktok Hashtag Data Pull # 
tt_hashtag_data <- function(hashtag) {
  
  pacman::p_load(tidyverse, here, glue, janitor, httr, rvest)
  
  get_data <- function(hashtag) {
    url <- glue::glue("https://ads.tiktok.com/business/creativecenter/hashtag/{hashtag}/pc/en?rid=r349r7pp61&period=1095&countryCode=US")
    page <- session(url)
    out <- page |> 
      html_elements("script#__NEXT_DATA__") |> 
      html_text() |> 
      jsonlite::fromJSON()
    
    dat <- out$props$pageProps$data
    trend <- dat$trend |> 
      mutate(time = lubridate::as_datetime(time))
    post_count_last_3yrs <- dat$publishCnt
    total_post_count <- dat$publishCntAll
    video_views_last_3yrs <- dat$videoViews
    total_video_views <- dat$videoViewsAll
    audience_ages <- dat$audienceAges |> 
      mutate(ageLevel = case_when(ageLevel == 3 ~ "18-24",
                                  ageLevel == 4 ~ "25-34",
                                  ageLevel == 5 ~ "35+"),
             ageLevel = factor(ageLevel, levels = c("18-24", "25-34", "35+")),
             score = score/100)
    audience_interests <- tibble(interest = dat$audienceInterests$interestInfo$value,
                                 score = dat$audienceInterests$score)
    audience_country <- tibble(interest = dat$audienceCountries$countryInfo$value,
                               score = dat$audienceCountries$score)
    related_hashtags <- dat$relatedHashtags$hashtagName
    
    list(trend = trend, post_count_last_3yrs = post_count_last_3yrs, total_post_count = total_post_count,
         video_views_last_3yrs = video_views_last_3yrs, total_video_views = total_video_views,
         audience_ages = audience_ages, audience_interests = audience_interests, 
         audience_country = audience_country, related_hashtags = related_hashtags)
  }
  
  data <- get_data(hashtag)

  get_trend <-  function(hashtag) {
    url <- glue::glue("https://ads.tiktok.com/business/creativecenter/hashtag/{hashtag}/pc/en?rid=r349r7pp61&period=1095&countryCode=US")
    page <- session(url)
    out <- page |> 
      html_elements("script#__NEXT_DATA__") |> 
      html_text() |> 
      jsonlite::fromJSON()
    dat <- out$props$pageProps$data
    trend <- dat$trend |> 
      mutate(time = lubridate::as_datetime(time))
  }
  related_trends <- data$related_hashtags |> 
    map(get_trend) |> 
    set_names(nm = data$related_hashtags) %>% 
    data.table::rbindlist(. , idcol = 'hashtag')
  
  data <- c(data, list(related_trends = related_trends))
 
}

out <- tt_hashtag_data('hellokitty')




