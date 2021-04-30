#' @rdname getSbdRxcuiViaRxcui
#' @export

getSbdRxcuiViaRxcui <- function(df, RxCuiColName = RxCui, cores = 8){

  colnames(df)[colnames(df)==deparse(substitute(RxCuiColName))] <- "wRxCui"
  dfu <- df %>% select("wRxCui") %>% unique()

  cl <- makeCluster(cores)
  registerDoParallel(cl)
  SbdData = foreach(i = 1:nrow(dfu),
                         .combine = "rbind",
                         .packages = "jsonlite") %dopar% {
                           sbd.rxcui <- tryCatch({fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/", dfu$wRxCui[i], "/allrelated"))},
                                                 error = function(e){return("ERROR")})
                           if(sbd.rxcui == "ERROR"){
                             RxSbdTable <- data.frame(wRxCui=dfu$wRxCui[i],
                                                      SBD.rxcui="error",
                                                      stringsAsFactors = FALSE)
                           }else{
                           #sbd.rxcui <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/", dfu$wRxCui[i], "/allrelated"))
                           sbd.df <- data.frame(sbd.rxcui$allRelatedGroup$conceptGroup$conceptProperties[sbd.rxcui$allRelatedGroup$conceptGroup$tty == "SBD"])
                           scd.df <- data.frame(sbd.rxcui$allRelatedGroup$conceptGroup$conceptProperties[sbd.rxcui$allRelatedGroup$conceptGroup$tty == "SCD"])
                           if(is.null(sbd.df$rxcui) & is.null(scd.df$rxcui)){
                             RxSbdTable <- data.frame(wRxCui=dfu$wRxCui[i],
                                                   SBD.rxcui=NA,
                                                   stringsAsFactors = FALSE)
                           }else if(!is.null(sbd.df$rxcui) & is.null(scd.df$rxcui)){
                             RxSbdTable <- data.frame(wRxCui=dfu$wRxCui[i],
                                                      SBD.rxcui = sbd.df$rxcui,
                                                   stringsAsFactors = FALSE)
                           }else if(is.null(sbd.df$rxcui) & !is.null(scd.df$rxcui)){
                             RxSbdTable <- data.frame(wRxCui=dfu$wRxCui[i],
                                                      SBD.rxcui = scd.df$rxcui,
                                                      stringsAsFactors = FALSE)
                           }else{
                             RxSbdTable <- data.frame(wRxCui=dfu$wRxCui[i],
                                                      SBD.rxcui = c(scd.df$rxcui, sbd.df$rxcui),
                                                      stringsAsFactors = FALSE)
                           }
                           }
                           RxSbdTable
                         }
  stopCluster(cl)
  SbdData <- unique(SbdData)
  RxCui_SBD <- left_join(df,SbdData, by = "wRxCui")
  colnames(RxCui_SBD)[colnames(RxCui_SBD)=="wRxCui"] <- deparse(substitute(RxCuiColName))

  return (RxCui_SBD)
}


