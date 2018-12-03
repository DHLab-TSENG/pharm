#' Get RxCui based on may treat
#'
#' @import dplyr
#' @import stringr
#' @import data.table
#' @param strmaytreat A may treat
#' @export

get.RxCuiViaMaytreat <- function(strmaytreat){

  strmaytreat <- str_to_lower(gsub(" ","",strmaytreat))

  resMaytreat[,t := grepl(strmaytreat, maytreat)]
  resMaytreat <- resMaytreat %>%
    filter(t == TRUE) %>%
    select(RxCui, Name, rxclassMinConceptItem.classId, rxclassMinConceptItem.className) %>%
    arrange(rxclassMinConceptItem.className)
  resMaytreat

}
