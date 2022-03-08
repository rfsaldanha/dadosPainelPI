test_that("fetch hospita admissions data works", {

  res <- fetch_hospital_admissions_data(year_start = 2021, year_end = 2021, month_start = 1, month_end = 1)

  expect_true(nrow(res) > 0)
})
