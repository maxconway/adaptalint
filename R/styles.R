#' Find style of a package
#'
#' Returns the absolute and relative counts of all lint errors found in the
#' package.
#' The resulting style data can be applied to another file with
#' \code{\link{lint_with_style}}.
#'
#' @param package path to the package of interest
#'
#' @return a data_frame with columns \code{lint}, \code{count}, \code{total_lints} and \code{adjusted}
#'
#' @import lintr
#' @import dplyr
#'
#' @export
extract_package_style <- function(package){
  package %>%
    lint_package() %>%
    as_tibble() %>%
    mutate(total_lints = n()) %>%
    group_by(.data$linter) %>%
    summarise(count = n(),
              total_lints = mean(.data$total_lints)
              ) %>%
    mutate(adjusted = .data$count/.data$total_lints)
}

#' Find style of a file
#'
#' Returns the absolute and relative counts of all lint errors found in the
#' file.
#' The resulting style data can be applied to another file with
#' \code{\link{lint_with_style}} or \code{\link{lint_package_with_style}}.
#'
#' @param filename path to the file of interest
#'
#' @return a data_frame with columns \code{lint}, \code{count}, \code{total_lints} and \code{adjusted}
#'
#' @import lintr
#' @import dplyr
#'
#' @export
#' @examples
#'
#' # Get the path to a file to check
#' path <- system.file("extdata", 'styles.R', package='adaptalint')
#'
#' # Find out the provile of lints in this package
#' style <- extract_style(filename = path)
extract_style <- function(filename){
  filename %>%
    lint() %>%
    as_tibble() %>%
    mutate(total_lints = n()) %>%
    group_by(.data$linter) %>%
    summarise(count = n(),
              total_lints = mean(.data$total_lints)
    ) %>%
    mutate(adjusted = .data$count/.data$total_lints)
}

#' Lint a package, using a known style
#'
#' Apply a style extracted using \code{\link{extract_style}}, in order to
#' check for only the style issues that aren't excepted in that package.
#'
#' @param package path to the package to check
#' @param style a style data frame, as created by \code{\link{extract_style}}
#' @param threshold the proportional occurrence threshold above which a lint is ignored
#'
#' @import purrr
#' @import lintr
#'
#' @export
lint_package_with_style <- function(package, style, threshold = 0.01){
  to_ignore <- style %>%
    filter(.data$adjusted > threshold) %>%
    `$`('linter')

  baselinters <- get('settings', envir = asNamespace('lintr'),
                     inherits = FALSE)$linters
  to_use <- baselinters[setdiff(names(baselinters), to_ignore)]

  lint_package(package, linters = to_use)
}

#' Lint a file, using a known style
#'
#' Apply a style extracted using \code{\link{extract_style}}: lint a file,
#' checking only for errors that appear to be prohibited in that style.
#'
#' @param filename path to the file to check
#' @param style a style data frame, as created by \code{\link{extract_style}}
#' @param threshold the proportional occurrence threshold above which a lint is ignored
#'
#' @import purrr
#' @import lintr
#'
#' @export
#'
#' @examples
#' # Get a copy of the profile of lints from the purrr package
#' data("style_purrr")
#'
#' # Get the path to a file to check
#' path <- system.file("extdata", 'styles.R', package='adaptalint')
#'
#' # Check this file against the lint profile of purrr
#' lint_with_style(filename = path, style = style_purrr)
lint_with_style <- function(filename, style, threshold = 0.01){
  to_ignore <- style %>%
    filter(.data$adjusted > threshold) %>%
    `$`('linter')

  baselinters <- get('settings', envir = asNamespace('lintr'),
                     inherits = FALSE)$linters
  to_use <- baselinters[setdiff(names(baselinters), to_ignore)]

  lint(filename, linters = to_use)
}
