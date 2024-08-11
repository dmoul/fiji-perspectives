# prepare-osm-data.R

# From OpenStreetMap using osmdata package


####### OSM data: coastline

# TODO: Confirm why my_bbox_fj is different from my_proposed_bbox
xmin = 176.75
ymin = -19.260603
xmax = 179.999
ymax = -16

my_bbox_fj <- c(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax)

# proposed bbox (from manual selection on Google Maps)
# SE corner: -17.816854, 178.107928
# NW corner: -16.648403, 177.020806

my_proposed_bbox <- matrix(c(177.020806, -17.816854, 178.107928, -16.648403),
                           byrow = FALSE, nrow = 2, ncol = 2, dimnames = list(c("x", "y"), c("min", "max"))
)

fname <- here("data/processed/coastline.rds")
if(!file.exists(fname)) {
  
  coastline <- my_proposed_bbox |>
    opq()%>%
    add_osm_feature(key = "natural", 
                    value = c("coastline")) %>%
    osmdata_sf()
  
  write_rds(coastline, fname)
  
} else {
  
  coastline <- read_rds(fname)
  
}


####### OSM data: islands

fname <- here("data/processed/islands.rds")
if(!file.exists(fname)) {
  
  islands <- my_proposed_bbox |>
    opq()%>%
    add_osm_feature(key = "place",
                    value = c("island")) %>%
    osmdata_sf()
  
  write_rds(islands, fname)
  
} else {
  
  islands <- read_rds(fname)
  
}


####### OSM data: coastline Yasawas

xmin = 176
ymin = -16.5
xmax = 177.75
ymax = -17.75

my_bbox_yasawas <- c(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax)

fname <- here("data/processed/coastline-yasawas.rds")
if(!file.exists(fname)) {

  coastline_yasawas <- my_bbox_yasawas |>
    opq()%>%
    add_osm_feature(key = "natural",
                    value = c("coastline")) %>%
    osmdata_sf()

  write_rds(coastline_yasawas, fname)

} else {

  coastline_yasawas <- read_rds(fname)

}


####### OSM data: islands Yasawas

fname <- here("data/processed/islands-yasawas.rds")
if(!file.exists(fname)) {
  
  islands_yasawas <- my_bbox_yasawas |>
    opq()%>%
    add_osm_feature(key = "place",
                    value = c("island")) %>%
    osmdata_sf()
  
  write_rds(islands_yasawas, fname)
  
} else {
  
  islands_yasawas <- read_rds(fname)
  
}


####### OSM data: Yacula island places

# NW: -16.828005, 177.313155
# SE: -16.951690, 177.488593
xmin = 177.313155
ymin = -16.828005
xmax = 177.488593
ymax = -16.951690

my_bbox_nacula <- c(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax)

fname <- here("data/processed/nacula-places.rds")
if(!file.exists(fname)) {
  
  nacula_places <- my_bbox_nacula |>
    opq()%>%
    add_osm_features(
      features = list(
        "place" = "village",
        "leisure" = "resort",
        "tourism" ="hotel",
        "office" = "government",
        "landuse" = "residential"
      )
    ) %>%
    osmdata_sf()
  
  write_rds(nacula_places, fname)
  
} else {
  
  nacula_places <- read_rds(fname)
  
}


####### OSM data: Yacula island reefs

# NW: -16.828005, 177.313155
# SE: -16.951690, 177.488593
# xmin = 177.313155
# ymin = -16.828005
# xmax = 177.488593
# ymax = -16.951690
# 
# my_bbox_fj_nacula <- c(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax)

# reefs <- my_bbox_nacula |>
#   opq() %>%
#   add_osm_features(
#     features = list(
#       "natural" = "reef",
#       "sub_sea" = "reef"
#     )) %>%
  # osmdata_sf()

fname <- here("data/processed/nacula-reefs.rds")
if(!file.exists(fname)) {
  
  nacula_reefs <- my_bbox_nacula |>
    opq()%>%
    add_osm_features(
      features = list(
        "natural" = "reef",
        "sub_sea" = "reef"
      )
    ) %>%
    osmdata_sf()
  
  write_rds(nacula_reefs, fname)
  
} else {
  
  nacula_reefs <- read_rds(fname)
  
}
