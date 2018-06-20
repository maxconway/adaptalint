context("basics")

test_that("exports are correct", {
  expect_equal(find('extract_style'), 'package:adaptalint')
  expect_equal(find('lint_with_style'), 'package:adaptalint')
})

test_that("extract works in simple case", {
  a <- extract_style(find.package('adaptalint'))
  expect_is(a, 'data.frame')
})

test_that("apply works in simple case", {
  data("style_dplyr")

  a <- lintr::lint_package(find.package('adaptalint'))
  b <- lint_with_style('.', style_dplyr)
  expect_is(a, 'lints')
  expect_is(b, 'lints')
  expect_lte(length(b), length(a))
})
