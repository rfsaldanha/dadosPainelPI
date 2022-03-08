test_that("prepare cases and deaths file for health regions", {
  res <- cases_deaths_example %>%
    prepare_cases_deaths_health_regions()

  expect_true(nrow(res) > 0)
})

test_that("check consistency", {
  res <- cases_deaths_example %>%
    prepare_cases_deaths_health_regions()

  res_dis <- res %>%
    dplyr::distinct(date, cod_rs)

  expect_true(nrow(res) == nrow(res_dis))
})
