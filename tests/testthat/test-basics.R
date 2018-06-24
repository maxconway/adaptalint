context("basics")

adaptalint_path <- '.'
filepath <- system.file('extdata', 'styles.R', package='adaptalint')

test_that("exports are correct", {
  expect_equal(find('extract_style'), 'package:adaptalint')
  expect_equal(find('lint_with_style'), 'package:adaptalint')
  expect_equal(find('extract_package_style'), 'package:adaptalint')
  expect_equal(find('lint_package_with_style'), 'package:adaptalint')
})

test_that("extract from package works in simple case", {
  a <- extract_package_style(adaptalint_path)
  expect_is(a, 'data.frame')
})

test_that("apply to package works in simple case", {
  data("style_dplyr")

  a <- lintr::lint_package(adaptalint_path)
  b <- lint_package_with_style(adaptalint_path, style_dplyr)
  expect_is(a, 'lints')
  expect_is(b, 'lints')
  expect_lte(length(b), length(a))
})

test_that('extract works in simple case', {
  a <- extract_style(filepath)
  expect_is(a, 'data.frame')
})

test_that("apply works in simple case", {
  data("style_dplyr")

  a <- lintr::lint(filepath)
  b <- lint_with_style(filepath, style_dplyr)
  expect_is(a, 'lints')
  expect_is(b, 'lints')
  expect_lte(length(b), length(a))
})
