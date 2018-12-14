get.StrengthViaRxCui <- function(df, RxCuiColName = RxCui, cores = 8){
  colnames(df)[colnames(df)==deparse(substitute(RxCuiColName))] <- "wRxCui"
  dfu <- df %>% select("wRxCui") %>% unique()
  cl <- makeCluster(cores)
  registerDoParallel(cl)
  StrengthData = foreach(i = 1:nrow(dfu),
                    .combine = "rbind",
                    .packages = "httr") %dopar% {
                      if(is.na(dfu$wRxCui[i])){
                        RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                      strength = NA,
                                                      stringsAsFactors = FALSE)
                      }else{
                        ttyJSON <- GET(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/property?propName=TTY"), timeout(60))
                        if(http_error(ttyJSON)){
                          RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                        strength = "error",
                                                        stringsAsFactors = FALSE)
                        }else{
                        tty <- content(ttyJSON)
                        if(tty$propConceptGroup$propConcept[[1]]$propValue == "BPCK"){
                          RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                        strength = "BPCK",
                                                        stringsAsFactors = FALSE)
                        }else if(tty$propConceptGroup$propConcept[[1]]$propValue == "GPCK"){
                          RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                        strength = "GPCK",
                                                        stringsAsFactors = FALSE)
                        }else{
                          strengthJSON <- GET(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/", dfu$wRxCui[i],"/property?propName=AVAILABLE_STRENGTH"), timeout(60))
                          if(http_error(strengthJSON)){
                            RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          strength = "error",
                                                          stringsAsFactors = FALSE)
                          }else{
                          strength <- content(strengthJSON)
                          if(is.null(strength$propConceptGroup$propConcept[[1]]$propValue)){
                            RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          strength = NA,
                                                          stringsAsFactors = FALSE)
                          }else{
                            RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          strength = strength$propConceptGroup$propConcept[[1]]$propValue,
                                                          stringsAsFactors = FALSE)
                          }
                          }
                        }
                        }
                      }
                      RxStrengthTable
                    }
  stopCluster(cl)

  StrengthData <- unique(StrengthData) %>% data.table
  StrengthData[, strength_value := if_else(strength %in% c("BPCK","GPCK"), strength,
                                if_else(is.na(strength), "",
                                        sapply(strsplit(strength, " "), `[`, 1)))]

  StrengthData <- unique(StrengthData) %>% data.table
  StrengthData[, strength_unit := if_else(strength %in% c("BPCK","GPCK"), strength,
                                           if_else(is.na(strength), "",
                                                   sapply(strsplit(strength, " "), `[`, 2)))]

  RxCui_Strength <- left_join(df,StrengthData, by = "wRxCui")
  colnames(RxCui_Strength)[colnames(RxCui_Strength)=="wRxCui"] <- deparse(substitute(RxCuiColName))

  return (RxCui_Strength)
}
