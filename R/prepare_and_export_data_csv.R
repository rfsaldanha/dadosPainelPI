#' Prepare and export data to CSV files
#
#' @param files_folder Folder with cases and deaths files.
#' @param dest_folder Destination folder for CSV files.
#' @param year_start Start year. Numeric.
#' @param year_end End year. Numeric.
#' @param month_start Start month. Numeric.
#' @param month_end End month. Numeric.
#' @return A tibble.
#' @importFrom rlang .data
prepare_and_export_data_csv <- function(files_folder = "data-raw/cases_deaths_example/", dest_folder, year_start = 2021, year_end = 2021, month_start = 1, month_end = 1){
  # Cases and deaths
  message("Cases and deaths...")

  db_cases_deaths <- read_cases_deaths(files_folder)

  db_cases_deaths %>%
    prepare_cases_deaths_uf() %>%
    readr::write_csv2(file = paste0(dest_folder, "/cases_deaths_uf_", format(Sys.Date(), "%Y%m%d"), ".csv"), na = "")

  db_cases_deaths %>%
    prepare_cases_deaths_health_regions() %>%
    readr::write_csv2(file = paste0(dest_folder, "/cases_deaths_health_regions_", format(Sys.Date(), "%Y%m%d"), ".csv"), na = "")

  db_cases_deaths %>%
    prepare_cases_deaths_municipalities() %>%
    readr::write_csv2(file = paste0(dest_folder, "/cases_deaths_municipalities_", format(Sys.Date(), "%Y%m%d"), ".csv"), na = "")

  # Hospital admissions
  message("Hospital admissions...")

  prepare_hospital_admissions_uf(year_start = year_start, year_end = year_end, month_start = month_start, month_end = month_end) %>%
    readr::write_csv2(file = paste0(dest_folder, "/hospital_admissions_uf_", format(Sys.Date(), "%Y%m%d"), ".csv"), na = "")

  message("Done!")

  return(TRUE)
}
