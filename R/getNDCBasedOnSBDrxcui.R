#' Get NDC code based on RxCui
#'
#' @import dplyr
#' @import doParallel, jsonlite
#' @param df data.frame include RxCui
#' @param RxCuiColName A colum for RxCui of df
#' @param Differ_ColName if colum for RxCui of df not named "RxCui"
#' @export

get.NdcViaSBDrxcui <- function(df, SBDRxCuiColName = SBD.rxcui, cores = 8){

  colnames(df)[colnames(df)==deparse(substitute(SBDRxCuiColName))] <- "SBD.rxcui"
  cl <- makeCluster(cores)
  registerDoParallel(cl)
  NdcData = foreach(i = 1:nrow(df),
                         .combine = "rbind",
                         .packages = "jsonlite") %dopar% {
                           ndc <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/", df$SBD.rxcui[i], "/ndcs.json"))
                           if(is.null(ndc$ndcGroup$ndcList)){
                             RxNdcTable <- data.frame(SBD.rxcui=df$SBD.rxcui[i],
                                                   NDC=NA,
                                                   stringsAsFactors = FALSE)
                           }else{
                             RxNdcTable <- data.frame(SBD.rxcui=df$SBD.rxcui[i],
                                                   NDC = ndc$ndcGroup$ndcList,
                                                   stringsAsFactors = FALSE)
                           }
                           RxNdcTable
                         }
  stopCluster(cl)
  NdcData <- unique(NdcData)
  RxCui_NDC <- left_join(df,NdcData, by = "SBD.rxcui")
  colnames(RxCui_NDC)[colnames(RxCui_NDC)=="SBD.rxcui"] <- deparse(substitute(SBDRxCuiColName))

  return (RxCui_NDC)
}


