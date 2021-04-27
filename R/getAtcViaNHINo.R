#' Get ATC Code based on NHINO
#'
#' @import dplyr
#' @param df data.frame include NHINO
#' @param NHINoColName A colum for NHINo of df
#' @details
#' This function provides user to get Anatomical Therapeutic Chemical Classification System(ATC) via Taiwan Health Insurance drug code(NHINo).
#' @examples
#' # sample of getting ATC via NHINo.
#' head(getAtcViaNHINo(df = sample_nhino_code,NHINoColName = NHINo))
#' @export

getAtcViaNHINo <- function(df, NHINoColName = NHINo){

  colnames(df)[colnames(df)==deparse(substitute(NHINoColName))] <- "NHINo"

  ATCData <- df %>%
    left_join(resATC,by = c("NHINo" = "nhino"))

  colnames(ATCData)[colnames(ATCData)== "NHINo"] <- deparse(substitute(NHINoColName))
  return(ATCData)
}
