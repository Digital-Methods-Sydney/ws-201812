# Part of this code is from:
# Robinson, J. S. D. (2017). Text mining with R: A tidy approach. 
# Sebastopol, CA: O’Reilly.

# Gutenberg Project books
table(g_books$title)

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

reg <- "\\S+" # counting all sequences on non-space characters
by_chapter %>% 
  group_by(title, chapter) %>%
  summarize(words_by_chapter = str_count(paste(text, collapse = " "), reg)) %>%
  ungroup() %>%
  group_by(title) %>%
  summarize(n_chapters = n(),
            avg_words_by_chapter = mean(words_by_chapter))

library(tidytext)
# split into words
by_chapter_word <- by_chapter %>%
  unnest_tokens(word, text)

by_chapter_bigram <- by_chapter %>%
  unnest_tokens(bigram, text, 
                token = "ngrams", n = 2)

# find document-word counts
word_counts <- by_chapter_word %>%
  anti_join(stop_words) %>%
  mutate(word = str_extract(word, "[a-z']+")) %>%
  filter(!is.na(word)) %>%
  count(title, word, sort = TRUE) %>%
  ungroup()

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