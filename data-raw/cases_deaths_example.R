## code to prepare `cases_deaths_example` dataset goes here

cases_deaths_example <- read_cases_deaths(files_folder = "data-raw/cases_deaths_example/") %>%
  dplyr::filter(regiao != "Brasil") %>%
  head(100000)

usethis::use_data(cases_deaths_example, overwrite = TRUE)
