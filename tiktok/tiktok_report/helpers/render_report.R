# report functions
tt_report <- function(handle){
  pacman::p_load(tidyverse, janitor, here, glue)
  
  logo <- here('tiktok_report', 'gsp_logo_lumen.png')
  date <- Sys.Date()
  
  data <- glue::glue(here::here('tiktok_report', "tiktok_data", "tt_{handle}.rds"))
  rmarkdown::render(input = here('tiktok_report', 'docs', 'tiktok_report.Rmd'),
                    output_file = glue::glue(here::here('tiktok_report', 'reports', "tiktok-{handle}-{date}")),
                    params = list(logo = logo,
                                  data = data)
  )
}
