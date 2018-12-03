get.StrengthViaRxCui <- function(df, RxCuiColName = RxCui, cores = 8){
  colnames(df)[colnames(df)==deparse(substitute(RxCuiColName))] <- "wRxCui"
  cl <- makeCluster(cores)
  registerDoParallel(cl)
  StrengthData = foreach(i = 1:nrow(df),
                    .combine = "rbind",
                    .packages = "jsonlite") %dopar% {
                      if(is.na(df$wRxCui[i])){
                        RxStrengthTable <- data.frame(wRxCui = df$wRxCui[i],
                                                      strength = NA,
                                                      stringsAsFactors = FALSE)
                      }else{
                        tty <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",df$wRxCui[i],"/property?propName=TTY"))

                        if(tty$propConceptGroup$propConcept$propValue == "BPCK"){
                          RxStrengthTable <- data.frame(wRxCui = df$wRxCui[i],
                                                        strength = "BPCK",
                                                        stringsAsFactors = FALSE)
                        }else if(tty$propConceptGroup$propConcept$propValue == "GPCK"){
                          RxStrengthTable <- data.frame(wRxCui = df$wRxCui[i],
                                                        strength = "GPCK",
                                                        stringsAsFactors = FALSE)
                        }else{
                          strength <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/", df$wRxCui[i],"/property?propName=AVAILABLE_STRENGTH"))
                          if(is.null(strength$propConceptGroup$propConcept$propValue)){
                            RxStrengthTable <- data.frame(wRxCui = df$wRxCui[i],
                                                          strength = NA,
                                                          stringsAsFactors = FALSE)
                          }else{
                            RxStrengthTable <- data.frame(wRxCui = df$wRxCui[i],
                                                          strength = strength$propConceptGroup$propConcept$propValue,
                                                          stringsAsFactors = FALSE)
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
