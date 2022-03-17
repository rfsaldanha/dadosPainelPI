#' Prepare a tibble with vaccination counts for health regions within a UF.
#
#' @param lazy_sipni Lazi table from `read_sipni` function.
#' @param uf_acronym UF acronym. Defaults to PI.
#' @param uf_code UF code Defaults to 22.
#' @return A tibble.
#' @importFrom rlang .data

prepare_vaccination_health_regions <- function(lazy_sipni, uf_acronym = "PI", uf_code = 22){
  # Health regions from a UF
  subset_health_regions <- dadosPainelPI::health_regions %>%
    dplyr::filter(substr(.data$cod_mun, start = 0, stop = 2) == uf_code)

  lazy_sipni %>%
    dplyr::filter(.data$paciente_endereco_uf == uf_acronym) %>%
    dplyr::mutate(vacina_descricao_dose = dplyr::case_when(
      .data$vacina_descricao_dose == "1\u00aa Dose" ~ "dose_1",
      .data$vacina_descricao_dose == "1\u00aa Dose Revacina\u00e7\u00e3o" ~ "dose_1",
      .data$vacina_descricao_dose == "2\u00aa Dose" ~ "dose_2",
      .data$vacina_descricao_dose == "2\u00aa Dose Revacina\u00e7\u00e3o" ~ "dose_2",
      .data$vacina_descricao_dose == "3\u00aa Dose" ~ "dose_3",
      .data$vacina_descricao_dose == "Dose Adicional" ~ "dose_3",
      .data$vacina_descricao_dose == "Refor\u00e7o" ~ "dose_3"
    )) %>%
    dplyr::rename(cod_mun = .data$paciente_endereco_coIbgeMunicipio) %>%
    dplyr::inner_join(y = subset_health_regions, by = "cod_mun", copy = TRUE) %>%
    dplyr::group_by(date = .data$vacina_dataAplicacao, cod_rs = .data$cod_rs_450, .data$vacina_descricao_dose) %>%
    dplyr::summarise(freq = dplyr::n()) %>%
    dplyr::ungroup() %>%
    dplyr::collect() %>%
    dplyr::mutate(freq = as.numeric(.data$freq)) %>%
    tidyr::pivot_wider(id_cols = c(.data$date, .data$cod_rs), names_from = .data$vacina_descricao_dose, values_from = .data$freq, values_fill = 0) %>%
    dplyr::select(.data$date, .data$cod_rs, .data$dose_1, .data$dose_2, .data$dose_3, -.data$`NA`)
}
