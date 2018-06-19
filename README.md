# adaptalint
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/adaptalint)](https://cran.r-project.org/package=adaptalint)

Adaptalint is a package to infer the code style from one package and use it to check another.
This makes linting much less painful, since you don't need to do as much configuration, and makes it easy to compare your code quality to real examples.

## Installation

You can install adaptalint from github with:


``` r
# install.packages("devtools")
devtools::install_github("maxconway/adaptalint")
```

## Example

``` r
# Downloading the source of this package
path <- workdir(clone("https://github.com/maxconway/adaptalint", tempfile()))

# And extracting the style
style_adaptalint <- extract_style(path)

# There are also some included pre-computed styles from popular packages
data("style_purrr")

# Check against this package against another to see how it measures up
a <- check_with_style(package = path, style = style_purrr)

# Or check it against itself, highlighting only those lint errors that the package judges as important
a <- check_with_style(package = path, style = style_adaptalint)
```
