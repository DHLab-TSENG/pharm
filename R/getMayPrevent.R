#' Get may prevent based on RxCui
#'
#' @import dplyr
#' @import doParallel
#' @param df data.frame include RxCui
#' @param RxCuiColName A colum for RxCui of df
#' @param cores number of parallel operation
#' @export

get.MayPrevent <- function(df, RxCuiColName = RxCui, cores =16){

  colnames(df)[colnames(df)==deparse(substitute(RxCuiColName))] <- "wRxCui"
  dfu <- df %>% select("wRxCui") %>% unique()

  cl <- makeCluster(cores)
  registerDoParallel(cl)
  RxNormMayPreventData = foreach(i = 1:nrow(dfu),
                               .combine = "rbind",
                               .packages = c("jsonlite","dplyr")) %dopar% {
                                 may_preventTemp <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxclass/class/byRxcui.json?rxcui=", dfu$wRxCui[i], "&relaSource=MEDRT&relas=may_prevent"))
                                 may_prevent <- may_preventTemp$rxclassDrugInfoList
                                 if(is.null(may_prevent)){
                                   rxTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                         minConcept.rxcui = NA,
                                                         minConcept.name = NA,
                                                         rxclassMinConceptItem.classId = NA,
                                                         rxclassMinConceptItem.className = NA,
                                                         stringsAsFactors = FALSE)
                                 }else{
                                   rxTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                         minConcept.rxcui = may_prevent$rxclassDrugInfo$minConcept$rxcui,
                                                         minConcept.name = may_prevent$rxclassDrugInfo$minConcept$name,
                                                         rxclassMinConceptItem.classId = may_prevent$rxclassDrugInfo$rxclassMinConceptItem$classId,
                                                         rxclassMinConceptItem.className = may_prevent$rxclassDrugInfo$rxclassMinConceptItem$className,
                                                         stringsAsFactors = FALSE)
                                 }
                                 rxTable
                               }
  stopCluster(cl)

  RxNormMayPreventData <- unique(RxNormMayPreventData)
  RxCui_MayPrevent <- left_join(df,RxNormMayPreventData, by = "wRxCui")
  colnames(RxCui_MayPrevent)[colnames(RxCui_MayPrevent)=="wRxCui"] <- deparse(substitute(RxCuiColName))

  return (RxCui_MayPrevent)
}
