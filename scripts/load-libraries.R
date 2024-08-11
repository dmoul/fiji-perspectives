# load-libraries.R

library(here)
library(tidyverse)
library(janitor)
library(scales)
library(glue)
library(patchwork)
library(ggrepel)
library(gt)

# for GIS / maps
library(sf)
library(terra)
library(osmdata)
library(tidyterra) # for scale_*_hypso_tint_c()
library(rnaturalearth) # for ne_countries()

# for WHO data
library(httr)
library(jsonlite)
library(ISOcodes)

# library(ggplot2)
# library(dplyr)
# library(forcats)
# library(tidyr)
# library(dplyr)
# library(readr)
