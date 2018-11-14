# Tidy text
tidy_df <- 
  tibble(doc = names(texts_by_document),
         text = texts_by_document) %>%
  unnest_tokens(word, text) %>%
  filter(str_detect(word, "[a-z]+")) %>%
  count(word, sort = TRUE)