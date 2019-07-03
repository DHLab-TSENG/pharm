#' Get RxCui based on may prevent
#'
#' @import dplyr
#' @import stringr

#' @importFrom data.table::last()
#' @importFrom data.table::first()
#' @importFrom data.table::between()
#' @param strmaytreat A may prevent
#' @export
get.RxCuiViaMayprevent <- function(strmayprevent){

  strmayprevent <-  str_to_lower(gsub(" ","",strmayprevent))

  resMayprevent[,t := grepl(strmayprevent, mayprevent)]
  resMayprevent <- resMayprevent %>%
    filter(t == TRUE) %>%
    select(RxCui, min.rxcui, Name, May_prevent) %>%
    arrange(May_prevent)
  resMayprevent

}
.datatable.aware = TRUE
