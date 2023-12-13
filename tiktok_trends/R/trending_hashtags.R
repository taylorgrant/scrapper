# Tiktok Hashtag Data Pull # 
trending_hashtags <- function(hashtag, range) {
  
  pacman::p_load(tidyverse, here, glue, janitor, httr, rvest)
  
  get_data <- function(hashtag) {
    url <- glue::glue("https://ads.tiktok.com/business/creativecenter/hashtag/{hashtag}/pc/en?rid=r349r7pp61&period={range}&countryCode=US")
    page <- session(url)
    out <- page |> 
      html_elements("script#__NEXT_DATA__") |> 
      html_text() |> 
      jsonlite::fromJSON()
    
    dat <- out$props$pageProps$data
    trend <- dat$trend |> 
      mutate(time = lubridate::as_datetime(time),
             time = as.Date(time),
             value = value*100)
    post_count <- dat$publishCnt
    total_post_count <- dat$publishCntAll
    video_views <- dat$videoViews
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
    
    list(trend = trend, post_count = post_count, total_post_count = total_post_count,
         video_views = video_views, total_video_views = total_video_views,
         audience_ages = audience_ages, audience_interests = audience_interests, 
         audience_country = audience_country, related_hashtags = related_hashtags)
  }
  
  data <- get_data(hashtag)
  
  get_trend <-  possibly(function(hashtag, range) {
    
    url <- glue::glue("https://ads.tiktok.com/business/creativecenter/hashtag/{hashtag}/pc/en?rid=r349r7pp61&period={range}&countryCode=US")
    page <- session(url)
    out <- page |> 
      html_elements("script#__NEXT_DATA__") |> 
      html_text() |> 
      jsonlite::fromJSON()
    dat <- out$props$pageProps$data
    trend <- dat$trend |> 
      mutate(time = lubridate::as_datetime(time),
             time = as.Date(time),
             value = value*100)
    
    stats <- tibble(post_count = dat$publishCnt,
                    total_post_count = dat$publishCntAll,
                    video_views = dat$videoViews,
                    total_video_views = dat$videoViewsAll)
    list(trend = trend, stats = stats)
  }, otherwise = NA)
  
  related <- crossing(hashtag = data$related_hashtags, range)
  related_data <- map2(related$hashtag, related$range, get_trend) |> 
    set_names(nm = data$related_hashtags)
  
  # drop NA if necessary
  related_data <- related_data[!is.na(related_data)]
  
  related_trends <- related_data |> map("trend") %>% 
    data.table::rbindlist(. , idcol = 'hashtag')
  
  related_stats <- related_data |> map("stats") %>%   
    data.table::rbindlist(. , idcol = 'hashtag')
  
  hash1 <- tibble(hashtag = hashtag, 
                  post_count = data$post_count,
                  total_post_count = data$total_post_count,
                  video_views = data$video_views,
                  total_video_views = data$total_video_views)
  related_stats <- rbind(hash1, related_stats) |> 
    mutate(hashtag = paste0("#", hashtag))
  
  data <- c(data, list(related_trends = related_trends, related_stats = related_stats))
  
}

