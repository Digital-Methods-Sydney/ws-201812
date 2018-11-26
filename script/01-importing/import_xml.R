library(xml2) 
library(tidyverse)

# Read the document
doc <- 
  read_xml('data/xml/apollinaire_heresiarque-et-cie-gold-geonames.xml',
           encoding = "utf-8")

# Identify the document namespace
xml_ns(doc)

# Find all place nodes `placeName`
place_names <-
  xml_find_all(doc, 
               ".//d1:placeName")

# Extract attributes and names
place_names.df <-
  data.frame(ref = xml_attr(place_names, "ref"),
             name = xml_text(place_names),
             stringsAsFactors = F)
place_names.df <- 
  place_names.df %>% group_by(ref, name) %>% 
  summarize(citations = n())

# Enrich -- BONUS Linked data + SPARQL query
place_names.df$class <- NA
place_names.df$long <- NA
place_names.df$lat <- NA

for (i in 1:nrow(place_names.df)) {
  print(i)
  if (is.na(place_names.df$ref[i]) | place_names.df$ref[i] == "") next
  this_rdf <- try({
    read_xml(paste0(place_names.df$ref[i], "/about.rdf"))
  })
  if (class(this_rdf) == 'try-error') next
  place_names.df$lat[i] <- 
    as.numeric(xml_text(xml_find_all(this_rdf, './/wgs84_pos:lat')))
  place_names.df$long[i] <- 
    as.numeric(xml_text(xml_find_all(this_rdf, './/wgs84_pos:long')))
  place_names.df$class[i] <- 
    xml_attr(xml_find_all(this_rdf, './/gn:featureClass'), 'resource')
}

# save(place_names.df, file = 'data/xml/place_names.df.RData')

table(place_names.df$class)

place_names.df$type <- 
  ifelse(grepl("#A|#L", place_names.df$class), "area", "point")

library(leaflet) # See https://rstudio.github.io/leaflet/
# Area
leaflet(data = place_names.df[place_names.df$type=='area',]) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(~long, ~lat, 
                   radius = ~citations*4,
                   color = 'red',
                   stroke = FALSE, fillOpacity = 0.8,
                   popup = ~as.character(name))

# Point
leaflet(data = place_names.df[place_names.df$type=='point',]) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(~long, ~lat, 
                   radius = ~citations*4,
                   color = 'blue',
                   stroke = FALSE, fillOpacity = 0.8,
                   popup = ~as.character(name))
