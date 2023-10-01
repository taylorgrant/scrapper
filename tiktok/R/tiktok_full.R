## Function to scrape TikTok ## 

# 1. start with LinkGopher to extract all urls
# 2. add links to a csv with the column name "links"
# 3. save csv as "[handle_name]_tt_links.csv" in the "tt_link_data" folder
# 4. run this function 

tt_scrape_fn <- function(handle) {
  pacman::p_load(tidyverse, janitor, here, glue)
  source(here('tiktok','R','helpers', 'helpers.R'))
  source(here('tiktok','R', 'tiktok_scrape.R'))
  # source(here('tiktok',"R", "helpers", "tweetnlp_functions.R"))
  
  loc <- here('tiktok','tt_link_data', glue("{handle}_tt_links.csv"))
  urls <- lg_clean(loc, handle)
  
  #-- scrap tiktok urls
  out <- tiktok_scrape(urls)
  
  out <- out |> 
    distinct(id, .keep_all = TRUE) |> 
    arrange(desc(timestamp))
  
  saveRDS(out, here('tiktok','tiktok_report', 'tiktok_data', glue::glue('tt_{handle}-{Sys.Date()}.rds')))
  
  openxlsx::write.xlsx(out, here('tiktok','tiktok_report', 'tiktok_data', glue::glue('tt_{handle}-{Sys.Date()}.xlsx')))
}

# example 
# tt_scrape_fn("lowes")


# NLP (optional) ----------------------------------------------------------
# 5. add in NLP
# import tweetnlp and load model
tweetnlp <- reticulate::import("tweetnlp")

# load transformer models  
sentiment_model <- tweetnlp$load_model('sentiment')
multiclass_model <- tweetnlp$load_model('topic_classification', multi_label=TRUE)
emoji_model <- tweetnlp$load_model('emoji')
emotion_model <- tweetnlp$load_model('emotion')
ner_model <- tweetnlp$load_model('ner')
# to strip out urls when running sentiment
url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"

# run the nlp
out <- out |> 
  mutate(sentiment = map(str_replace_all(post_text, url_pattern, ""), tweetnlp_sentiment),
         top_emotion = map(str_replace_all(post_text, url_pattern, ""), tweetnlp_emotion),
         entity = map(str_replace_all(post_text, url_pattern, ""), tweetnlp_ner),
         topic = map(str_replace_all(post_text, url_pattern, ""), tweetnlp_topic),
         emoji = map(str_replace_all(post_text, url_pattern, ""), tweetnlp_emoji)
  ) |> 
  unnest(cols = c(sentiment, 
                  top_emotion,
                  entity,
                  topic, 
                  emoji
  ))


