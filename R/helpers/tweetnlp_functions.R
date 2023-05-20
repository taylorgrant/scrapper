# sentiment function
tweetnlp_sentiment <- function(text) {
  sentiment_model$sentiment(text)$label
}

# single class classification function
tweetnlp_topic <- function(text) {
  singleclass_model$topic(text)$label
}