test_that("prepare cases and deaths file for municipalities", {
  res <- cases_deaths_example %>%
    prepare_cases_deaths_municipalities()

  expect_true(nrow(res) > 0)
})
