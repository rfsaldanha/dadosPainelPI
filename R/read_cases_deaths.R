#' Read cases and deaths files from Brazilian Health Ministry
#'
#' @param files_folder Path to folder containing CSV files from Braziliann Health Ministry
#' @return A tibble.

read_cases_deaths <- function(files_folder){

  files_list = list.files(path = files_folder, full.names = TRUE, pattern = "*.csv")

  res <- tibble::tibble()
  for(i in files_list){
    tmp <- readr::read_csv2(file = i)
    res <- dplyr::bind_rows(res, tmp)
  }

  return(res)
}
