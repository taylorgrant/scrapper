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
  paste(multiclass_model$topic(text, return_probability = TRUE)$label, collapse = "; ")
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

# NER is difficult to get to work; @mentions seem to do better when lowercase
# like so: entity = map(str_replace_all(str_replace_all(snippet, "@\\w+", tolower), url_pattern, ""), tweetnlp_ner)
# to spread entities across columns to count, can do something like this: 
# out |> 
#   separate_wider_delim(entity, delim = "; ", 
#                        names = letters[1:10],
#                        too_few = "align_start") |> 
#   pivot_longer(names_to = "letter", 
#                values_to = "value", 
#                cols = letters[1:10]) |> 
#   filter(!is.na(value)) |> 
#   separate_wider_delim(value, delim = ": ", 
#                        names = c("type", "entity")) |> 
#   filter(!entity %in% c("#", "@"))

# to strip out urls when running sentiment
url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"


