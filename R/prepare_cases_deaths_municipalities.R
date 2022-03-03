#' Prepare a tibble with cases and deaths for municipalities
#'
#' @param cases_deaths A tibble from read_cases_deaths
#' @param uf_code UF code. Defaults to 22.
#' @param with_rate Logical. Calculate per capita rate.
#' @param constant Numerical. Constant for rate.
#' @param digits Numerical. Digits for rates.
#' @return A tibble.
#' @importFrom rlang .data
prepare_cases_deaths_municipalities <- function(cases_deaths, uf_code = 22, with_rate = TRUE, constant = 100000, digits = 2){
  res <- cases_deaths %>%
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

  # Calculate rates
  if(with_rate == TRUE){
    res <- res %>%
      dplyr::left_join(y = dadosPainelPI::population_mun, by = "cod_mun") %>%
      dplyr::mutate(
        acum_cases_rate = round((.data$acum_cases / .data$pop2021)*constant, digits),
        acum_deaths_rate = round((.data$acum_deaths / .data$pop2021)*constant, digits)
      ) %>%
      dplyr::select(-.data$pop2021)
  }

  return(res)
}
