#' Get the Veterans Health Administration’s Medication Reference Terminology (MED-RT) information based on RxCui
#'
#' @import dplyr
#' @import doParallel
#' @param df data.frame include RxCui
#' @param RxCuiColName A colum for RxCui of df
#' @param cores number of parallel operation
#' @export

get.MEDRTinfo <- function(df, RxCuiColName = RxCui, cores =8){

  colnames(df)[colnames(df)==deparse(substitute(RxCuiColName))] <- "wRxCui"
  dfu <- df %>% select("wRxCui") %>% unique()

  cl <- makeCluster(cores)
  registerDoParallel(cl)
  RxNormMayTreatData = foreach(i = 1:nrow(dfu),
                           .combine = "rbind",
                           .packages = c("jsonlite","dplyr")) %dopar% {
                             may_treatTemp <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxclass/class/byRxcui.json?rxcui=", dfu$wRxCui[i], "&relaSource=MEDRT&relas=may_treat"))
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
                             rxTable
                           }
  stopCluster(cl)

  RxNormMayTreatData <- unique(RxNormMayTreatData)
  RxCui_MayTreat <- left_join(df,RxNormMayTreatData, by = "wRxCui")
  colnames(RxCui_MayTreat)[colnames(RxCui_MayTreat)=="wRxCui"] <- deparse(substitute(RxCuiColName))

  return (RxCui_MayTreat)
}

