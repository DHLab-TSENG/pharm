#' Get RxCui based on may treat
#'
#' @import dplyr
#' @param strmaytreat A may treat
#' @details
#' This function provides user to get medicine ingredient RxCui via specific indication Maytreat
#' @examples
#' # sample of searching an indication - esophagitis.
#' Esophagitis_List <- getRxcuiViaMaytreat("esophagitis")
#' # sample of getting RxCui list of esophagitis.
#' head(Esophagitis_List)
#' @export
#@import data.table

getRxcuiViaMaytreat <- function(strmaytreat){

  strmaytreat <- tolower(gsub(" ","",strmaytreat))

  resMaytreat[,t := grepl(strmaytreat, maytreat)]
  resMaytreat <- resMaytreat %>%
    filter(t == TRUE) %>%
    select(RxCui, Name, rxclassMinConceptItem.classId, rxclassMinConceptItem.className) %>%
    arrange(rxclassMinConceptItem.className) %>% unique()
  colnames(resMaytreat)[3:4] <- c("MinConcept.Id", "MinConcept.Name")
  resMaytreat

}
