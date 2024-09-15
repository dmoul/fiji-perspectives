# prepare-who-data.R

###### Metadata

# Indicators

fname <- here("data/processed/who-indicators.rds")
if(!file.exists(fname)) {
  
  dta <- fromJSON("https://ghoapi.azureedge.net/api/Indicator",
                  flatten = TRUE)
  indicators <- dta$value |>
    clean_names() |>
    remove_empty(which = "cols")
  
  write_rds(indicators, fname)
  
} else {
  
  indicators <- read_rds(fname)
  
}


# Dimensions used in indicators

# dta <- fromJSON("https://ghoapi.azureedge.net/api/Dimension", #here("data/raw/who/available-dimensions.json"), 
#                 flatten = TRUE)
# available_dimensions <- dta$value |>
#   clean_names() |>
#   remove_empty(which = "cols")

fname <- here("data/processed/who-dimensions.rds")
if(!file.exists(fname)) {
  
  dta <- fromJSON("https://ghoapi.azureedge.net/api/Dimension",
                  flatten = TRUE)
  dimensions <- dta$value |>
    clean_names() |>
    remove_empty(which = "cols")
  
  write_rds(dimensions, fname)
  
} else {
  
  dimensions <- read_rds(fname)
  
}


###### Healthy Life Expectancy (HALE)

# From indicators: 
# {"IndicatorCode":"WHOSIS_000002","IndicatorName":"Healthy life expectancy (HALE) at birth (years)","Language":"EN"}

fname <- here("data/processed/who-hale.rds")
if(!file.exists(fname)) {
  
  dta <- fromJSON("https://ghoapi.azureedge.net/api/WHOSIS_000002", 
                  flatten = TRUE) #content(response, "text"))
  hale <- dta$value |>
    clean_names() |>
    remove_empty(which = "cols")
  
  write_rds(hale, fname)
  
} else {
  
  
  hale <- read_rds(fname)
}

###### Age-adjusted diabetes

# Age-standardized death rates, diabetes mellitus, per 100,000

fname <- here("data/processed/who-diabetes.rds")
if(!file.exists(fname)) {
  
  dta <- fromJSON("https://ghoapi.azureedge.net/api/SA_0000001440", 
                  flatten = TRUE)
  
  diabetes <- dta$value |>
    clean_names() |>
    remove_empty(which = "cols") |>
    select(spatial_dim_type, spatial_dim, parent_location_code, parent_location,
           dim1, time_dim, numeric_value) |>
    mutate(value_mean = mean(numeric_value),
           .by = spatial_dim) |>
    mutate(rank_val = rank(value_mean, ties.method = "max"),
           spatial_dim_label = glue("{spatial_dim}: {rank_val}"),
           spatial_dim_label = fct_reorder(spatial_dim_label, value_mean))
  
  write_rds(diabetes, fname)
  
} else {
  
  diabetes <- read_rds(fname)
  
}

diabetes_long <- diabetes |>
  pivot_longer(cols = dim1,
               #names_to = "sex",
               values_to = "sex_value")

diabetes_wide <- diabetes_long |>
  pivot_wider(#cols = dim1,
    names_from = sex_value,
    values_from = numeric_value) |>
  mutate(rank_val = rank(SEX_BTSX, ties.method = "max"),
         spatial_dim_label = glue("{spatial_dim}: {rank_val}"),
         spatial_dim_label = fct_reorder(spatial_dim_label, rank_val)) |>
  mutate(pct_SEX_MLE = SEX_MLE / 1e5,
         pct_SEX_FMLE = SEX_FMLE / 1e5,
         pct_SEX_BTSX = SEX_BTSX / 1e5,)

# TODO: why only 2004 data?


###### NCD_BMI_MEAN

# NCD_BMI_MEAN Mean BMI (kg/m²) (age-standardized estimate)
# Age 18+

fname <- here("data/processed/who-ncd-bmi-mean.rds")

if(!file.exists(fname)) {
  
  dta <- fromJSON("https://ghoapi.azureedge.net/api/NCD_BMI_MEAN", 
                  flatten = TRUE)
  
  bmi_mean <- dta$value |>
    clean_names() |>
    remove_empty(which = "cols")
  
  write_rds(bmi_mean, fname)
  
} else {
  
  bmi_mean <- read_rds(fname)
  
}


###### NCD_obesity among adults

# NCD_BMI_30A Prevalence of obesity among adults, BMI &GreaterEqual; 30 (age-standardized estimate) (%)

fname <- here("data/processed/who-ncd-bmi-obesity.rds")

if(!file.exists(fname)) {
  
  dta <- fromJSON("https://ghoapi.azureedge.net/api/NCD_BMI_30A", 
                  flatten = TRUE)
  
  bmi_obesity <- dta$value |>
    clean_names() |>
    remove_empty(which = "cols")
  
  write_rds(bmi_obesity, fname)
  
} else {
  
  bmi_obesity <- read_rds(fname)
  
}


###### NCD_hypertension

# NCD_HYP_PREVALENCE_A Prevalence of hypertension among adults aged 30-79 years, age-standardized

fname <- here("data/processed/who-ncd-hypertension.rds")

if(!file.exists(fname)) {
  
  dta <- fromJSON("https://ghoapi.azureedge.net/api/NCD_HYP_PREVALENCE_A", 
                  flatten = TRUE)
  
  hypertension <- dta$value |>
    clean_names() |>
    remove_empty(which = "cols")
  
  write_rds(hypertension, fname)
  
} else {
  
  hypertension <- read_rds(fname)
  
}


###### NCD mortality

# WHS2_131 Age-standardized NCD mortality rate  (per 100 000 population)

fname <- here("data/processed/who-ncd-mortality.rds")

if(!file.exists(fname)) {
  
  dta <- fromJSON("https://ghoapi.azureedge.net/api/WHS2_131", 
                  flatten = TRUE)
  
  ncd_mortality <- dta$value |>
    clean_names() |>
    remove_empty(which = "cols")
  
  write_rds(ncd_mortality, fname)
  
} else {
  
  ncd_mortality <- read_rds(fname)
  
}


###### Cardiovascular

# WHS2_161 Age-standardized mortality rate by cause (per 100 000 population) - Cardiovascular
# TODO: Why is no data returned for this indicator?

# fname <- here("data/processed/who-ncd-cardiovascular.rds")
# 
# if(!file.exists(fname)) {
#   
#   dta <- fromJSON("https://ghoapi.azureedge.net/api/WHS2_161", 
#                   flatten = TRUE)
#   
#   cardiovascular <- dta$value |>
#     clean_names() |>
#     remove_empty(which = "cols")
#   
#   write_rds(cardiovascular, fname)
#   
# } else {
#   
#   cardiovascular <- read_rds(fname)
#   
# }



###### Cancer

# WHS2_160 Age-standardized mortality rate by cause (per 100 000 population) - Cancer
# TODO: Why is no data returned for this indicator?

# fname <- here("data/processed/who-cancer.rds")
# 
# if(!file.exists(fname)) {
#   
#   dta <- fromJSON("https://ghoapi.azureedge.net/api/WHS2_160", 
#                   flatten = TRUE)
#   
#   hypertension <- dta$value |>
#     clean_names() |>
#     remove_empty(which = "cols")
#   
#   write_rds(hypertension, fname)
#   
# } else {
#   
#   hypertension <- read_rds(fname)
#   
# }
