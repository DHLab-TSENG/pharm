#' Get NHINO based on RCFNO
#'
#' @import dplyr
#' @param df data.frame include RCFNO
#' @param RCFNoColName A colum for RCFNo of df
#' @details
#' This function provides user to get Taiwan Health Insurance drug code(NHINo) via Taiwan hospital drug code(RCFNo).
#' @examples
#' # sample of getting NHINo via RCFNo of Chang Gung Medical Hospital.
#' head(getNHINoViaRCFNo(df = sample_taiwan_drug, RCFNoColName = CGMH_CODE))
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