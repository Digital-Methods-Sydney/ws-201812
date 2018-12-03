# Part of this code is from:
# Robinson, J. S. D. (2017). Text mining with R: A tidy approach. 
# Sebastopol, CA: O’Reilly.


# Tidy text
tidy_df <- 
  tibble(doc = names(texts_by_document),
         text = texts_by_document) %>%
  unnest_tokens(word, text) %>%
  filter(str_detect(word, "[a-z]+")) %>%
  count(word, sort = TRUE)





