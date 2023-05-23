pacman::p_load(tidyverse, janitor, here, glue, reticulate)

# load snscrape functions 
source_python(here::here("py_functions", "build_twitter_query.py"))
source_python(here::here("py_functions", "twitter_search.py"))
# load tweetnlp functions
source(here::here("R", "helpers", "tweetnlp_functions.R"))

# build query
query <- build_twitter_query(text = "debt ceiling", username = "",
                             since = "2022-01-01", until = "",
                             retweet = "y",replies = "y")

# how many to get
n = 20000

# run it
out <- twitter_search(n, query) |> 
  mutate(datetime = lubridate::with_tz(datetime, tzone = "America/Los_Angeles"),
         tweet_mentions = sapply(str_extract_all(text, "@\\w+"), function(x) paste(x, collapse = ", ")),
         text = str_replace_all(text, "\n", ""),
         text = str_replace_all(text, "&amp;", "&")) |> 
  relocate(tweet_mentions, .before = tweet_media)

# import tweetnlp and load model
tweetnlp <- reticulate::import("tweetnlp")

# load transformer models  
sentiment_model <- tweetnlp$load_model('sentiment')
multiclass_model <- tweetnlp$load_model('topic_classification', multi_label=TRUE)
emoji_model <- tweetnlp$load_model('emoji')
emotion_model <- tweetnlp$load_model('emotion')
ner_model <- tweetnlp$load_model('ner')

# run the nlp
out <- out |> 
  mutate(sentiment = map(str_replace_all(text, url_pattern, ""), tweetnlp_sentiment),
         top_emotion = map(str_replace_all(text, url_pattern, ""), tweetnlp_emotion),
         entity = map(str_replace_all(text, url_pattern, ""), tweetnlp_ner),
         topic = map(str_replace_all(text, url_pattern, ""), tweetnlp_topic),
         emoji = map(str_replace_all(text, url_pattern, ""), tweetnlp_emoji)) |> 
  unnest(cols = c(sentiment, top_emotion, topic, emoji))


