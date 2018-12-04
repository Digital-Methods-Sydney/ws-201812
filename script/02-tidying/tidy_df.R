## ---- tidy_df1 ----

library(tidyverse)
library(tidytext)

class(texts_by_document)
length(texts_by_document)

# Tidy text (from PDFs)
tidy_df <- 
  tibble(doc = names(texts_by_document),
         text = texts_by_document) %>%
  unnest_tokens(word, text) %>%
  filter(str_detect(word, "[a-z]+")) %>%
  count(word, sort = TRUE)

# Code modified from Julia Silge & Robinson, 2017.





