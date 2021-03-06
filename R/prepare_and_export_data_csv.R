#' Prepare and export data to CSV files
#
#' @param cases_deaths_folder Folder with cases and deaths files.
#' @param dest_folder Destination folder for CSV files.
#' @param year_start Start year. Numeric. For SIH data.
#' @param year_end End year. Numeric. For SIH data.
#' @param month_start Start month. Numeric. For SIH data.
#' @param month_end End month. Numeric. For SIH data.
#' @return A tibble.
#' @importFrom rlang .data
prepare_and_export_data_csv <- function(cases_deaths_folder = "data-raw/cases_deaths_example/", sipni_folder, dest_folder, year_start = 2021, year_end = 2021, month_start = 1, month_end = 1){
  # Cases and deaths
  message("Cases and deaths...")

  time_date_stamp <- format(Sys.time(), "%Y%m%d_%H%M%S")

  db_cases_deaths <- read_cases_deaths(cases_deaths_folder)

  db_cases_deaths %>%
    prepare_cases_deaths_uf() %>%
    readr::write_csv2(file = paste0(dest_folder, "/cases_deaths_uf_", time_date_stamp, ".csv"), na = "")

  db_cases_deaths %>%
    prepare_cases_deaths_health_regions() %>%
    readr::write_csv2(file = paste0(dest_folder, "/cases_deaths_health_regions_", time_date_stamp, ".csv"), na = "")

  db_cases_deaths %>%
    prepare_cases_deaths_municipalities() %>%
    readr::write_csv2(file = paste0(dest_folder, "/cases_deaths_municipalities_", time_date_stamp, ".csv"), na = "")

  # Hospital admissions
  message("Hospital admissions...")

  tmp <- fetch_hospital_admissions_data(year_start = year_start, year_end = year_end, month_start = month_start, month_end = month_end)

  prepare_hospital_admissions_uf(hospital_admissions_data = tmp) %>%
    readr::write_csv2(file = paste0(dest_folder, "/hospital_admissions_uf_", time_date_stamp, ".csv"), na = "")

  prepare_hospital_admissions_municipalities(hospital_admissions_data = tmp) %>%
    readr::write_csv2(file = paste0(dest_folder, "/hospital_admissions_municipalities_", time_date_stamp, ".csv"), na = "")

  prepare_hospital_admissions_health_regions(hospital_admissions_data = tmp) %>%
    readr::write_csv2(file = paste0(dest_folder, "/hospital_admissions_health_regions_", time_date_stamp, ".csv"), na = "")

  # Municipalities context data
  message("Hospital admissions...")

  dadosPainelPI::context_var_mun %>%
    readr::write_csv2(file = paste0(dest_folder, "/context_var_mun_", time_date_stamp, ".csv"), na = "")

  # Vaccination data
  message("Vaccination data...")

  tmp <- read_sipni(files_folder = sipni_folder)

  prepare_vaccination_uf(lazy_sipni = tmp) %>%
    readr::write_csv2(file = paste0(dest_folder, "/vaccination_uf_", time_date_stamp, ".csv"), na = "")

  prepare_vaccination_health_regions(lazy_sipni = tmp) %>%
    readr::write_csv2(file = paste0(dest_folder, "/vaccination_health_regions_", time_date_stamp, ".csv"), na = "")

  prepare_vaccination_municipalities(lazy_sipni = tmp) %>%
    readr::write_csv2(file = paste0(dest_folder, "/vaccination_municipalities_", time_date_stamp, ".csv"), na = "")


  message("Done!")
}
