library(sf)
library(tidyverse)

durhamprecinct <- read_rds("DurhamPrecinct.rds")

library(tigris)

options(tigris_class = "sf")
durham_bg <- block_groups(state="37", county = "063", 
                          cb = TRUE, year = 2019) %>%
  st_transform("WGS84") %>%
  mutate(GEOIDShort=str_sub(GEOID, 6))
durham_b <- blocks(state="37", county = "063",
                          year = 2019) %>%
  st_transform("WGS84") %>%
  mutate(GEOIDShort=str_sub(GEOID10, 6))

# library(tidycensus)
# v18 <- load_variables(year=2018, dataset="acs5", cache=TRUE)
# popcb <- get_acs(geography = "block group", variables=c("TotalPop"="B01001_001"), 
#                  state="37", county="063", geometry = TRUE )  

library(leaflet)

colors <- c('#66c2a5','#fc8d62','#8da0cb')

map_durh <- leaflet() %>%
  addTiles() %>%
  addPolygons(data = durhamprecinct, 
              group = "Precinct", 
              popup = ~prec_id,
              color=colors[1],
              fillOpacity = 0,
              weight=3
              ) %>%
  addPolygons(data = durham_bg, 
              group = "Block Group",
              color=colors[2],
              popup=~GEOIDShort,
              fillOpacity = 0,
              weight=3) %>%
  # addPolygons(data = durham_b, 
  #             group = "Block",
  #             color=colors[3],
  #             popup=~GEOIDShort,
  #             fillOpacity = 0,
  #             weight=3) %>%
  addProviderTiles(providers$Stamen.TonerLite, group= "TonerLight") %>% 
  addLayersControl(
    overlayGroups = c("Precinct", "Block Group"),
    baseGroups = c("OSM (default)", "TonerLight"),
    options = layersControlOptions(collapsed = FALSE)
  ) 

library(htmlwidgets)
saveWidget(map_durh, "Durham_Precinct_CBGMap.html")
