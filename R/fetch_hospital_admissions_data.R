#' Fetch hospital admissions data from SIH
#
#' @param uf_acronym UF acronym. Defaults to PI.
#' @param year_start Start year. Numeric.
#' @param year_end End year. Numeric.
#' @param month_start Start month. Numeric.
#' @param month_end End month. Numeric.
#' @return A tibble.
#' @importFrom rlang .data
fetch_hospital_admissions_data <- function(uf_acronym = "PI", year_start = 2020, year_end = 2021, month_start = 1, month_end = 12){
  microdatasus::fetch_datasus(
    uf = uf_acronym,
    year_start = year_start, year_end = year_end,
    month_start = month_start, month_end = month_end,
    information_system = "SIH-RD"
  )
}
