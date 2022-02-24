## code to prepare `health_regions` dataset goes here

health_regions <- readr::read_csv2(file = "data-raw/micro_macro.csv") %>%
  dplyr::select(cod_mun, cod_rs_450)

usethis::use_data(health_regions, overwrite = TRUE)
