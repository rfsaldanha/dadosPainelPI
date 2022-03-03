test_that("prepare hospital admissions counts for uf works", {
  res <- prepare_hospital_admissions_uf(uf_acronym = "PI", year_start = 2021, year_end = 2021, month_start = 12, month_end = 12)

  expect_true(nrow(res) > 0)
})
