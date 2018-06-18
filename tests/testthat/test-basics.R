context("basics")

test_that("extract no errors", {
  a <- extract_style('.')
})

test_that("apply no errors", {
  a <- extract_style('.')

  b <- check_with_style('.', a)
})
