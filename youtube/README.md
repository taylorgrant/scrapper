
<!-- README.md is generated from README.Rmd. Please edit that file -->

# YouTube

<!-- badges: start -->
<!-- badges: end -->

#### What is this?

This is a program that scrapes YouTube for the metadata for a video
along with the comments left by users. It’s very helpful for NLP
analysis of what people are talking about - either for a brand’s videos,
or for a specific vertical.

**Needed to run:**

Most of this code is written in R, but it also uses some Python, and it
also requires [yt-dlp](https://github.com/yt-dlp/yt-dlp) to be
installed. Use the `reticulate` package to create a new conda
environment `conda_create('env-name')` and then install everything
within that environment using `conda_install()`. To ensure that the
proper conda environment is used, either set the .Renviron or use
`Sys.setenv(RETICULATE_PYTHON=dir/to/env)` at the top of the code.

**Folder structure**

``` r
├── R
│   ├── youtube_extract.R
│   ├── youtube_filter.R
│   └── youtube_full.R
│   └── youtube_scrape.R
├── py_functions
│   └── youtube_dl_info.py
└── youtube_data
    ├── links
    └── processed
└── yt_caption_data
```

The code structure is pretty simple. The R function `youtube_full.R`
will call all other functions necessary. That function will look for a
file in the `/youtube_data/links/` folder and it will look for a file
name of `{name}.csv`. The file should only include YouTube links and
have a column header named `links`.

#### To Run

Once the YouTube urls are saved in the `/youtube_data/links/` folder,
everything else runs through the `/R/youtube_full.R` file. It will
source the other functions, de-dupe the posts, and save two files - .rds
and .xlsx.

#### Output

As an example, we’ll grab two urls from GQ Iconic Songs interviews and
run them through the scraper. One url is for an interview with
[St.Vincent](https://www.youtube.com/watch?v=8Pip_puDIOA) the other is
with [Dave Matthews](https://www.youtube.com/watch?v=Lz33OZf4Yx0).

#### Run

``` r
youtube_full("gq_iconic_songs")
```

##### Summary Data

``` r
out <- readRDS(here::here('youtube', "youtube_data", "processed", "gq_iconic_songs_2023-12-11.rds"))
out$summary |> 
  data.frame()
#>   uploader upload_date                                                 title
#> 1       GQ  2019-01-22     St Vincent Breaks Down Her Most Iconic Songs | GQ
#> 2       GQ  2023-05-18 Dave Matthews Breaks Down His Most Iconic Tracks | GQ
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             description
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  Annie Clark, also know by her stage name, 'St Vincent' shares how she started making music and breaks down some of her most iconic tracks, including 'Surgeon,' 'Cruel,' 'New York,' 'Smoking Section,' 'Los Angeless,' 'Pills,' 'Hang On Me,' 'Happy Birthday, Johnny,' 'Savior' and 'Slow Disco,' \n\nStill haven’t subscribed to GQ on YouTube? ►► http://bit.ly/2iij5wt\r\nSubscribe to GQ magazine and get rare swag: https://bit.ly/2xNBH3i\r\n\r\nABOUT GQ\r\nFor more than 50 years, GQ has been the premier men’s magazine, providing definitive coverage of style, culture, politics and more. In that tradition, GQ’s video channel covers every part of a man’s life, from entertainment and sports to fashion and grooming advice. So join celebrities from 2 Chainz, Stephen Curry and Channing Tatum to Amy Schumer, Kendall Jenner and Kate Upton for a look at the best in pop culture. Welcome to the modern man’s guide to style advice, dating tips, celebrity videos, music, sports and more.\r\n\r\nhttps://www.youtube.com/user/GQVideos\n\nSt Vincent Breaks Down Her Most Iconic Songs | GQ
#> 2 Dave Matthews (Dave Matthews Band) breaks down his band's most iconic tracks including "Ants Marching," "Satellite," "Crash Into Me," "#41," "Don't Drink the Water," "The Space Between," "Everyday," "Grey Street," "Madman's Eyes" and "Something to Tell My Baby."\r\n\r\nDirector: Robert Miller\r\nDirector of Photography: Howard Shack\r\nEditor: Gerard Zarra\r\nCelebrity Talent: Dave Matthews \r\nExecutive Producer: Traci Oshiro\r\nProducer: Jean-Luc Lukunku\r\nLine Producer: Jen Santos\r\nProduction Manager: James Pipitone\r\nProduction Coordinator: Jamal Colvin\r\nTalent Booker: Luke Leifeste\r\nCamera Operator: Michael Fox\r\nGaffer: Simon Fox \r\nAudio: Elijah Lawson\r\nProduction Assistant: Dexter Shack\r\nAssociate Director of Post Production: Jarrod Bruner \r\nPost Production Supervisor: Rachael Knight\r\nPost Production Coordinator: Ian Bryant\r\nSupervising Editor: Rob Lombardi\r\nAssistant Editor: Billy Ward\r\n\r\n00:00 Dave Matthews Band - Iconic Tracks\r\n00:14 Ants Marching\r\n02:34 Satellite\r\n04:45 Crash Into Me\r\n06:33 #41\r\n07:35 Don't Drink the Water\r\n09:57 The Space Between\r\n10:47 Everyday\r\n11:47 Grey Street\r\n12:45 Madman's Eyes\r\n13:56 Something to Tell My Baby\n\nStill haven’t subscribed to GQ on YouTube? ►► http://bit.ly/2iij5wt\r\nSubscribe to GQ magazine and get rare swag: https://bit.ly/2xNBH3i\r\nJoin the GQ Discord to talk men's fashion, watches, and more: https://discord.gg/gqmagazine\r\n\r\nABOUT GQ\r\nFor more than 50 years, GQ has been the premier men’s magazine, providing definitive coverage of style, culture, politics and more. In that tradition, GQ’s video channel covers every part of a man’s life, from entertainment and sports to fashion and grooming advice. Welcome to the modern guide to style advice, dating tips, celebrity videos, music, sports and more.\r\n\r\nhttps://www.youtube.com/user/GQVideos
#>   categories duration view_count comment_count
#> 1      Music    12:24     248276           377
#> 2      Music    14:45     555507           656
#>                                  original_url
#> 1 https://www.youtube.com/watch?v=8Pip_puDIOA
#> 2 https://www.youtube.com/watch?v=Lz33OZf4Yx0
```

##### Comment Data

``` r
out <- readRDS(here::here('youtube', "youtube_data", "processed", "gq_iconic_songs_2023-12-11.rds"))
out$comments |> 
  group_by(video) |> 
  summarise(comment_count = n())
#> # A tibble: 2 × 2
#>   video                                                 comment_count
#>   <chr>                                                         <int>
#> 1 Dave Matthews Breaks Down His Most Iconic Tracks | GQ           656
#> 2 St Vincent Breaks Down Her Most Iconic Songs | GQ               377
```

``` r
out <- readRDS(here::here('youtube', "youtube_data", "processed", "gq_iconic_songs_2023-12-11.rds"))
out$comments |> 
  group_by(video) |> 
  slice(c(4, 90, 150)) |> 
  data.frame()
#>                                                                                                                                            text
#> 1                                                                                                                    He’s a gift to this world.
#> 2                                                     The fact that “dancing nancies” and “funny the way it is” aren’t talked about is criminal
#> 3                                                                                           It’s a “song”.  Why call it a track?— it has words.
#> 4 marry me is one of her most iconic songs and its not mentioned in this video. i guess they might have confused iconic with most famous songs.
#> 5                                                                              the dog said, "I thought this was winona ryder." ~ tenderbastard
#> 6                                                                                                 Tabish Arif here https://youtu.be/P9xoa9W_1vo
#>         date like_count                          author
#> 1 2023-11-28         NA                @user-tb1lc3sr4g
#> 2 2023-08-12          1             @raynkaymireles3349
#> 3 2023-07-12         NA                @TarzanHedgepeth
#> 4 2023-04-12         NA                    @ottolettuce
#> 5 2019-12-12         NA @tenderbastardtenderbastard8050
#> 6 2019-12-12         NA             @TheEmeraldWizard02
#>                                                   video
#> 1 Dave Matthews Breaks Down His Most Iconic Tracks | GQ
#> 2 Dave Matthews Breaks Down His Most Iconic Tracks | GQ
#> 3 Dave Matthews Breaks Down His Most Iconic Tracks | GQ
#> 4     St Vincent Breaks Down Her Most Iconic Songs | GQ
#> 5     St Vincent Breaks Down Her Most Iconic Songs | GQ
#> 6     St Vincent Breaks Down Her Most Iconic Songs | GQ
```

#### YouTube Scraper

The `youtube_scrape()` function allows for the downloading of a video,
it’s subtitles, clean text of the subtitles/captions, and all metrics of
the video. The user can specify what they want to download. This should
be particularly useful for the caption text.

``` r
youtube_scraper(
  link = "https://www.youtube.com/watch?v=fpYu9XRZZNw", 
  get_captions = TRUE,
  get_comments = TRUE, 
  download_video = TRUE,
  output_dir = "youtube/yt_caption_data")
```
