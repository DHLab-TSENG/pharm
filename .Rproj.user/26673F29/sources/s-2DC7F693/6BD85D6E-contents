#' Get NHINO based on RCFNO
#'
#' @import dplyr
#' @param df data.frame include specific drug code
#' @param HospitalCodeColName A colum for specific drug code
#' @param SourceDf data.frame include mapping between specific drug code and NHINo
#' @param Source_NhinoColName A colum for NHIno in SourceDf
#' @param Source_HospitalCodeColName A colum for specific drug code in SourceDf
#' @export
#'
get.NHINoViaHC <- function(df, HospitalCodeColName, SourceDf, Source_NhinoColName, Source_HospitalCodeColName){

  colnames(df)[colnames(df)==deparse(substitute(HospitalCodeColName))] <- "HC"
  colnames(SourceDf)[colnames(SourceDf)==deparse(substitute(Source_NhinoColName))] <- "NHINo"
  colnames(SourceDf)[colnames(SourceDf)==deparse(substitute(Source_HospitalCodeColName))] <- "HC"
  SourceDf <- SourceDf %>% select(NHINo, HC) %>% unique()
  NHINoData <- df %>%
    left_join(SourceDf,by = "HC")

  colnames(NHINoData)[colnames(NHINoData)== "HC"] <- deparse(substitute(HospitalCodeColName))

  return(NHINoData)
}
