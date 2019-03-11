#' Get RxCui based on ATC
#' @importFrom parallel::makeCluster()
#' @importFrom parallel::stopCluster()
#' @import foreach
#' @import doParallel
#' @import dplyr
#' @param df data.frame include ATC
#' @param AtcColName A colum for ATC of df
#' @param Differ_ColName if colum for NHINo of df not named "ATC"
#' @param cores number of parallel operation
#' @export

get.RxCuiViaAtc <- function(df, AtcColName = ATC, cores=8){

  colnames(df)[colnames(df)==deparse(substitute(AtcColName))] <- "ATC"
  dfu <- df %>% select("ATC") %>% unique()

  cl <- makeCluster(cores)
  registerDoParallel(cl)
  RxNormIdData = foreach(i = 1:nrow(dfu),
                         .combine = "rbind",
                         .packages = "jsonlite") %dopar% {
                           rxid <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui.json?idtype=ATC&id=",dfu$ATC[i]))
                           if(is.null(rxid$idGroup$rxnormId)){
                             rxTable <- data.frame(ATC = dfu$ATC[i],
                                                   RxCui = NA,
                                                   stringsAsFactors = FALSE)
                           }else{
                             rxTable <- data.frame(ATC = dfu$ATC[i],
                                                   RxCui = rxid$idGroup$rxnormId,
                                                   stringsAsFactors = FALSE)
                           }
                           rxTable
                         }
  stopCluster(cl)
  RxNormIdData <- unique(RxNormIdData)
  ATC_RXCUI <- left_join(df,RxNormIdData, by = "ATC")
  colnames(ATC_RXCUI)[colnames(ATC_RXCUI)== "ATC"] <- deparse(substitute(AtcColName))

  return (ATC_RXCUI)
}
