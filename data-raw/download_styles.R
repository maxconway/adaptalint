# import external files from github repos

library(git2r)
library(adaptalint)

download_and_extract <- function(user, name){
  repo <- clone(paste("https://github.com",user,name, sep='/'), tempfile(pattern="temprepo-"))
  style <- extract_style(workdir(repo))
}

style_plyr <- download_and_extract('hadley','plyr')
style_dplyr <- download_and_extract('tidyverse','dplyr')
style_purrr <- download_and_extract('tidyverse','purrr')
style_tidyr <- download_and_extract('tidyverse','tidyr')
style_fbar <- download_and_extract('maxconway','fbar')
style_gsheet <- download_and_extract('maxconway','gsheet')
style_adaptalint <- download_and_extract('maxconway','adaptalint')

devtools::use_data(style_plyr,
                   style_dplyr,
                   style_purrr,
                   style_tidyr,
                   style_fbar,
                   style_gsheet,
                   style_adaptalint,
                   overwrite = TRUE)
