#' Prepare a tibble with health admissions count for a UF
#
#' @param uf_code UF code. Defaults to 22.
#' @param uf_acronym UF acronym. Defaults to PI.
#' @param year_start Start year. Numeric.
#' @param year_end End year. Numeric.
#' @param month_start Start month. Numeric.
#' @param month_end End month. Numeric.
#' @return A tibble.
#' @importFrom rlang .data
prepare_hospital_admissions_uf <- function(uf_code = 22, uf_acronym = "PI", year_start = 2020, year_end = 2022, month_start = 1, month_end = 1){
  # Download DataSUS data
  datasus_data <- microdatasus::fetch_datasus(
    uf = uf_acronym,
    year_start = year_start, year_end = year_end,
    month_start = month_start, month_end = month_end,
    information_system = "SIH-RD"
  )

  # General hospital admissions
  res1 <- datasus_data %>%
    dplyr::filter(.data$DIAG_PRINC == "B342") %>%
    dplyr::mutate(uf_res = substr(x = .data$MUNIC_RES, start = 0, stop = 2)) %>%
    dplyr::filter(.data$IDENT != 5) %>%
    dplyr::filter(.data$uf_res == uf_code) %>%
    dplyr::mutate(DT_INTER = as.Date(.data$DT_INTER, "%Y%m%d")) %>%
    dplyr::group_by(date = .data$DT_INTER) %>%
    dplyr::summarise(hospital_admissions =  dplyr::n()) %>%
    dplyr::ungroup()

  # ICU hospitalizations
  res2 <- datasus_data %>%
    dplyr::filter(.data$DIAG_PRINC == "B342") %>%
    dplyr::mutate(uf_res = substr(x = .data$MUNIC_RES, start = 0, stop = 2)) %>%
    dplyr::filter(.data$IDENT != 5) %>%
    dplyr::filter(.data$uf_res == uf_code) %>%
    dplyr::filter(.data$MARCA_UTI != "00") %>%
    dplyr::mutate(DT_INTER = as.Date(.data$DT_INTER, "%Y%m%d")) %>%
    dplyr::group_by(date = .data$DT_INTER) %>%
    dplyr::summarise(hospital_admissions_icu =  dplyr::n()) %>%
    dplyr::ungroup()

  # Full join
  res <- dplyr::full_join(x = res1, y = res2, by = "date") %>%
    tidyr::replace_na(list(hospital_admissions = 0, hospital_admissions_icu = 0))

  return(res)
}
