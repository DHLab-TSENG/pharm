#' Get NHINO based on RCFNO
#'
#' @import dplyr
#' @param df data.frame include RCFNO
#' @param RCFNoColName A colum for RCFNo of df
#' @param Differ_ColName if colum for NHINo of df not named "RCFNO"
#' @export
#' @example
#' RCFNoToNHINo(rcfno, rcfcolname1)
#'

get.NHINoViaRCFNo <- function(df, RCFNoColName = RCFNO){

  colnames(df)[colnames(df)==deparse(substitute(RCFNoColName))] <- "RCFNO"
  NHINoData <- df %>%
    left_join(resCGDA,by = "RCFNO")

  colnames(NHINoData)[colnames(NHINoData)== "RCFNO"] <- deparse(substitute(RCFNoColName))

  return(NHINoData)

}
