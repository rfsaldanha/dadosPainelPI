test_that("prepare hospital admissions counts for uf works", {
  tmp <- fetch_hospital_admissions_data(year_start = 2021, year_end = 2021, month_start = 1, month_end = 1)

  res <- prepare_hospital_admissions_uf(hospital_admissions_data = tmp)

  expect_true(nrow(res) > 0)
})
