#' Get NDC code based on RxCui
#' @importFrom parallel::makeCluster()
#' @importFrom parallel::stopCluster()
#' @import foreach
#' @import dplyr
#' @import doParallel
#' @param df data.frame include RxCui
#' @param RxCuiColName A colum for RxCui of df
#' @param cores number of parallel operation
#' @export

get.NdcViaSBDrxcui <- function(df, SBDRxCuiColName = SBD.rxcui, cores = 8){

  colnames(df)[colnames(df)==deparse(substitute(SBDRxCuiColName))] <- "SBD.rxcui"
  dfu <- df %>% select("SBD.rxcui") %>% unique()
  cl <- makeCluster(cores)
  registerDoParallel(cl)
  NdcData = foreach(i = 1:nrow(dfu),
                         .combine = "rbind",
                         .packages = "jsonlite") %dopar% {
                           ndc <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/", dfu$SBD.rxcui[i], "/ndcs.json"))
                           if(is.null(ndc$ndcGroup$ndcList)){
                             RxNdcTable <- data.frame(SBD.rxcui=dfu$SBD.rxcui[i],
                                                   NDC=NA,
                                                   stringsAsFactors = FALSE)
                           }else{
                             RxNdcTable <- data.frame(SBD.rxcui=dfu$SBD.rxcui[i],
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


