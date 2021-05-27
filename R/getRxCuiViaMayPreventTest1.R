#' @rdname getRxCuiViaMayPrevent
#' @export

getRxCuiViaMayPrevent <- function(strmayprevent){

  strmayprevent <-  tolower(gsub(" ","",strmayprevent))
  resMayprevent[,t := grepl(strmayprevent, mayprevent)]
  resMayprevent <- resMayprevent %>%
    filter(t == TRUE) %>%
    select(RxCui, min.rxcui, Name, May_prevent) %>%
    arrange(May_prevent)
  resMayprevent

}
.datatable.aware = TRUE
