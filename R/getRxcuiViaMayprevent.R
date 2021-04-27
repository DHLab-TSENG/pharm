#' Get RxCui based on may prevent
#'
#' @import dplyr
#' @param strmaytreat A may prevent
#' Details
#' This function provides user to get medicine ingredient RxCui via specific indication Mayprevent.
#' @examples
#' # sample of searching an indication - esophagitis.
#' Esophagitis_List <- getRxcuiViaMayprevent("esophagitis")
#' # sample of getting RxCui list of esophagitis.
#' head(Esophagitis_List)
#' @export
#@import data.table

getRxcuiViaMayprevent <- function(strmayprevent){

  strmayprevent <-  tolower(gsub(" ","",strmayprevent))

  resMayprevent[,t := grepl(strmayprevent, mayprevent)]
  resMayprevent <- resMayprevent %>%
    filter(t == TRUE) %>%
    select(RxCui, min.rxcui, Name, May_prevent) %>%
    arrange(May_prevent)
  resMayprevent

}
.datatable.aware = TRUE
