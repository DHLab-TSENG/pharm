#' Get ATC Code based on NHINO
#'
#' @import dplyr
#' @param df data.frame include NHINO
#' @param NHINoColName A colum for NHINo of df
#' @param Differ_ColName if colum for NHINo of df not named "NHINo"
#' @export
#' @example
#' NHINoToAtc(NHINoList)
#'

get.AtcViaNHINo <- function(df, NHINoColName = NHINo){

  colnames(df)[colnames(df)==deparse(substitute(NHINoColName))] <- "NHINo"

  ATCData <- df %>%
    left_join(resATC,by = c("NHINo" = "藥品代號"))

  colnames(ATCData)[colnames(ATCData)== "NHINo"] <- deparse(substitute(NHINoColName))
  return(ATCData)
}
