## code to prepare `population_health_region` dataset goes here

population_health_region <- dadosPainelPI::health_regions %>%
  dplyr::left_join(y = dadosPainelPI::population_mun, by = "cod_mun") %>%
  dplyr::group_by(cod_rs_450) %>%
  dplyr::summarise(pop2021 = sum(pop2021, na.rm = TRUE)) %>%
  dplyr::ungroup()

usethis::use_data(population_health_region, overwrite = TRUE)
