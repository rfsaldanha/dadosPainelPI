#' Prepare a tibble with vaccination counts for a UF
#
#' @param lazy_sipni Lazi table from `read_sipni` function.
#' @param uf_acronym UF acronym. Defaults to PI
#' @return A tibble.
#' @importFrom rlang .data

prepare_vaccination <- function(lazy_sipni){
  lazy_sipni %>%
    dplyr::filter(.data$paciente_endereco_uf == "PI") %>%
    dplyr::mutate(vacina_descricao_dose = dplyr::case_when(
      .data$vacina_descricao_dose == "1ª Dose" ~ "dose_1",
      .data$vacina_descricao_dose == "1ª Dose Revacinação" ~ "dose_1",
      .data$vacina_descricao_dose == "2ª Dose" ~ "dose_2",
      .data$vacina_descricao_dose == "2ª Dose Revacinação" ~ "dose_2",
      .data$vacina_descricao_dose == "3ª Dose" ~ "dose_3",
      .data$vacina_descricao_dose == "Dose Adicional" ~ "dose_3",
      .data$vacina_descricao_dose == "Reforço" ~ "dose_3"
    )) %>%
    dplyr::group_by(date = .data$vacina_dataAplicacao, .data$vacina_descricao_dose) %>%
    dplyr::summarise(freq = dplyr::n()) %>%
    dplyr::ungroup() %>%
    dplyr::collect() %>%
    dplyr::mutate(freq = as.numeric(freq)) %>%
    tidyr::pivot_wider(id_cols = .data$date, names_from = .data$vacina_descricao_dose, values_from = .data$freq, values_fill = 0) %>%
    dplyr::select(date, dose_1, dose_2, dose_3, -`NA`)
}
