library(rvest)
library(tidyverse)
library(stringr)

# Parse page containing articles published 26 nov 2018
seed_url <- 'https://www.theguardian.com/society/2018/nov/26'
day_page <- read_html(seed_url)
nodes <- html_nodes(day_page, xpath = './/div[@class="fc-item__content "]')

# Loop
article_urls <- character()
for (node in nodes) {
  node_a <- html_node(node, xpath = ".//a")
  article_url <- html_attr(node_a, 'href')
  article_urls <- c(article_url, article_urls)
}

# Create a data.frame and store parts of the articles
article_df <- data.frame()
for (article_url in article_urls) {
  article_page <- 
    read_html(article_url)
  body <- 
    html_node(article_page, xpath=".//div[@itemprop='articleBody']") %>%
    html_text() %>%
    str_trim()
  author <- 
    html_node(article_page, xpath=".//span[@itemprop='name']") %>%
    html_text() %>%
    str_trim()
  date <- 
    html_node(article_page, xpath=".//time[@itemprop='datePublished']") %>%
    html_text() %>%
    str_trim()
  title <- 
    html_node(article_page, xpath=".//h1[@itemprop='headline']") %>%
    html_text() %>%
    str_trim()
  article_df <- 
    rbind(article_df, 
          data.frame(body, author, date, title,
                     stringsAsFactors = F))
}