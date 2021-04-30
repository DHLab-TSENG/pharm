#' @rdname getAtcViaRxcui
#' @export

getAtcViaRxcui <- function(df, RxCuiColName = RxCui, cores=4, MatchRoute = FALSE){

  colnames(df)[colnames(df)==deparse(substitute(RxCuiColName))] <- "wRxCui"
  dfu <- df %>% select("wRxCui") %>% unique()
  cl <- makeCluster(cores)
  registerDoParallel(cl)

  if(MatchRoute == TRUE){
    RxNormIdData = foreach(i = 1:nrow(dfu),
                           .combine = "rbind",
                           .packages = c("jsonlite", "data.table", "dplyr")) %dopar% {

                             if(is.na(dfu$wRxCui[i])){
                               AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                      ATC = NA,
                                                      DFG = NA,
                                                      stringsAsFactors = FALSE)
                             }else{
                               tty <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/property?propName=TTY"))

                               if(is.null(tty$propConceptGroup)){
                                 AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                        ATC = NA,
                                                        DFG = NA,
                                                        stringsAsFactors = FALSE)
                               }else if(tty$propConceptGroup$propConcept$propValue == "IN"){
                                 ATC <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/property?propName=ATC"))
                                 DFG <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/related?tty=DFG"))
                                 DFG.df <- as.data.frame(DFG$relatedGroup$conceptGroup$conceptProperties[DFG$relatedGroup$conceptGroup$tty == "DFG"])
                                 if(is.null(ATC$propConceptGroup$propConcept$propValue)){
                                   AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          ATC = NA,
                                                          DFG = NA,
                                                          stringsAsFactors = FALSE)
                                 }else{
                                   AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          ATC = ATC$propConceptGroup$propConcept$propValue,
                                                          DFG = DFG.df$name[1],
                                                          stringsAsFactors = FALSE)
                                 }
                               }else if(tty$propConceptGroup$propConcept$propValue == "MIN"){
                                 ATC <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/property?propName=ATC"))
                                 DFG <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/related?tty=DFG"))
                                 DFG.df <- as.data.frame(DFG$relatedGroup$conceptGroup$conceptProperties[DFG$relatedGroup$conceptGroup$tty == "DFG"])
                                 if(is.null(ATC$propConceptGroup$propConcept$propValue)){
                                   AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          ATC = NA,
                                                          DFG = NA,
                                                          stringsAsFactors = FALSE)
                                 }else{
                                   AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          ATC = ATC$propConceptGroup$propConcept$propValue,
                                                          DFG = DFG.df$name[1],
                                                          stringsAsFactors = FALSE)
                                 }
                               }else if(tty$propConceptGroup$propConcept$propValue == "PIN"){
                                 ATC <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/property?propName=ATC"))
                                 DFG <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/related?tty=DFG"))
                                 DFG.df <- as.data.frame(DFG$relatedGroup$conceptGroup$conceptProperties[DFG$relatedGroup$conceptGroup$tty == "DFG"])
                                 if(is.null(ATC$propConceptGroup$propConcept$propValue)){
                                   AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          ATC = NA,
                                                          DFG = NA,
                                                          stringsAsFactors = FALSE)
                                 }else{
                                   AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          ATC = ATC$propConceptGroup$propConcept$propValue,
                                                          DFG = DFG.df$name[1],
                                                          stringsAsFactors = FALSE)
                                 }
                               }else if(tty$propConceptGroup$propConcept$propValue == "BPCK"){
                                 AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                        ATC = "BPCK",
                                                        DFG = NA,
                                                        stringsAsFactors = FALSE)
                               }else if(tty$propConceptGroup$propConcept$propValue == "GPCK"){
                                 AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                        ATC = "GPCK",
                                                        DFG = NA,
                                                        stringsAsFactors = FALSE)
                               }else{
                                 ingredient <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/allProperties.json?prop=ATTRIBUTES"))
                                 general_cardinality <- ingredient$propConceptGroup$propConcept$propValue[ingredient$propConceptGroup$propConcept$propName == "GENERAL_CARDINALITY"]

                                 if(general_cardinality == "SINGLE"){
                                   rxinfo <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/allrelated"))
                                   ingredient_cui <- data.frame(rxinfo$allRelatedGroup$conceptGroup$conceptProperties[rxinfo$allRelatedGroup$conceptGroup$tty == "IN"])
                                   if(nrow(ingredient_cui) == 0){
                                     AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                            ATC = NA,
                                                            DFG = NA,
                                                            stringsAsFactors = FALSE)
                                   }else{
                                     ATC <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",ingredient_cui$rxcui[1],"/property?propName=ATC"))
                                     DFG <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/related?tty=DFG"))
                                     DFG.df <- as.data.frame(DFG$relatedGroup$conceptGroup$conceptProperties[DFG$relatedGroup$conceptGroup$tty == "DFG"])
                                     if(!is.null(ATC$propConceptGroup$propConcept$propValue)){
                                       AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                              ATC = ATC$propConceptGroup$propConcept$propValue,
                                                              DFG = DFG.df$name[1],
                                                              stringsAsFactors = FALSE)
                                     }else{
                                       AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                              ATC = NA,
                                                              DFG = NA,
                                                              stringsAsFactors = FALSE)
                                     }
                                   }

                                 }else{
                                   rxinfo <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/allrelated"))
                                   ingredient_cui <- data.frame(rxinfo$allRelatedGroup$conceptGroup$conceptProperties[rxinfo$allRelatedGroup$conceptGroup$tty == "MIN"])
                                   if(nrow(ingredient_cui) == 0){
                                     AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                            ATC = NA,
                                                            DFG = NA,
                                                            stringsAsFactors = FALSE)
                                   }else{
                                     ATC <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",ingredient_cui$rxcui[1],"/property?propName=ATC"))
                                     DFG <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/related?tty=DFG"))
                                     DFG.df <- as.data.frame(DFG$relatedGroup$conceptGroup$conceptProperties[DFG$relatedGroup$conceptGroup$tty == "DFG"])
                                     if(!is.null(ATC$propConceptGroup$propConcept$propValue)){
                                       AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                              ATC = ATC$propConceptGroup$propConcept$propValue,
                                                              DFG = DFG.df$name[1],
                                                              stringsAsFactors = FALSE)
                                     }else{
                                       AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                              ATC = NA,
                                                              DFG = NA,
                                                              stringsAsFactors = FALSE)
                                     }
                                   }

                                 }
                               }
                             }
                             AtcTable
                           }
    stopCluster(cl)

    DFG_implant <- "DrugImplantProduct"
    DFG_inhalation <-"InhalantProduct"
    DFG_nasal <- "NasalProduct"
    DFG_oral <- "OralProduct"
    DFG_ophthalmic <- "OphthalmicProduct"
    DFG_otic <- "OticProduct"
    DFG_parenteral <- "InjectableProduct"
    DFG_rectal <- "RectalProduct"
    DFG_sublingual <- "SublingualProduct"
    DFG_stomatologic <- "BuccalProduct|DentalProduct|OralCreamProduct|OralFoamProduct|OralGelProduct|OralOintmentProduct|OralPasteProduct"
    DFG_transdermal <- "TransdermalProduct"
    DFG_topical <- "IntraperitonealProduct|IrrigationProduct|MucosalProduct|PrefilledApplicatorProduct|ShampooProduct|SoapProduct|TopicalProduct"
    DFG_urethral <- "UrethralProduct"
    DFG_vaginal <- "VaginalProduct"

    RxNormIdData <- unique(RxNormIdData) %>% as.data.table()
    RxNormIdData[, DFG := gsub(" ", "", DFG)]
    RxNormIdData[, route := if_else(grepl(DFG_implant, DFG), "implant",
                                    if_else(grepl(DFG_inhalation, DFG), "inhalation",
                                            if_else(grepl(DFG_nasal, DFG), "nasal",
                                                    if_else(grepl(DFG_oral, DFG), "oral",
                                                            if_else(grepl(DFG_ophthalmic, DFG), "ophthalmic",
                                                                    if_else(grepl(DFG_otic, DFG), "otic",
                                                                            if_else(grepl(DFG_parenteral, DFG), "parenteral",
                                                                                    if_else(grepl(DFG_rectal, DFG), "rectal",
                                                                                            if_else(grepl(DFG_sublingual, DFG), "sublingual",
                                                                                                    if_else(grepl(DFG_stomatologic, DFG), "stomatologic",
                                                                                                            if_else(grepl(DFG_transdermal, DFG), "transdermal",
                                                                                                                    if_else(grepl(DFG_topical, DFG), "topical",
                                                                                                                            if_else(grepl(DFG_urethral, DFG), "urethral",
                                                                                                                                    if_else(grepl(DFG_vaginal, DFG), "vaginal", ""))))))))))))))]

    RxNormIdData <- left_join(RxNormIdData, resATC_Adm.RF, by = "ATC") %>% as.data.table()
    HasSameRoute <- mapply(grepl, RxNormIdData$Adm.RF, RxNormIdData$route)
    RxNormIdData$HasSameRoute <- HasSameRoute
    RxNormIdData <- filter(RxNormIdData, is.na(HasSameRoute) | HasSameRoute == T) %>% select(wRxCui, ATC) %>% unique()

    RxCui_ATC <- left_join(df,RxNormIdData, by = "wRxCui")
    colnames(RxCui_ATC)[colnames(RxCui_ATC)=="wRxCui"] <- deparse(substitute(RxCuiColName))
    return (RxCui_ATC)
  }else{
    RxNormIdData = foreach(i = 1:nrow(dfu),
                           .combine = "rbind",
                           .packages = c("jsonlite", "data.table", "dplyr")) %dopar%{

                             if(is.na(dfu$wRxCui[i])){
                               AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                      ATC = NA,
                                                      stringsAsFactors = FALSE)
                             }else{
                               tty <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/property?propName=TTY"))

                               if(is.null(tty$propConceptGroup)){
                                 ingredient <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcuihistory/concept.json?rxcui=",dfu$wRxCui[i]))
                                 ingredient_rxcui <- ingredient$rxcuiHistoryConcept$bossConcept$baseRxcui[1]

                                 if(is.null(ingredient_rxcui)){
                                   AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          ATC = NA,
                                                          stringsAsFactors = FALSE)
                                 }else{
                                   ATC <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",ingredient_rxcui,"/property?propName=ATC"))
                                   if(is.null(ATC$propConceptGroup)){
                                     AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                            ATC = NA,
                                                            stringsAsFactors = FALSE)
                                   }else{
                                   AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          ATC = ATC$propConceptGroup$propConcept$propValue[1],
                                                          stringsAsFactors = FALSE)
                                   }
                                 }
                               }else if(tty$propConceptGroup$propConcept$propValue == "IN"){
                                 ATC <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/property?propName=ATC"))
                                 if(is.null(ATC$propConceptGroup$propConcept$propValue)){
                                   AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          ATC = NA,
                                                          stringsAsFactors = FALSE)
                                 }else{
                                   AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          ATC = ATC$propConceptGroup$propConcept$propValue[1],
                                                          stringsAsFactors = FALSE)
                                 }
                               }else if(tty$propConceptGroup$propConcept$propValue == "MIN"){
                                 ATC <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/property?propName=ATC"))
                                 if(is.null(ATC$propConceptGroup$propConcept$propValue)){
                                   AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          ATC = NA,
                                                          stringsAsFactors = FALSE)
                                 }else{
                                   AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          ATC = ATC$propConceptGroup$propConcept$propValue[1],
                                                          stringsAsFactors = FALSE)
                                 }
                               }else if(tty$propConceptGroup$propConcept$propValue == "PIN"){
                                 ATC <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/property?propName=ATC"))
                                 if(is.null(ATC$propConceptGroup$propConcept$propValue)){
                                   AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          ATC = NA,
                                                          stringsAsFactors = FALSE)
                                 }else{
                                   AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                          ATC = ATC$propConceptGroup$propConcept$propValue[1],
                                                          stringsAsFactors = FALSE)
                                 }
                               }else if(tty$propConceptGroup$propConcept$propValue == "BPCK"){
                                 AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                        ATC = "BPCK",
                                                        stringsAsFactors = FALSE)
                               }else if(tty$propConceptGroup$propConcept$propValue == "GPCK"){
                                 AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                        ATC = "GPCK",
                                                        stringsAsFactors = FALSE)
                               }else{
                                 ingredient <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/allProperties.json?prop=all"))
                                 general_cardinality <- ingredient$propConceptGroup$propConcept$propValue[ingredient$propConceptGroup$propConcept$propName == "GENERAL_CARDINALITY"]

                                 if(general_cardinality == "SINGLE"){
                                   rxinfo <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/allrelated"))
                                   ingredient_cui <- data.frame(rxinfo$allRelatedGroup$conceptGroup$conceptProperties[rxinfo$allRelatedGroup$conceptGroup$tty == "IN"])
                                   if(nrow(ingredient_cui) == 0){
                                     AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                            ATC = NA,
                                                            stringsAsFactors = FALSE)
                                   }else{
                                     ATC <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",ingredient_cui$rxcui[1],"/property?propName=ATC"))
                                     if(!is.null(ATC$propConceptGroup$propConcept$propValue)){
                                       AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                              ATC = ATC$propConceptGroup$propConcept$propValue[1],
                                                              stringsAsFactors = FALSE)
                                     }else{
                                       AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                              ATC = NA,
                                                              stringsAsFactors = FALSE)
                                     }
                                   }

                                 }else{
                                   rxinfo <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",dfu$wRxCui[i],"/allrelated"))
                                   ingredient_cui <- data.frame(rxinfo$allRelatedGroup$conceptGroup$conceptProperties[rxinfo$allRelatedGroup$conceptGroup$tty == "MIN"])
                                   if(nrow(ingredient_cui) == 0){
                                     AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                            ATC = NA,
                                                            stringsAsFactors = FALSE)
                                   }else{
                                     ATC <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",ingredient_cui$rxcui[1],"/property?propName=ATC"))
                                     if(!is.null(ATC$propConceptGroup$propConcept$propValue)){
                                       AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                              ATC = ATC$propConceptGroup$propConcept$propValue[1],
                                                              stringsAsFactors = FALSE)
                                     }else{
                                       AtcTable <- data.frame(wRxCui = dfu$wRxCui[i],
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
}
