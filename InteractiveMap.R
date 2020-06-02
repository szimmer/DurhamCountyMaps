library(sf)
library(tidyverse)

durhamprecinct <- read_rds("DurhamPrecinct.rds")

library(tigris)

options(tigris_class = "sf")
durham_bg <- block_groups(state="37", county = "063", 
                          cb = TRUE, year = 2019) %>%
  st_transform("WGS84") %>%
  mutate(GEOIDShort=str_sub(GEOID, 6))
# durham_b <- blocks(state="37", county = "063", 
#                           year = 2019)

library(leaflet)

leaflet() %>%
  addTiles() %>%
  addPolygons(data = durhamprecinct, group = "Precinct", popup = ~prec_id) %>%
  addPolygons(data = durham_bg, group = "Block Group", color="red", popup=~GEOIDShort) %>%
  addLayersControl(
    overlayGroups = c("Precinct", "Block Group"),
    options = layersControlOptions(collapsed = FALSE)
  )
