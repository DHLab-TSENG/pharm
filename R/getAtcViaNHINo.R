#' @rdname getAtcViaNHINo
#' @export

getAtcViaNHINo <- function(df, NHINoColName = NHINo){

  colnames(df)[colnames(df)==deparse(substitute(NHINoColName))] <- "NHINo"

  ATCData <- df %>%
    left_join(resATC,by = c("NHINo" = "nhino"))

  colnames(ATCData)[colnames(ATCData)== "NHINo"] <- deparse(substitute(NHINoColName))
  return(ATCData)
}
