## code to prepare `cases_deaths_example` dataset goes here

cases_deaths_example <- read_cases_deaths(files_folder = "/Users/raphaelsaldanha/Downloads/HIST_PAINEL_COVIDBR_23fev2022/") %>%
  dplyr::filter(regiao != "Brasil") %>%
  head(100000)

usethis::use_data(cases_deaths_example, overwrite = TRUE)
