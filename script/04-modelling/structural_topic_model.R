## --- structural_topic_model ---

library(stm)

# This will take a few seconds
model <- 
  stm(books_dfm, K = 4, 
      verbose = FALSE, init.type = "Spectral")

tidy_topics_word_topic <-
  tidy(model)

kable(head(tidy_topics_word_topic))

tidy_topics_doc_topic <- 
  tidy(model, matrix = "gamma",                    
       document_names = rownames(books_dfm))

tidy_topics_doc_topic <-
  tidy_topics_doc_topic %>%
  separate(document, c("title", "chapter"), sep = " # ", convert = TRUE)

kable(head(tidy_topics_doc_topic))

## --- vis stm1 ---

ggplot(tidy_topics_doc_topic,
       aes(y = gamma, x=factor(topic))) +
  geom_boxplot() + 
  facet_wrap(~title)

## --- vis stm2 ---

library(tsne)
tidy_topics_doc_topic$document <- 
  paste0(tidy_topics_doc_topic$title, " # ", tidy_topics_doc_topic$chapter)
spread_topics_doc_topic <-
  tidy_topics_doc_topic %>%
  spread(topic, gamma)

res <- tsne(spread_topics_doc_topic[,4:7], k=2)
spread_topics_doc_topic$x <- res[,1]
spread_topics_doc_topic$y <- res[,2]

ggplot(spread_topics_doc_topic, aes(x=x,y=y,colour=title)) +
  geom_point()

## --- structural_topic_model (Advanced) ---

# Bonus



