#' Calculate dailydosage for midication coding in RxNorm
#' @param df data.frame include ATC code
#' @param RxCuiColName A colum for RxCui of df
#' @param QuantityColName A colum for Quantity of df
#' @param DaysSupplyConName A colum for DaysSupply of df
#' @export
#'
calDailyDosage <- function(df,
                           RxCuiColName = RxCui,
                           QuantityColName = Quantity,
                           DaysSupplyConName = DaysSupply,
                           cores = 4){

  colnames(df)[colnames(df)==deparse(substitute(RxCuiColName))] <- "wRxCui"
  colnames(df)[colnames(df)==deparse(substitute(QuantityColName))] <- "Quantity"
  colnames(df)[colnames(df)==deparse(substitute(DaysSupplyConName))] <- "DaysSupply"
  dfu <- df %>% select("wRxCui") %>% unique()
  cl <- makeCluster(cores)
  registerDoParallel(cl)
  StrengthData = foreach(i = 1:nrow(dfu),
                         .combine = "rbind",
                         .packages = "httr") %dopar% {
                           if(is.na(dfu$wRxCui[i])){
                             RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                           numeratorValue = NA,
                                                           Unit = NA,
                                                           stringsAsFactors = FALSE)
                           }else{
                             ttyJSON <- tryCatch({GET(paste0("https://rxnav.nlm.nih.gov/REST/rxcuihistory/concept.json?rxcui=",dfu$wRxCui[i]), timeout(60))},
                                                 error = function(e){return("ERROR")})
                             if(http_error(ttyJSON)){
                               RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                             numeratorValue = "error",
                                                             Unit = "error",
                                                             stringsAsFactors = FALSE)
                             }else if(ttyJSON == "ERROR"){
                               RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                             numeratorValue = "error",
                                                             Unit = "error",
                                                             stringsAsFactors = FALSE)
                             }else{
                               tty <- content(ttyJSON)
                               if(tty$rxcuiHistoryConcept$rxcuiConcept$tty == "BPCK"){
                                 RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                               numeratorValue = "BPCK",
                                                               Unit = "BPCK",
                                                               stringsAsFactors = FALSE)

                               }else if(tty$rxcuiHistoryConcept$rxcuiConcept$tty == "GPCK"){
                                 RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                               numeratorValue = "GPCK",
                                                               Unit = "GPCK",
                                                               stringsAsFactors = FALSE)
                               }else{
                                 RxStrengthTable <- data.frame(wRxCui = dfu$wRxCui[i],
                                                               numeratorValue = tty$rxcuiHistoryConcept$bossConcept[[1]]$numeratorValue,
                                                               Unit = tty$rxcuiHistoryConcept$bossConcept[[1]]$numeratorUnit,
                                                               stringsAsFactors = FALSE)
                               }
                             }
                           }
                           RxStrengthTable
                         }
  stopCluster(cl)

  RxCui_Strength <- left_join(df,StrengthData, by = "wRxCui")
  RxCui_Strength$numeratorValue <- as.numeric(RxCui_Strength$numeratorValue)
  RxCui_Strength <- as.data.table(RxCui_Strength)
  RxCui_Strength[, DailyDosage := if_else(numeratorValue %in% c("BPCK", "GPCK", "error"), numeratorValue, round(Quantity*numeratorValue/DaysSupply, 2))]
  Unit <- RxCui_Strength$Unit
  RxCui_Strength <- select(RxCui_Strength, -c(numeratorValue, Unit))
  RxCui_Strength$Unit <- Unit
  colnames(RxCui_Strength)[colnames(RxCui_Strength)=="wRxCui"] <- deparse(substitute(RxCuiColName))
  colnames(RxCui_Strength)[colnames(RxCui_Strength)=="Quantity"] <- deparse(substitute(QuantityColName))
  colnames(RxCui_Strength)[colnames(RxCui_Strength)=="DaysSupply"] <- deparse(substitute(DaysSupplyConName))

  return (RxCui_Strength)
}
