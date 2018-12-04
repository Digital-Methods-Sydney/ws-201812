## ---- tidy_df ----

library(tidyverse)
library(tidytext)

head(texts_by_document)

# Tidy text (from PDFs)
head(texts_by_document)
tidy_df <- 
  tibble(doc = names(texts_by_document),
         text = texts_by_document) %>%
  unnest_tokens(word, text) %>%
  filter(str_detect(word, "[a-z]+")) %>%
  count(word, sort = TRUE)

# Part of this code is from: Robinson, J. S. D. (2017). Text mining with R: A tidy approach. Sebastopol, CA: O’Reilly.




