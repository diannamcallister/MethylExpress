test_that("input of number for orig param throws error", {
  expect_error(FindMethylatedCytosines(1, "test"))
})

test_that("input of number for bisulfite param throws error", {
  expect_error(FindMethylatedCytosines("test", 1))
})

test_that("parameters have different lengths throws error", {
  expect_error(FindMethylatedCytosines("test", "testing"))
})
