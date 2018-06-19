#' Find style of a package
#'
#' Returns the absolute and relative counts of all lint errors found in the
#' package.
#' The resulting style data can be applied to another file with
#' \code{\link{check_with_style}}.
#'
#' @param package path to the package of interest
#'
#' @return a data_frame with columns \code{lint}, \code{count}, \code{total_lints} and \code{adjusted}
#'
#' @import lintr
#' @import dplyr
#'
#' @export
extract_style <- function(package){
  package %>%
    lint_package() %>%
    as_tibble() %>%
    mutate(total_lints = n()) %>%
    group_by(linter) %>%
    summarise(count = n(),
              total_lints = mean(total_lints)
              ) %>%
    mutate(adjusted = count/total_lints)
}

#' Lint a package, using the style of another package
#'
#' Apply a style extracted using \code{\link{extract_style}}, in order to
#' check for only the style issues that aren't excepted in that package.
#'
#' @import purrr
#' @import lintr
check_with_style <- function(package, style, threshold = 0.01){
  to_ignore <- style %>%
    filter(adjusted > threshold) %>%
    `$`('linter')

  baselinters <- lintr:::settings$linters
  to_use <- baselinters[setdiff(names(baselinters), to_ignore)]

  lint_package(package, linters = to_use)
}
