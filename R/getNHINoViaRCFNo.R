#' @rdname getNHINoViaRCFNo
#' @export

getNHINoViaRCFNo <- function(df, RCFNoColName = RCFNO){

  colnames(df)[colnames(df)==deparse(substitute(RCFNoColName))] <- "RCFNO1"
  NHINoData <-  df %>% select(RCFNO1) %>% as.data.table()
  NHINoData[, RCFNo := substr(RCFNO1, 1, 7)]
  NHINoData  <-  left_join(NHINoData, resCGDAx,by = "RCFNo") %>%
    select(RCFNO1, NHINO1)

  colnames(NHINoData)[colnames(NHINoData)== "RCFNO1"] <- deparse(substitute(RCFNoColName))

  return(NHINoData)

}
