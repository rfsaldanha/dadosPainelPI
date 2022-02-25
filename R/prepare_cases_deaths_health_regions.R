#' Prepare a tibble with cases and deaths for health regions
#'
#' @param cases_deaths A tibble from read_cases_deaths
#' @param uf_code UF code. Defaults to 22.
#' @return A tibble.
#' @importFrom rlang .data
prepare_cases_deaths_health_regions <- function(cases_deaths, uf_code = 22){

  # Health regions from a UF
  subset_health_regions <- dadosPainelPI::health_regions %>%
    dplyr::filter(substr(.data$cod_mun, start = 0, stop = 2) == uf_code)

  cases_deaths %>%
    # Inner join from health regions and municipalities
    dplyr::inner_join(y = subset_health_regions, by = c("codmun" = "cod_mun")) %>%
    # Select and rename variables
    dplyr::select(
      date = .data$data, cod_rs = .data$cod_rs_450,
      new_cases = .data$casosNovos, acum_cases = .data$casosAcumulado,
      new_deaths = .data$obitosNovos, acum_deaths = .data$obitosAcumulado
    )

}
