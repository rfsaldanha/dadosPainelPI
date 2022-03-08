#' Prepare a tibble with hospital admissions count for a UF
#
#' @param hospital_admissions_data Data from `fetch_hospital_admissions_data` function.
#' @param uf_code UF code. Defaults to 22.
#' @return A tibble.
#' @importFrom rlang .data
prepare_hospital_admissions_uf <- function(hospital_admissions_data, uf_code = 22){

  # General hospital admissions
  res1 <- hospital_admissions_data %>%
    dplyr::filter(.data$DIAG_PRINC == "B342") %>%
    dplyr::mutate(uf_res = substr(x = .data$MUNIC_RES, start = 0, stop = 2)) %>%
    dplyr::filter(.data$IDENT != 5) %>%
    dplyr::filter(.data$uf_res == uf_code) %>%
    dplyr::mutate(DT_INTER = as.Date(.data$DT_INTER, "%Y%m%d")) %>%
    dplyr::group_by(date = .data$DT_INTER) %>%
    dplyr::summarise(hospital_admissions =  dplyr::n()) %>%
    dplyr::ungroup()

  # ICU hospitalizations
  res2 <- hospital_admissions_data %>%
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
