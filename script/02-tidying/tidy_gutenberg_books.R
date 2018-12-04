## ---- tidy_df2 ----

# Gutenberg Project books
kable(table(g_books$title), format = 'html')

## ---- tidy_df3 ----

library(tidytext)
library(stringr)

# divide into documents, each representing one chapter
reg <- regex("^chapter ", ignore_case = TRUE)
by_chapter <- g_books %>%
  group_by(title) %>%
  mutate(chapter = cumsum(str_detect(text, reg))) %>%
  filter(chapter > 0) %>%
  ungroup() %>%
  group_by(gutenberg_id, title, chapter) %>%
  summarize(text = paste(text, collapse = " "))

## ---- tidy_df4 ----

reg <- "\\S+" # counting all sequences on non-space characters
by_chapter %>% 
  group_by(title, chapter) %>%
  summarize(words_by_chapter = str_count(paste(text, collapse = " "), reg)) %>%
  ungroup() %>%
  group_by(title) %>%
  summarize(n_chapters = n(),
            avg_words_by_chapter = mean(words_by_chapter))

## ---- tidy_df5 ----

# split into words
by_chapter_word <- by_chapter %>%
  unnest_tokens(word, text)

by_chapter_bigram <- by_chapter %>%
  unnest_tokens(bigram, text, 
                token = "ngrams", n = 2)

## ---- tidy_df6 ----

# find document-word counts
word_counts <- by_chapter_word %>%
  anti_join(stop_words) %>%
  mutate(word = str_extract(word, "[a-z']+")) %>%
  filter(!is.na(word)) %>%
  count(title, word, sort = TRUE) %>%
  ungroup()

## ---- tidy_df7 ----

word_counts %>% 
  group_by(title) %>%
  top_n(10, n) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill=title)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~title, scales = "free") +
  labs(y = "10 most frequent words",
       x = NULL) +
  coord_flip()

## ---- tidy_df8 ----

by_chapter_bigram$bigram <- 
  str_replace_all(by_chapter_bigram$bigram, "_|'s", "")
bigram_counts <- by_chapter_bigram %>%
  count(title, bigram, sort = TRUE) %>%
  ungroup()

# Some extra cleaning
by_chapter_bigram_sep <- 
  by_chapter_bigram %>%
  separate(bigram, c("word1", "word2"), sep = " ") %>%
  filter(!word1 %in% stop_words$word &
           !str_detect(word1, "[0-9]")) %>%
  filter(!word2 %in% stop_words$word &
           !str_detect(word2, "[0-9]"))


bigram_counts <- by_chapter_bigram_sep %>%
  count(word1, word2, sort = TRUE)

bigram_counts <- bigram_counts %>%
  unite(bigram, word1, word2, sep = " ")

## ---- tidy_df10 ----

bigram_counts %>% 
  group_by(title) %>%
  top_n(10, n) %>%
  ungroup() %>%
  mutate(bigram = reorder(bigram, n)) %>%
  ggplot(aes(bigram, n, fill=title)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~title, scales = "free") +
  labs(y = "10 most frequent bigrams by book",
       x = NULL) +
  coord_flip()

# Code modified from Julia Silge & Robinson, 2017.