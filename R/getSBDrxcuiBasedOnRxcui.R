#' Get NDC code based on RxCui
#'
#' @import dplyr
#' @import doParallel, jsonlite
#' @param df data.frame include RxCui
#' @param RxCuiColName A colum for RxCui of df
#' @param Differ_ColName if colum for RxCui of df not named "RxCui"
#' @export

get.SBDrxcuiViaRxCui <- function(df, RxCuiColName = RxCui, cores = 8){

  colnames(df)[colnames(df)==deparse(substitute(RxCuiColName))] <- "RxCui"
  cl <- makeCluster(cores)
  registerDoParallel(cl)
  SbdData = foreach(i = 1:nrow(df),
                         .combine = "rbind",
                         .packages = "jsonlite") %dopar% {
                           sbd.rxcui <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/", df$RxCui[i], "/allrelated"))
                           sbd.df <- data.frame(sbd.rxcui$allRelatedGroup$conceptGroup$conceptProperties[sbd.rxcui$allRelatedGroup$conceptGroup$tty == "SBD"])
                           if(is.null(sbd.rxcui$allRelatedGroup$conceptGroup$conceptProperties[sbd.rxcui$allRelatedGroup$conceptGroup$tty == "SBD"])){
                             RxSbdTable <- data.frame(RxCui=df$RxCui[i],
                                                   SBD.rxcui=NA,
                                                   stringsAsFactors = FALSE)
                           }else{
                             RxSbdTable <- data.frame(RxCui=df$RxCui[i],
                                                      SBD.rxcui = sbd.df$rxcui,
                                                   stringsAsFactors = FALSE)
                           }
                           RxSbdTable
                         }
  stopCluster(cl)
  SbdData <- unique(SbdData)
  RxCui_SBD <- left_join(df,SbdData, by = "RxCui")
  colnames(RxCui_SBD)[colnames(RxCui_SBD)=="RxCui"] <- deparse(substitute(RxCuiColName))

  return (RxCui_SBD)
}


