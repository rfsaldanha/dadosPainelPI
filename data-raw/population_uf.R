## code to prepare `population_uf` dataset goes here

population_uf <- readr::read_csv2(file = "data-raw/pop_uf_2021.csv")

usethis::use_data(population_uf, overwrite = TRUE)
