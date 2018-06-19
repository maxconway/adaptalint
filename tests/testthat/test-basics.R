context("basics")

test_that("extract no errors", {
  a <- extract_style('.')
})

test_that("apply no errors", {
  a <- extract_style('.')

  b <- check_with_style('.', a)
})

test_that("no errors 2", {
  path <- workdir(clone("https://github.com/maxconway/adaptalint", tempfile()))

  style_adaptalint <- extract_style(path)

  data("style_purrr")

  a <- check_with_style(package = path, style = style_purrr)
  a <- check_with_style(package = path, style = style_adaptalint)
})
