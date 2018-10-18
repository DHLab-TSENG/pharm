#' Get NDC code based on RxCui
#' @import dplyr
#' @import doParallel
#' @import jsonlite
#' @param df data.frame include RxCui
#' @param RxCuiColName A colum for RxCui of df
#' @param Differ_ColName if colum for RxCui of df not named "RxCui"
#' @export

get.AtcViaRxCui <- function(df, RxCuiColName = RxCui, cores=8){

  colnames(df)[colnames(df)==deparse(substitute(RxCuiColName))] <- "RxCui"
  cl <- makeCluster(cores)
  registerDoParallel(cl)
  RxNormIdData = foreach(i = 1:nrow(df),
                         .combine = "rbind",
                         .packages = "jsonlite") %dopar% {
                           rxinfo <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",df$RxCui[i],"/allrelated"))
                           ingredient_cui <- data.frame(rxinfo$allRelatedGroup$conceptGroup$conceptProperties[rxinfo$allRelatedGroup$conceptGroup$tty == "IN"])
                           rx_route <- data.frame(rxinfo$allRelatedGroup$conceptGroup$conceptProperties[rxinfo$allRelatedGroup$conceptGroup$tty == "DFG"])

                           rxid <- fromJSON(paste0("https://rxnav.nlm.nih.gov/REST/rxcui/",ingredient_cui$rxcui[1],"/allProperties.json?prop=all"))
                           if(is.null(rxid) || length(rxid$propConceptGroup$propConcept$propValue[rxid$propConceptGroup$propConcept$propName == "ATC"])==0){
                             AtcTable <- data.frame(RxCui = df$RxCui[i],
                                                    Rx_route = NA,
                                                    ATC = NA,
                                                    stringsAsFactors = FALSE)
                           }else{
                             AtcTable <- data.frame(RxCui = df$RxCui[i],
                                                    Rx_route = rx_route$name[1],
                                                    ATC = rxid$propConceptGroup$propConcept$propValue[rxid$propConceptGroup$propConcept$propName == "ATC"],
                                                    stringsAsFactors = FALSE)
                           }
                           AtcTable
                         }
  stopCluster(cl)
  RxNormIdData <- unique(RxNormIdData)
  RxNormIdData <- data.table(RxNormIdData)
  RxNormIdData[, Rx_DFG :=  if_else(Rx_route == "Drug Implant Product", "implant",
                                    if_else(Rx_route == "Inhalant Product", "Inhal",
                                            if_else(Rx_route == "Nasal Product", "N",
                                                    if_else(Rx_route == "Oral Product", "O",
                                                            if_else(Rx_route == "Ophthalmic Product", "lamella",
                                                                    if_else(Rx_route == "Injectable Product", "P",
                                                                            if_else(Rx_route == "Rectal Product", "R",
                                                                                    if_else(Rx_route == "Sublingual Product", "SL",
                                                                                            if_else(Rx_route == "Transdermal Product", "TD",
                                                                                                    if_else(Rx_route == "Vaginal Product", "V",Rx_route))))))))),
                                    missing = "")]

  RxNormIdData <- RxNormIdData %>% select(RxCui, Rx_DFG, ATC)
  RxNormIdData <- RxNormIdData %>% left_join(resATC_Adm.R, by = "ATC") %>%
    filter(Rx_DFG == Adm.R) %>% select(RxCui, ATC) %>% unique()

  RxCui_ATC <- left_join(df,RxNormIdData, by = "RxCui")
  colnames(RxCui_ATC)[colnames(RxCui_ATC)=="RxCui"] <- deparse(substitute(RxCuiColName))
  return (RxCui_ATC)
}
