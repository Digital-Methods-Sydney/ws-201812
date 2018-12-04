## ---- document_term_matrix ----

library(tidyverse)
library(tidyverse)

load('data/rdata/g_books.RData')

reg <- regex("^chapter ", ignore_case = TRUE)
by_chapter <- g_books %>%
  group_by(title) %>%
  mutate(chapter = cumsum(str_detect(text, reg))) %>%
  filter(chapter > 0) %>%
  ungroup() %>%
  group_by(gutenberg_id, title, chapter) %>%
  summarize(text = paste(text, collapse = " ")) %>%
  unite(title_chapter, title, chapter, sep = " # ")

tidy_books <- 
  by_chapter %>%
  group_by(title_chapter) %>%
  unnest_tokens(word, text) %>%
  ungroup() %>%
  mutate(word = str_extract(word, "[a-zA-Z]+")) %>%
  anti_join(stop_words, by = 'word')
nrow(tidy_books)

books_dfm <- tidy_books %>%
  count(title_chapter, word, sort = TRUE) %>%
  cast_dfm(title_chapter, word, n)

