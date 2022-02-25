## code to prepare `population_uf` dataset goes here

# CSV created observing https://www.gov.br/pt-br/noticias/financas-impostos-e-gestao-publica/2021/08/populacao-brasileira-chega-a-213-3-milhoes-de-habitantes-estima-ibge

population_uf <- readr::read_csv2(file = "data-raw/pop_uf_2021.csv")

usethis::use_data(population_uf, overwrite = TRUE)
