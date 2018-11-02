#' Get RxCui based on NDC
#'
#' @import doParallel
#' @import dplyr
#' @param df data.frame include NDC
#' @param AtcColName A colum for NDC of df
#' @param Differ_ColName if colum for NHINo of df not named "NDC"
#' @param cores number of parallel operation
#' @export

get.RxCuiViaNdc <- function(df, NdcColName = NDC, cores=8){

  colnames(df)[colnames(df)==deparse(substitute(NdcColName))] <- "NDC"

  cl <- makeCluster(cores)
  registerDoParallel(cl)
  RxNormIdData = foreach(i = 1:nrow(df),
                         .combine = "rbind",
                         .packages = "jsonlite") %dopar% {
                           rxid <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui.json?idtype=NDC&id=", df$NDC[i]))
                           if(is.null(rxid$idGroup$rxnormId)){
                             rxTable <- data.frame(NDC = df$NDC[i],
                                                   RxCui = NA,
                                                   stringsAsFactors = FALSE)
                           }else{
                             rxTable <- data.frame(NDC = df$NDC[i],
                                                   RxCui = rxid$idGroup$rxnormId,
                                                   stringsAsFactors = FALSE)
                           }
                           rxTable
                         }
  stopCluster(cl)
  RxNormIdData <- unique(RxNormIdData)
  NDC_RXNORM <- left_join(df,RxNormIdData, by = "NDC")
  colnames(NDC_RXNORM)[colnames(NDC_RXNORM)=="NDC"] <- deparse(substitute(NdcColName))

  return (NDC_RXNORM)
}
