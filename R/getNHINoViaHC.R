#' @rdname getNHINoViaHC
#' @export

getNHINoViaHC <- function(df, HospitalCodeColName, SourceDf, Source_NhinoColName, Source_HospitalCodeColName){

  colnames(df)[colnames(df)==deparse(substitute(HospitalCodeColName))] <- "HC"
  colnames(SourceDf)[colnames(SourceDf)==deparse(substitute(Source_NhinoColName))] <- "NHINo"
  colnames(SourceDf)[colnames(SourceDf)==deparse(substitute(Source_HospitalCodeColName))] <- "HC"
  SourceDf <- SourceDf %>% select(NHINo, HC) %>% unique()
  NHINoData <- df %>%
    left_join(SourceDf,by = "HC")

  colnames(NHINoData)[colnames(NHINoData)== "HC"] <- deparse(substitute(HospitalCodeColName))

  return(NHINoData)
}
