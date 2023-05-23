pacman::p_load(tidyverse, reticulate)


# LOAD MODULES ------------------------------------------------------------
UMAP <- import("umap")
HDBSCAN <- import("hdbscan")
st <- import('sentence_transformers')
cv <- import('sklearn.feature_extraction.text')

BERTopic <- import('bertopic')
KeyBERTInspired <- import('bertopic.representation')
ClassTfidfTransformer <- import('bertopic.vectorizers')

json <- import('json')
plotutils <- import("plotly.utils")


# BUILD BERTopic function -------------------------------------------------
# Step 1 - Extract embeddings
embedding_model <- st$SentenceTransformer("all-MiniLM-L6-v2")

# Step 2 - Reduce Dimensionality
umap_model <- UMAP$UMAP(n_neighbors = as.integer(15), n_components = as.integer(5), min_dist = 0.0, metric = "cosine")

# Step 3 - Cluster reduced embeddings
hdbscan_model <- HDBSCAN$HDBSCAN(min_cluster_size=as.integer(15), metric="euclidean", cluster_selection_method="eom", prediction_data = TRUE)

# Step 4 - Tokenize topics
vectorizer_model <- cv$CountVectorizer(stop_words = "english")

# Step 5 - Create topic representation
ctfidf_model <- ClassTfidfTransformer$ClassTfidfTransformer(reduce_frequent_words=TRUE)

# Step 6 - Fine-tune topic representations
representation_model <- KeyBERTInspired$KeyBERTInspired()

# All steps together
topic_model <- BERTopic$BERTopic(
  embedding_model = embedding_model,
  umap_model = umap_model, 
  hdbscan_model = hdbscan_model, 
  vectorizer_model = vectorizer_model,
  ctfidf_model = ctfidf_model,
  representation_model = representation_model,
  nr_topics = "auto", 
  n_gram_range = tuple(1L,3L)
)


# LOAD AND CLEAN DATA -----------------------------------------------------
tweets <- readRDS(here::here('tw_data', 'debtceiling_tweets.rds'))
url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"

docs <- tweets |> 
  mutate(text = trimws(str_replace_all(text, url_pattern, "")),
         text = str_replace_all(text, "@|#", ""),
         text = tolower(text),
         text = gsub("[[:punct:][:blank:]]+", " ", text)) |> 
  select(text) |> 
  as.list()


# RUN MODEL ---------------------------------------------------------------
out <- topic_model$fit_transform(docs$text) |> 
  purrr::set_names(nm = c("topics", "probs"))

# TOPIC REPRESENTATION ----------------------------------------------------
# change topic terms
vectorizer_model <- cv$CountVectorizer(stop_words = "english", ngram_range = tuple(1L,3L))
topic_model$update_topics(docs$text, vectorizer_model=vectorizer_model)

# custom topic labels 
topic_labels <- topic_model$generate_topic_labels(nr_words=5L,
                                                  topic_prefix = FALSE,
                                                  word_length = 10L,
                                                  separator = ", ")
topic_model$set_topic_labels(topic_labels)

# can get basic topic info 
topic_model$get_topic_info() |> 
  mutate(frac = Count/sum(Count))

# get get data on documents per topic
doc_out <- topic_model$get_document_info(docs$text)

# VISUALIZATION ----------------------------------------------------
# visualize topics
viz <- topic_model$visualize_topics(custom_labels = TRUE)
viz = json$dumps(viz, cls=plotutils$PlotlyJSONEncoder)
plotly::as_widget((jsonlite::fromJSON(viz, simplifyVector = FALSE)))

# visualize documents
embeddings <- embedding_model$encode(docs$text) # prep embeddings
doc_model <- BERTopic$BERTopic(nr_topics = 40L)$fit(docs$text, embeddings) # train topic
doc_viz <- doc_model$visualize_documents(docs$text, embeddings = embeddings, hide_document_hover = TRUE, hide_annotations = TRUE)
doc_viz = json$dumps(doc_viz, cls=plotutils$PlotlyJSONEncoder)
plotly::as_widget((jsonlite::fromJSON(doc_viz, simplifyVector = FALSE)))

reduced_embeddings <- UMAP$UMAP(n_neighbors = 10L, n_components = 2L, min_dist =0.0, metric = "cosine")$fit_transform(embeddings)
doc_model <- BERTopic$BERTopic(nr_topics = 40L)$fit(docs$text, embeddings) # train topic
doc_viz <- doc_model$visualize_documents(docs$text, reduced_embeddings = reduced_embeddings, custom_labels=TRUE, hide_document_hover = TRUE, hide_annotations = FALSE)
doc_viz = json$dumps(doc_viz, cls=plotutils$PlotlyJSONEncoder)
plotly::as_widget((jsonlite::fromJSON(doc_viz, simplifyVector = FALSE)))

# visualize topic hierarchy
hier_viz <- topic_model$visualize_hierarchy()
hier_viz = json$dumps(hier_viz, cls=plotutils$PlotlyJSONEncoder)
plotly::as_widget((jsonlite::fromJSON(hier_viz, simplifyVector = FALSE)))

# hierarchical labels 
hierarchical_topics <- topic_model$hierarchical_topics(docs$text)
hier_viz <- topic_model$visualize_hierarchy(hierarchical_topics=hierarchical_topics)
hier_viz = json$dumps(hier_viz, cls=plotutils$PlotlyJSONEncoder)
plotly::as_widget((jsonlite::fromJSON(hier_viz, simplifyVector = FALSE)))

# topic barcharts 
bar_viz <- topic_model$visualize_barchart()
bar_viz = json$dumps(bar_viz, cls=plotutils$PlotlyJSONEncoder)
plotly::as_widget((jsonlite::fromJSON(bar_viz, simplifyVector = FALSE)))

# topic similarity
heat_viz <- topic_model$visualize_heatmap()
heat_viz = json$dumps(heat_viz, cls=plotutils$PlotlyJSONEncoder)
plotly::as_widget((jsonlite::fromJSON(heat_viz, simplifyVector = FALSE)))


# TOPIC REDUCTION ---------------------------------------------------------
topic_model <- BERTopic$BERTopic(nr_topics = "auto", n_gram_range = tuple(1L,3L))
out <- topic_model$fit_transform(docs$text) |> 
  purrr::set_names(nm = c("topics", "probs"))

# or can further reduce after training 
topic_model$reduce_topics(docs$text, nr_topics = 40L)
topics = topic_model$topics_


# TOPIC REPRESENTATION ----------------------------------------------------
# change topic terms
vectorizer_model <- cv$CountVectorizer(stop_words = "english", ngram_range = tuple(1L,5L))
topic_model$update_topics(docs$text, vectorizer_model=vectorizer_model)

# custom topic labels 
topic_labels <- topic_model$generate_topic_labels(nr_words=3L,
                                                  topic_prefix = FALSE,
                                                  word_length = 10L,
                                                  separator = ", ")
topic_model$set_topic_labels(topic_labels)


# SEARCH TOPICS -----------------------------------------------------------
sims <- topic_model$find_topics("public opinion", top_n = 10L) |> 
  purrr::set_names(nm = c("similar_topics", "similarity")) 
sims <- tibble(similar_topics = sims$similar_topics, 
         similarity = unlist(sims$similarity, use.names = FALSE))
sims

topic_model$get_topic(sims$similar_topics[1]) |> 
  do.call(what = 'rbind') |> 
  data.frame() |> 
  set_names(nm = c("topic", "metric"))

# to pull tweets from original data
tweets[which(out$topics == sims$similar_topics[1]),] |> 
  select(text) |> head(10)

tweets[which(out$topics == 1),] 

# replot using new topic names 
viz <- topic_model$visualize_topics(custom_labels = TRUE)
viz = json$dumps(viz, cls=plotutils$PlotlyJSONEncoder)
plotly::as_widget((jsonlite::fromJSON(viz, simplifyVector = FALSE)))



