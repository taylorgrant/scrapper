pacman::p_load(tidyverse, janitor, here, glue, reticulate)

# load snscrape functions 
source_python(here::here("py_functions", "build_twitter_query.py"))
source_python(here::here("py_functions", "twitter_search.py"))
# load tweetnlp functions
source(here::here("R", "helpers", "tweetnlp_functions.R"))

# build query
query <- build_twitter_query(text = "",username = "ddayen",since = "2023-05-10", until = "",retweet = "y",replies = "y")

# how many to get
n = 40

# run it
out <- twitter_search(n, query)

# clean the data 
out <- out |> 
  mutate(datetime = lubridate::with_tz(datetime, tzone = "America/Los_Angeles"),
         tweet_mentions = sapply(str_extract_all(text, "@\\w+"), function(x) paste(x, collapse = ", ")),
         text = str_replace_all(text, "\n", ""),
         text = str_replace_all(text, "&amp;", "&")) |> 
  relocate(tweet_mentions, .before = tweet_media)

# import tweetnlp and load model
tweetnlp <- reticulate::import("tweetnlp")

# load transformer models  
sentiment_model <- tweetnlp$load_model('sentiment')
singleclass_model <- tweetnlp$load_model('topic_classification', multi_label=FALSE)

# run the sentiment 
url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"
out <- out |> 
  mutate(
         sentiment1 = map(str_replace_all(text, url_pattern, ""), tweetnlp_sentiment),
  unnest(cols = sentiment)

# run the topic classifier
out <- out |> 
  mutate(topic = map(text, tweetnlp_topic)) |> 
  unnest(cols = topic)




