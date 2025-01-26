
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Tiktok scraping

**Needed to run:**

There are two working functions to scrape TikTok.

- get_tt_user.R
- get_tt_posts.R

#### Get TikTok User

This function returns the account data for a specific user. Provide the
function with a username/handle, and it will pull the data.

``` r
get_tt_user("addisonre") |> data.frame()
#>          name    handle                    signature verified
#> 1 Addison Rae addisonre The world is my oyster 🧜🏼‍♀️     TRUE
#>                                biolink region followers following    hearts
#> 1 https://addisonrae.lnk.to/Aquamarine     US  88600000        22 926500000
#>   videos diggs friends date_pulled
#> 1    320     0      10  2025-01-26
```

#### Get TikTok Posts

Given a url, the function returns relevant performance data for the
post.

``` r
url <- "https://www.tiktok.com/@bmw/video/7462756650202483990?lang=en"
get_tt_posts(url) |> 
  data.frame()
#>                    id
#> 1 7462756650202483990
#>                                                       post_text
#> 1 You have made it to your destination 📍 #winter #BMWlove #fyp
#>          created_time duration           author_id author_uniqueID
#> 1 2025-01-22 07:07:20       14 6811960716250203142             bmw
#>   author_nickname
#> 1             bmw
#>                                                         author_signature
#> 1 Just here to bring you some JOY. \nWelcome to the official BMW TikTok.
#>   author_verified like_count share_count comment_count play_count collect_count
#> 1            TRUE       4989         105         10300     249300           373
#>                                       diversification_labels
#> 1 Cars, Trucks & Motorcycles, Auto & Vehicle, Auto & Vehicle
#>                                                                                                                                                  suggested_words
#> 1 BMW, bmw car, bmw videos, bmw tiktok video, BMW M5 E60, bmw supercar, luxury car brand bmw, bmw goes over a hill video, BMW Electric Car, BMW Motorcycle Edits
#>                  hashtags at_mentions
#> 1 #winter, #BMWlove, #fyp
```

With multiple urls, just use `purrr::map_dfr()` to return data for each
video.

#### Not working

The `get_tt_comments()` function is broken…
