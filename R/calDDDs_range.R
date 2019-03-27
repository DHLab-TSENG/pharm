#' Calculate subjects' ddd in a period
#'
#' @import dplyr
#' @import data.table
#' @param case data.frame include subjects' id, dispensing date, drug ATC code, daily dosage, duration
#' @param index_day observation day
#' @param expo_range_before days before observation day
#' @param expo_range_after days after observation day
#' @param idColName a colum for subject's id
#' @param DispensingColName a colum for dispensing
#' @param SupplyDayColName a colum for supply day
#' @param DailyDosageColName a colum for daily dosage
#' @export

calDDDs.range <- function(case,
                          index_dayColName = Index_Day,
                          expo_range_before = 36000,
                          expo_range_after = 36000,
                          idColName = Patient_ID,
                          DispensingColName = Dispensing,
                          SupplyDayColName = Duration,
                          DailyDosageColName = Daily_Dosage){

  colnames(case)[colnames(case)==deparse(substitute(index_dayColName))] <- "Index_Day"
  colnames(case)[colnames(case)==deparse(substitute(idColName))] <- "Patient_ID"
  colnames(case)[colnames(case)==deparse(substitute(DispensingColName))] <- "Dispensing"
  colnames(case)[colnames(case)==deparse(substitute(SupplyDayColName))] <- "Duration"
  colnames(case)[colnames(case)==deparse(substitute(DailyDosageColName))] <- "Daily_Dosage"

  #index_day <- as.Date(gsub("\\s+", "", deparse(substitute(index_day))))
  case <- get.ddd(case)
  case <- arrange(case, Patient_ID, Dispensing)
  case <- data.table(case)
  case[, start_day := Index_Day-expo_range_before]
  #case[, index_day := index_day]
  case[, end_day := Index_Day+expo_range_after]
  case[, Daily_dosage2 := as.numeric(as.character(strsplit(case$Daily_Dosage, "mg")))]
  case[, DDD_perday := round(Daily_dosage2/DDD, 2)]

  #DDDs before index
  case[, date3 := as.numeric(start_day-Dispensing)]
  case[, date4 := as.numeric(Index_Day-Dispensing)]
  case[, DDDs_before := if_else(date3<0,
                         if_else(date4>Duration,
                                 Duration*DDD_perday,
                                 if_else(date4>0,
                                         (Duration-date4)*DDD_perday,
                                 0)),
                         if_else(date3>Duration,
                                 0,
                                 (Duration-date3)*DDD_perday)),
       by = Patient_ID]
  case_before <- case[, sum(DDDs_before), by = Patient_ID]
  colnames(case_before)[colnames(case_before)=="V1"] <- paste0("DDDs_Before_",expo_range_before,"_Days")

  #DDDs after index
  case[, date3_ := as.numeric(end_day-Dispensing)]
  case[, date4_ := as.numeric(Dispensing-Index_Day)]
  case[, date5 := as.numeric((Dispensing+Duration)-Index_Day)]
  case[, DDDs_after := if_else(date3_>0,
                                if_else(date4_>0,
                                        if_else(date3_>Duration,
                                                Duration*DDD_perday,
                                                date3_*DDD_perday),
                                                if_else(date5>0,
                                                        (Duration-abs(date4_)*DDD_perday),
                                                        0)),
                                0),
       by = Patient_ID]
  case_after <- case[, sum(DDDs_after), by = Patient_ID]
  colnames(case_after)[colnames(case_after)=="V1"] <- paste0("DDDs_After_",expo_range_after,"_Days")

  case <- case %>% select(Patient_ID, start_day, Index_Day, end_day, DDDs_before, DDDs_after)
  case_bf_af <- inner_join(case_before,case_after, by = "Patient_ID")
  case_temp <- case %>% select(Patient_ID, start_day, Index_Day, end_day)
  case <- inner_join(case_temp,case_bf_af, by = "Patient_ID")
  case <- unique(case)

  colnames(case)[colnames(case)== "Patient_ID"] <- deparse(substitute(idColName))
  colnames(case)[colnames(case)== "Index_Day"] <- deparse(substitute(index_dayColName))
  colnames(case)[colnames(case)== "Dispensing"] <- deparse(substitute(DispensingColName))
  colnames(case)[colnames(case)== "Duration"] <- deparse(substitute(SupplyDayColName))
  colnames(case)[colnames(case)== "Daily_Dosage"] <- deparse(substitute(DailyDosageColName))
  return(case)

}


