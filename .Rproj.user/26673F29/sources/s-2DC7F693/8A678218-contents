#' Get ATC Code based on NHINO
#'
#' @import dplyr
#' @param df data.frame include NHINO
#' @param NHINoColName A colum for NHINo of df
#' @export

get.AtcViaNHINo <- function(df, NHINoColName = NHINo){

  colnames(df)[colnames(df)==deparse(substitute(NHINoColName))] <- "NHINo"

  ATCData <- df %>%
    left_join(resATC,by = c("NHINo" = "nhino"))

  colnames(ATCData)[colnames(ATCData)== "NHINo"] <- deparse(substitute(NHINoColName))
  return(ATCData)
}
