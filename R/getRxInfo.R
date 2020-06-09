#' Get RxCui infomation
#'
#' @param df data.frame include RxCui
#' @param RxCuiColName A colum for RxCui of df
#' @param cores number of parallel operation
#' @export
get.rxinfo <- function(df, RxCuiColName = RxCui, cores = 8){

  colnames(df)[colnames(df)==deparse(substitute(RxCuiColName))] <- "wRxCui"
  dfu <- df %>% select("wRxCui") %>% unique()

  cl <- makeCluster(cores)
  registerDoParallel(cl)
  RxNormInFoData = foreach(i = 1:nrow(dfu),
                         .combine = "rbind",
                         .packages = "jsonlite") %dopar% {
                           rxinfo <- tryCatch({fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/RxTerms/rxcui/", dfu$wRxCui[i], "/allinfo"))},
                                              error = function(e){return("ERROR")})
                           if(rxinfo == "ERROR"){
                             rxTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                   brandName = "error",
                                                   displayName = "error",
                                                   GenericName = "error",
                                                   synonym = "error",
                                                   strength = "error",
                                                   DoseForm = "error",
                                                   route = "error",
                                                   termtype = "error",
                                                   stringsAsFactors = FALSE)
                           }else{
                           if(is.null(rxinfo$rxtermsProperties)){
                             rxTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                   brandName = NA,
                                                   displayName = NA,
                                                   GenericName = NA,
                                                   synonym = NA,
                                                   strength = NA,
                                                   DoseForm = NA,
                                                   route = NA,
                                                   termtype = NA,
                                                   stringsAsFactors = FALSE)
                           }else{
                             rxTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                   brandName = rxinfo$rxtermsProperties$brandName,
                                                   displayName = rxinfo$rxtermsProperties$displayName,
                                                   GenericName = rxinfo$rxtermsProperties$fullGenericName,
                                                   synonym = rxinfo$rxtermsProperties$synonym,
                                                   strength = rxinfo$rxtermsProperties$strength,
                                                   DoseForm = rxinfo$rxtermsProperties$rxtermsDoseForm,
                                                   route = rxinfo$rxtermsProperties$route,
                                                   termtype = rxinfo$rxtermsProperties$termType,
                                                   stringsAsFactors = FALSE)
                           }
                             }
                           rxTable
                         }
  stopCluster(cl)
  RxNormInFoData <- unique(RxNormInFoData)
  RxCui_InFo <- left_join(df,RxNormInFoData, by = "wRxCui")
  colnames(RxCui_InFo)[colnames(RxCui_InFo)=="wRxCui"] <- deparse(substitute(RxCuiColName))

  return (RxCui_InFo)
}
