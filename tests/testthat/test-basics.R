context("basics")

test_that("exports are correct", {
  expect_equal(find('extract_style'), 'package:adaptalint')
  expect_equal(find('check_with_style'), 'package:adaptalint')
})

test_that("extract works in simple case", {
  a <- extract_style('.')
  expect_is(a, 'lints')
})

test_that("apply works in simple case", {
  data("style_dplyr")

  a <- lintr::lint_package('.')
  b <- lint_with_style('.', style_dplyr)
  expect_is(a, 'lints')
  expect_is(b, 'lints')
  expect_lte(b, a)
})
