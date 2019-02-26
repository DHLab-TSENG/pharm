#' Get RxCui based on NDC
#'
#' @import doParallel
#' @import dplyr
#' @param df data.frame include NDC
#' @param NdcColName A colum for NDC of df
#' @param cores number of parallel operation
#' @export

get.RxCuiViaNdc <- function(df, NdcColName = NDC, cores=8){

  colnames(df)[colnames(df)==deparse(substitute(NdcColName))] <- "NDC"
  dfu <- df %>% select("NDC") %>% unique()

  cl <- makeCluster(cores)
  registerDoParallel(cl)
  RxNormIdData = foreach(i = 1:nrow(dfu),
                         .combine = "rbind",
                         .packages = "httr") %dopar% {

                           JSON <- GET(paste0("https://rxnav.nlm.nih.gov/REST/ndcstatus?ndc=", dfu$NDC[i]), timeout(60))
                           if(http_error(JSON)){
                             rxTable <- data.frame(NDC = dfu$NDC[i],
                                                   RxCui = "error",
                                                   ndcStatus = "error",
                                                   stringsAsFactors = FALSE)
                           }else{
                           rxid <- content(JSON)
                           if(is.null(rxid$ndcStatus$rxcui)){
                             rxTable <- data.frame(NDC = dfu$NDC[i],
                                                   RxCui = NA,
                                                   ndcStatus = NA,
                                                   stringsAsFactors = FALSE)
                           }else{
                             rxTable <- data.frame(NDC = dfu$NDC[i],
                                                   RxCui = rxid$ndcStatus$rxcui,
                                                   ndcStatus = rxid$ndcStatus$status,
                                                   stringsAsFactors = FALSE)
                           }
                           rxTable
                         }

                         }
  stopCluster(cl)
  RxNormIdData <- unique(RxNormIdData)
  NDC_RXNORM <- left_join(df,RxNormIdData, by = "NDC")
  colnames(NDC_RXNORM)[colnames(NDC_RXNORM)=="NDC"] <- deparse(substitute(NdcColName))

  return (NDC_RXNORM)
}
