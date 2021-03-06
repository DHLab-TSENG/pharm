#' @rdname getMEDRTInfo
#' @export

getMEDRTInfo <- function(df, RxCuiColName = RxCui, cores =8){

  colnames(df)[colnames(df)==deparse(substitute(RxCuiColName))] <- "wRxCui"
  dfu <- df %>% select("wRxCui") %>% unique()

  cl <- makeCluster(cores)
  registerDoParallel(cl)
  RxNormMayTreatData = foreach(i = 1:nrow(dfu),
                           .combine = "rbind",
                           .packages = c("jsonlite","dplyr")) %dopar% {
                             may_treatTemp <- tryCatch({fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxclass/class/byRxcui.json?rxcui=", dfu$wRxCui[i], "&relaSource=MEDRT&relas=may_treat"))},
                                                       error = function(e){return("ERROR")})
                             if(may_treatTemp == "ERROR"){
                               rxTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                     minConcept.rxcui = "error",
                                                     minConcept.name = "error",
                                                     rxclassMinConceptItem.classId = "error",
                                                     rxclassMinConceptItem.className = "error",
                                                     stringsAsFactors = FALSE)
                             }else{
                             may_treat <- may_treatTemp$rxclassDrugInfoList
                             if(is.null(may_treat)){
                               rxTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                     minConcept.rxcui = NA,
                                                     minConcept.name = NA,
                                                     rxclassMinConceptItem.classId = NA,
                                                     rxclassMinConceptItem.className = NA,
                                                     stringsAsFactors = FALSE)
                             }else{
                               rxTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                     minConcept.rxcui = may_treat$rxclassDrugInfo$minConcept$rxcui,
                                                     minConcept.name = may_treat$rxclassDrugInfo$minConcept$name,
                                                     rxclassMinConceptItem.classId = may_treat$rxclassDrugInfo$rxclassMinConceptItem$classId,
                                                     rxclassMinConceptItem.className = may_treat$rxclassDrugInfo$rxclassMinConceptItem$className,
                                                     stringsAsFactors = FALSE)
                             }
                             }
                             rxTable
                           }
  stopCluster(cl)

  RxNormMayTreatData <- unique(RxNormMayTreatData)
  RxCui_MayTreat <- left_join(df,RxNormMayTreatData, by = "wRxCui")
  colnames(RxCui_MayTreat)[colnames(RxCui_MayTreat)=="wRxCui"] <- deparse(substitute(RxCuiColName))

  return (RxCui_MayTreat)
}

