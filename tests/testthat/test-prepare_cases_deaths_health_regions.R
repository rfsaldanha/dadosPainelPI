test_that("prepare cases and deaths file for health regions", {
  res <- cases_deaths_example %>%
    prepare_cases_deaths_health_regions()

  expect_true(nrow(res) > 0)
})
