#' Prepare a tibble with cases and deaths for health regions
#'
#' @param cases_deaths A tibble from read_cases_deaths
#' @param uf_code UF code. Defaults to 22.
#' @param with_rate Logical. Calculate per capita rate.
#' @param constant Numerical. Constant for rate.
#' @param digits Numerical. Digits for rates.
#' @return A tibble.
#' @importFrom rlang .data
prepare_cases_deaths_health_regions <- function(cases_deaths, uf_code = 22, with_rate = TRUE, constant = 100000, digits = 2){

  # Health regions from a UF
  subset_health_regions <- dadosPainelPI::health_regions %>%
    dplyr::filter(substr(.data$cod_mun, start = 0, stop = 2) == uf_code)

  res <- cases_deaths %>%
    # Inner join from health regions and municipalities
    dplyr::inner_join(y = subset_health_regions, by = c("codmun" = "cod_mun")) %>%
    # Select and rename variables
    dplyr::select(
      date = .data$data, cod_rs = .data$cod_rs_450,
      new_cases = .data$casosNovos, acum_cases = .data$casosAcumulado,
      new_deaths = .data$obitosNovos, acum_deaths = .data$obitosAcumulado
    ) %>%
    # Group municipalities by date and health region and sum
    dplyr::group_by(.data$date, .data$cod_rs) %>%
    dplyr::summarise(
      new_cases = sum(.data$new_cases, na.rm = TRUE),
      new_deaths = sum(.data$new_deaths, na.rm = TRUE),
      acum_cases = sum(.data$acum_cases, na.rm = TRUE),
      acum_deaths = sum(.data$acum_deaths, na.rm = TRUE),
    ) %>%
    dplyr::ungroup()

  # Calculate rates
  if(with_rate == TRUE){
    res <- res %>%
      dplyr::left_join(y = dadosPainelPI::population_health_region, by = c("cod_rs" = "cod_rs_450")) %>%
      dplyr::mutate(
        acum_cases_rate = round((.data$acum_cases / .data$pop2021)*constant, digits),
        acum_deaths_rate = round((.data$acum_deaths / .data$pop2021)*constant, digits)
      ) %>%
      dplyr::select(-.data$pop2021)
  }

  return(res)

}
