test_that("prepare cases and deaths file for uf", {
  res <- cases_deaths_example %>%
    prepare_cases_deaths_uf()

  expect_true(nrow(res) > 0)
})
