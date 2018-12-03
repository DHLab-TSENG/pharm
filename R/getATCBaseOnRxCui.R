#' Get NDC code based on RxCui
#' @import dplyr
#' @import doParallel
#' @import data.table
#' @param df data.frame include RxCui
#' @param RxCuiColName A colum for RxCui of df
#' @param cores number of parallel operation
#' @export

get.AtcViaRxCui <- function(df, RxCuiColName = RxCui, cores=8){

  colnames(df)[colnames(df)==deparse(substitute(RxCuiColName))] <- "wRxCui"
  cl <- makeCluster(cores)
  registerDoParallel(cl)

  RxNormIdData = foreach(i = 1:nrow(df),
                         .combine = "rbind",
                         .packages = c("jsonlite", "data.table", "dplyr")) %dopar% {

                           if(is.na(df$wRxCui[i])){
                             AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                    ATC = NA,
                                                    stringsAsFactors = FALSE)
                           }else{
                           tty <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",df$wRxCui[i],"/property?propName=TTY"))

                           if(tty$propConceptGroup$propConcept$propValue == "IN"){
                             ATC <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",df$wRxCui[i],"/property?propName=ATC"))
                             if(is.null(ATC$propConceptGroup$propConcept$propValue)){
                               AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                      ATC = NA,
                                                      stringsAsFactors = FALSE)
                             }else{
                             AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                    ATC = ATC$propConceptGroup$propConcept$propValue,
                                                    stringsAsFactors = FALSE)
                             }
                           }else if(tty$propConceptGroup$propConcept$propValue == "MIN"){
                             ATC <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",df$wRxCui[i],"/property?propName=ATC"))
                             if(is.null(ATC$propConceptGroup$propConcept$propValue)){
                               AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                      ATC = NA,
                                                      stringsAsFactors = FALSE)
                             }else{
                             AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                    ATC = ATC$propConceptGroup$propConcept$propValue,
                                                    stringsAsFactors = FALSE)
                             }
                           }else if(tty$propConceptGroup$propConcept$propValue == "PIN"){
                             ATC <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",df$wRxCui[i],"/property?propName=ATC"))
                             if(is.null(ATC$propConceptGroup$propConcept$propValue)){
                               AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                      ATC = NA,
                                                      stringsAsFactors = FALSE)
                             }else{
                             AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                    ATC = ATC$propConceptGroup$propConcept$propValue,
                                                    stringsAsFactors = FALSE)
                             }
                           }else if(tty$propConceptGroup$propConcept$propValue == "BPCK"){
                             AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                    ATC = "BPCK",
                                                    stringsAsFactors = FALSE)
                           }else if(tty$propConceptGroup$propConcept$propValue == "GPCK"){
                             AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                    ATC = "GPCK",
                                                    stringsAsFactors = FALSE)
                           }else{
                             ingredient <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",df$wRxCui[i],"/allProperties.json?prop=all"))
                             general_cardinality <- ingredient$propConceptGroup$propConcept$propValue[ingredient$propConceptGroup$propConcept$propName == "GENERAL_CARDINALITY"]

                             if(general_cardinality == "SINGLE"){
                               rxinfo <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",df$wRxCui[i],"/allrelated"))
                               ingredient_cui <- data.frame(rxinfo$allRelatedGroup$conceptGroup$conceptProperties[rxinfo$allRelatedGroup$conceptGroup$tty == "IN"])
                               if(nrow(ingredient_cui) == 0){
                                 AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                        ATC = NA,
                                                        stringsAsFactors = FALSE)
                               }else{
                                 rxid <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",ingredient_cui$rxcui[1],"/allProperties.json?prop=all"))
                                 ATC.df <- data.frame(rxid$propConceptGroup$propConcept$propValue[rxid$propConceptGroup$propConcept$propName == "ATC"],
                                                      stringsAsFactors = FALSE)
                                 if(!is.null(ATC.df[1,1])){
                                   AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                          ATC = ATC.df[1,1],
                                                          stringsAsFactors = FALSE)
                                 }else{
                                   AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                          ATC = NA,
                                                          stringsAsFactors = FALSE)
                                   }
                                 }

                             }else{
                               ingredient <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",df$wRxCui[i],"/related?rela=has_ingredients"))
                               ingredient_cui <- data.frame(ingredient$relatedGroup$conceptGroup$conceptProperties[ingredient$relatedGroup$conceptGroup$tty=="MIN"])
                               if(nrow(ingredient_cui) == 0){
                                 AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                        ATC = NA,
                                                        stringsAsFactors = FALSE)
                               }else{
                                 rxid <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",ingredient_cui$rxcui[1],"/allProperties.json?prop=all"))
                                 ATC.df <- data.frame(rxid$propConceptGroup$propConcept$propValue[rxid$propConceptGroup$propConcept$propName == "ATC"],
                                                      stringsAsFactors = FALSE)
                                 if(!is.null(ATC.df[1,1])){
                                   AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                          ATC = ATC.df[1,1],
                                                          stringsAsFactors = FALSE)
                                 }else{
                                   AtcTable <- data.frame(wRxCui = df$wRxCui[i],
                                                          ATC = NA,
                                                          stringsAsFactors = FALSE)
                                 }
                               }

                             }
                           }
                           }
                           AtcTable
                         }
  stopCluster(cl)

  RxNormIdData <- unique(RxNormIdData)
  RxCui_ATC <- left_join(df,RxNormIdData, by = "wRxCui")
  colnames(RxCui_ATC)[colnames(RxCui_ATC)=="wRxCui"] <- deparse(substitute(RxCuiColName))
  return (RxCui_ATC)
}
