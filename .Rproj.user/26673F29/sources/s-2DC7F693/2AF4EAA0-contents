#' Get Ingredient and Basis of strength substance (BoSS)
#' @importFrom parallel::makeCluster()
#' @importFrom parallel::stopCluster()
#' @import foreach
#' @import doParallel
#' @param df data.frame include RxCui
#' @param RxCuiColName A colum for RxCui of df
#' @param cores number of parallel operation
#' @export

get.BoSSViaRxCui <- function(df, RxCuiColName = RxCui, cores = 8){
  colnames(df)[colnames(df)==deparse(substitute(RxCuiColName))] <- "wRxCui"
  dfu <- df %>% select("wRxCui") %>% unique()
  cl <- makeCluster(cores)
  registerDoParallel(cl)
  StrengthData = foreach(i = 1:nrow(dfu),
                    .combine = "rbind",
                    .packages = "httr") %dopar% {
                      if(is.na(dfu$wRxCui[i])){
                        RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                      baseRxcui = NA,
                                                      baseName = NA,
                                                      bossRxcui = NA,
                                                      bossName = NA,
                                                      numeratorValue = NA,
                                                      numeratorUnit = NA,
                                                      denominatorValue = NA,
                                                      denominatorUnit = NA,
                                                      stringsAsFactors = FALSE)
                      }else{
                        ttyJSON <- tryCatch({GET(paste0("https://rxnav.nlm.nih.gov/REST/rxcuihistory/concept.json?rxcui=",dfu$wRxCui[i]), timeout(60))},
                                 error = function(e){return("ERROR")})
                        if(http_error(ttyJSON)){
                          RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                        baseRxcui = "error",
                                                        baseName = "error",
                                                        bossRxcui = "error",
                                                        bossName = "error",
                                                        numeratorValue = "error",
                                                        numeratorUnit = "error",
                                                        denominatorValue = "error",
                                                        denominatorUnit = "error",
                                                        stringsAsFactors = FALSE)
                        }else if(ttyJSON == "ERROR"){
                          RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                        baseRxcui = "error",
                                                        baseName = "error",
                                                        bossRxcui = "error",
                                                        bossName = "error",
                                                        numeratorValue = "error",
                                                        numeratorUnit = "error",
                                                        denominatorValue = "error",
                                                        denominatorUnit = "error",
                                                        stringsAsFactors = FALSE)
                        }else{
                        tty <- content(ttyJSON)
                        if(tty$rxcuiHistoryConcept$rxcuiConcept$tty == "BPCK"){
                          RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                        baseRxcui = "BPCK",
                                                        baseName = "BPCK",
                                                        bossRxcui = "BPCK",
                                                        bossName = "BPCK",
                                                        numeratorValue = "BPCK",
                                                        numeratorUnit = "BPCK",
                                                        denominatorValue = "BPCK",
                                                        denominatorUnit = "BPCK",
                                                        stringsAsFactors = FALSE)

                        }else if(tty$rxcuiHistoryConcept$rxcuiConcept$tty == "GPCK"){
                          RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                        baseRxcui = "GPCK",
                                                        baseName = "GPCK",
                                                        bossRxcui = "GPCK",
                                                        bossName = "GPCK",
                                                        numeratorValue = "GPCK",
                                                        numeratorUnit = "GPCK",
                                                        denominatorValue = "GPCK",
                                                        denominatorUnit = "GPCK",
                                                        stringsAsFactors = FALSE)
                        }else{
                          RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                        baseRxcui = tty$rxcuiHistoryConcept$bossConcept[[1]]$baseRxcui,
                                                        baseName = tty$rxcuiHistoryConcept$bossConcept[[1]]$baseName,
                                                        bossRxcui = tty$rxcuiHistoryConcept$bossConcept[[1]]$bossRxcui,
                                                        bossName = tty$rxcuiHistoryConcept$bossConcept[[1]]$bossName,
                                                        numeratorValue = tty$rxcuiHistoryConcept$bossConcept[[1]]$numeratorValue,
                                                        numeratorUnit = tty$rxcuiHistoryConcept$bossConcept[[1]]$numeratorUnit,
                                                        denominatorValue = tty$rxcuiHistoryConcept$bossConcept[[1]]$denominatorValue,
                                                        denominatorUnit = tty$rxcuiHistoryConcept$bossConcept[[1]]$denominatorUnit,
                                                        stringsAsFactors = FALSE)
                        }
                        }
                      }
                      RxStrengthTable
                    }
  stopCluster(cl)

  RxCui_Strength <- left_join(df,StrengthData, by = "wRxCui")
  colnames(RxCui_Strength)[colnames(RxCui_Strength)=="wRxCui"] <- deparse(substitute(RxCuiColName))

  return (RxCui_Strength)
}
