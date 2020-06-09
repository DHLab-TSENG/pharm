#' Calculate subjects' ddd in a period
#'
#' @param case data.frame include subjects' id, dispensing date, drug ATC code, daily dosage, duration
#' @param index_day observation day
#' @param expo_range_before days before observation day
#' @param expo_range_after days after observation day
#' @param idColName a colum for subject's id
#' @param DispenseDateColName a colum for dispensing
#' @param DaysSupplyColName a colum for supply day
#' @param DailyDosageColName a colum for daily dosage
#' @export
calDDDs.range <- function(case,
                          index_dayColName = Index_Day,
                          expo_range_before = 36000,
                          expo_range_after = 36000,
                          idColName = MemberId,
                          AtcCodeColName = ATC,
                          DispenseDateColName = DispenseDate,
                          DaysSupplyColName = DaysSupply,
                          DailyDosageColName = DailyDosage){

  colnames(case)[colnames(case)==deparse(substitute(index_dayColName))] <- "Index_Day"
  colnames(case)[colnames(case)==deparse(substitute(idColName))] <- "MemberId"
  colnames(case)[colnames(case)==deparse(substitute(AtcCodeColName))] <- "ATC"
  colnames(case)[colnames(case)==deparse(substitute(DispenseDateColName))] <- "DispenseDate"
  colnames(case)[colnames(case)==deparse(substitute(DaysSupplyColName))] <- "DaysSupply"
  colnames(case)[colnames(case)==deparse(substitute(DailyDosageColName))] <- "DailyDosage"

  #index_day <- as.Date(gsub("\\s+", "", deparse(substitute(index_day))))
  case <- get.ddd(case)
  case <- arrange(case, MemberId, DispenseDate)
  case <- data.table(case)
  case[, Start_day := Index_Day-expo_range_before]
  #case[, index_day := index_day]
  case[, End_day := Index_Day+expo_range_after]
  #case[, Daily_dosage2 := as.numeric(as.character(strsplit(case$Daily_Dosage, "mg")))]
  case[, Daily_dosage2 := DailyDosage]
  case[, DDD_perday := round(Daily_dosage2/DDD, 2)]

  #DDDs before index
  case[, date3 := as.numeric(Start_day-DispenseDate)]
  case[, date4 := as.numeric(Index_Day-DispenseDate)]
  case[, DDDs_before := if_else(date3<0,
                         if_else(date4>DaysSupply,
                                 DaysSupply*DDD_perday,
                                 if_else(date4>0,
                                         (DaysSupply-date4)*DDD_perday,
                                 0)),
                         if_else(date3>DaysSupply,
                                 0,
                                 (DaysSupply-date3)*DDD_perday)),
       by = MemberId]
  case_before <- case[, sum(DDDs_before), by = MemberId]
  colnames(case_before)[colnames(case_before)=="V1"] <- paste0("DDDs_Before_",expo_range_before,"_Days")

  #DDDs after index
  case[, date3_ := as.numeric(End_day-DispenseDate)]
  case[, date4_ := as.numeric(DispenseDate-Index_Day)]
  case[, date5 := as.numeric((DispenseDate+DaysSupply)-Index_Day)]
  case[, DDDs_after := if_else(date3_>0,
                                if_else(date4_>0,
                                        if_else(date3_>DaysSupply,
                                                DaysSupply*DDD_perday,
                                                date3_*DDD_perday),
                                                if_else(date5>0,
                                                        (DaysSupply-abs(date4_)*DDD_perday),
                                                        0)),
                                0),
       by = MemberId]
  case_after <- case[, sum(DDDs_after), by = MemberId]
  colnames(case_after)[colnames(case_after)=="V1"] <- paste0("DDDs_After_",expo_range_after,"_Days")

  case <- case %>% select(MemberId, Start_day, Index_Day, End_day, DDDs_before, DDDs_after)
  case_bf_af <- inner_join(case_before,case_after, by = "MemberId")
  case_temp <- case %>% select(MemberId, Start_day, Index_Day, End_day)
  case <- inner_join(case_temp,case_bf_af, by = "MemberId")
  case <- unique(case)

  colnames(case)[colnames(case)== "MemberId"] <- deparse(substitute(idColName))
  colnames(case)[colnames(case)== "Index_Day"] <- deparse(substitute(index_dayColName))
  colnames(case)[colnames(case)=="ATC"] <- deparse(substitute(AtcCodeColName))
  colnames(case)[colnames(case)== "DispenseDate"] <- deparse(substitute(DispenseDateColName))
  colnames(case)[colnames(case)== "DaysSupply"] <- deparse(substitute(DaysSupplyColName))
  colnames(case)[colnames(case)== "DailyDosage"] <- deparse(substitute(DailyDosageColName))
  return(case)

}


