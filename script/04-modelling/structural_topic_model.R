## --- structural_topic_model ---

library(stm)

# This will take a few seconds
model <- 
  stm(books_dfm, K = 4, 
      verbose = FALSE, init.type = "Spectral")

# Show most significant words by topic
labelTopics(model, 1:4)

# Show proportion by topic
plot(model, type = "summary")

# Cloud for a topic
cloud(model, topic = 1, scale = c(2,.25))

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

poliblogPrevFit <- stm(documents = out$documents, vocab = out$vocab,
                       + K = 20, prevalence =~ rating + s(day),
                       + max.em.its = 75, data = out$meta,
                       + init.type = "Spectral")


