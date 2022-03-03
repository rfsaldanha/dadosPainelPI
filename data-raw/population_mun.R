## code to prepare `population_mun` dataset goes here

# CSV created observing https://www.gov.br/pt-br/noticias/financas-impostos-e-gestao-publica/2021/08/populacao-brasileira-chega-a-213-3-milhoes-de-habitantes-estima-ibge

population_mun <- readr::read_csv2(file = "data-raw/population_mun.csv")

usethis::use_data(population_mun, overwrite = TRUE)
