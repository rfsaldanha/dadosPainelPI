#' Prepare a tibble with cases and deaths for municipalities
#'
#' @param cases_deaths A tibble from read_cases_deaths
#' @param uf_code UF code. Defaults to 22.
#' @return A tibble.
#' @importFrom rlang .data
prepare_cases_deaths_municipalities <- function(cases_deaths, uf_code = 22){
  cases_deaths %>%
    # Filter lines for a specific UF code
    dplyr::filter(.data$coduf == uf_code) %>%
    # Select and rename variables
    dplyr::select(
      date = .data$data, cod_mun = .data$codmun,
      new_cases = .data$casosNovos, acum_cases = .data$casosAcumulado,
      new_deaths = .data$obitosNovos, acum_deaths = .data$obitosAcumulado
    ) %>%
    # Filter out lines for UF level
    dplyr::filter(!is.na(.data$cod_mun))
}
