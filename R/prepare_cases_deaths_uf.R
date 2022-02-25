#' Prepare a tibble with cases and deaths for the UF
#'
#' @param cases_deaths A tibble from read_cases_deaths
#' @param uf_code UF code. Defaults to 22.
#' @param with_rate Logical. Calculate per capita rate.
#' @param constant Numerical. Constant for rate.
#' @param digits Numerical. Digits for rates.
#' @return A tibble.
#' @importFrom rlang .data
prepare_cases_deaths_uf <- function(cases_deaths, uf_code = 22, with_rate = TRUE, constant = 100000, digits = 2){
  res <- cases_deaths %>%
    # Filter lines for a specific UF code
    dplyr::filter(.data$coduf == uf_code) %>%
    # Select and rename variables
    dplyr::select(
      date = .data$data, cod_mun = .data$codmun,
      new_cases = .data$casosNovos, acum_cases = .data$casosAcumulado,
      new_deaths = .data$obitosNovos, acum_deaths = .data$obitosAcumulado
    ) %>%
    # Filter lines for UF level
    dplyr::filter(is.na(.data$cod_mun)) %>%
    # Remove cod_mun variable
    dplyr::select(-.data$cod_mun)

  # Calculate rates
  if(with_rate == TRUE){
    # Isolate population constant for UF
    pop <- dadosPainelPI::population_uf[which(dadosPainelPI::population_uf$uf_code == uf_code),]$pop2021

    # Calculate rate
    res <- res %>%
      dplyr::mutate(
        acum_cases_rate = round((.data$acum_cases / pop)*100, digits),
        acum_deaths_rate = round((.data$acum_deaths / pop)*100, digits),
      )
  }

  return(res)

}
