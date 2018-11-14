library(pdftools)
library(tidyverse)
library(stringr)

# List PDFs
file_names <- list.files("./data/pdf")

# Loop over each file name and read into list
texts_by_page <- list()
for (f in file_names) {
  texts_by_page[[f]] <- 
    pdf_text(sprintf("./data/pdf/%s", f))
}

# Read each document into a character vector
texts_by_document <- character()
for (f in file_names) {
  texts_by_document[[f]] <- 
    str_c(texts_by_page[[f]] %>% str_squish(), collapse = " ")
}
  


