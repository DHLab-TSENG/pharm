get.RxCuiViaMaytreat <- function(strmaytreat){

  strmaytreat <- str_to_lower(gsub(" ","",strmaytreat))

  resMaytreat[,t := grepl(strmaytreat, maytreat)]
  resMaytreat <- resMaytreat %>%
    filter(t == TRUE) %>%
    select(RxCui, min.rxcui, Name, May_treat) %>%
    arrange(May_treat)
  resMaytreat

}
