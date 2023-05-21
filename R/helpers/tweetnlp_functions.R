# sentiment function
tweetnlp_sentiment <- function(text) {
  tmp <- sentiment_model$sentiment(text, return_probability=TRUE)
  tmp <- cbind(sentiment = tmp$label, data.frame(lapply(tmp$probability, function(x) t(data.frame(x)))))
}

# emotion function
tweetnlp_emotion <- function(text) {
  emofn <- function() {
    tibble(emotion_prob = unlist(tmp$probability, use.names = FALSE)) |> 
    slice_max(order_by = emotion_prob, n = 1)
  }
  tmp <- emotion_model$emotion(text, return_probability=TRUE)
  tmp <- cbind(emotion = tmp$label, emofn())
}

# single class classification function
tweetnlp_topic <- function(text) {
  singleclass_model$topic(text)$label
}

# predict the emoji to end the tweet 
tweetnlp_emoji <- function(text) {
  emoji_model$emoji(text)$label
}

# named entity recognition 
tweetnlp_ner <- function(text) {
  tmp <- ner_model$ner(text)
  if (length(tmp) > 0) {
    do.call(rbind.data.frame, tmp) |> 
      mutate(entity = str_replace_all(glue::glue("{type}: {entity}"), "  ", " ")) |> 
      summarise(entity = paste(entity, collapse = "; "))
  }
}

# to strip out urls when running sentiment
url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"