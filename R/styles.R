#' Extract lint error distribution from a package
#'
#' Returns the absolute and relative counts of all lint errors found in the package.
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

check_with_style <- function(package, style, threshold = 0.01){
  to_ignore <- style %>%
    filter(adjusted > threshold) %>%
    `$`('linter')

  baselinters <- lintr:::settings$linters
  to_use <- baselinters[setdiff(names(baselinters), to_ignore)]

  lint_package(package, linters = to_use)
}
