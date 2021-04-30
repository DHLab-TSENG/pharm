#' @rdname getRxcuiViaMaytreat
#' @export

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
