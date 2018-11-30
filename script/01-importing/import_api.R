library(tidyverse)

# This package provides an interface to the arXiv API (see https://arxiv.org/help/api/index)
library(aRxiv)
res <- 
  arxiv_search("topic models", limit = 100)

# This package provides an interface to the arXiv API (see https://arxiv.org/help/api/index)
library(gutenbergr)

## This won't download the actual book but the metadata
res <-
  gutenberg_works(author == "Dick, Philip K.")
## This will download the book data
g_books <-
  gutenberg_download(res$gutenberg_id, meta_fields = 'title')

## Let's download two books we will use later
titles <- c("Twenty Thousand Leagues under the Sea", 
            "Frankenstein; Or, The Modern Prometheus",
            "Alice's Adventures in Wonderland",
            "Adventures of Huckleberry Finn")
g_books <-
  gutenberg_works(title %in% titles) %>%
  gutenberg_download(meta_fields = "title")

## Wikipedia API
library(jsonlite)
res <- 
  fromJSON('http://en.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&rvprop=content&rvsection=0&titles=pizza')


## BONUS: Word-cloud
library(tidyverse)
library(tidytext)

data(stop_words) # Let's load a list of stopwords from the `tidytext` package

tidy_books <- 
  g_books %>%
  group_by(title) %>%
  unnest_tokens(word, text) %>%
  ungroup() %>%
  mutate(word = str_extract(word, "[a-zA-Z]+")) %>%
  anti_join(stop_words, by = 'word')
nrow(tidy_books)

tidy_books <- 
  tidy_books %>%
  group_by(title, word) %>%
  summarize(n = n())

tidy_books %>%
  group_by(title) %>%
  top_n(10, n) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x=word, y=n)) +
  geom_col() +
  facet_wrap(~title, scales = "free") +
  coord_flip()






