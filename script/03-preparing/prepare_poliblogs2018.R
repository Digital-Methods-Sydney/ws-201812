library(stm)

# The `textProcessor()` function from the stm package takes two arguments: 
# 1. a `character()` vector containing the text and 
# 2. a `data.frame()`
processed <- 
  textProcessor(poliblogs2008$documents, metadata = poliblogs2008)

out <- prepDocuments(processed$documents, processed$vocab, processed$meta)
docs <- out$documents
vocab <- out$vocab
meta <-out$meta