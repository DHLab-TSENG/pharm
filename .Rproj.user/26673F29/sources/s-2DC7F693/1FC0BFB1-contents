#' Calculate subjects' acculated ddd before last dispensing
#'
#' @import dplyr
#' @import data.table
#' @param case data.frame include subjects' id, dispensing date, drug ATC code, daily dosage, duration
#' @export

calDDDs.accumulat <- function(case,
                              PatientIdColName = MemberId,
                              DispensingColName = DispenseDate,
                              AtcCodeColName = ATC,
                              DailyDosageColName = DailyDosage,
                              DurationColName = DaysSupply){

  colnames(case)[colnames(case)==deparse(substitute(PatientIdColName))] <- "MemberId"
  colnames(case)[colnames(case)==deparse(substitute(DispensingColName))] <- "DispenseDate"
  colnames(case)[colnames(case)==deparse(substitute(AtcCodeColName))] <- "ATC"
  colnames(case)[colnames(case)==deparse(substitute(DailyDosageColName))] <- "DailyDosage"
  colnames(case)[colnames(case)==deparse(substitute(DurationColName))] <- "DaysSupply"

  case <- get.ddd(case)
  case <- arrange(case, MemberId, DispenseDate)
  case <- data.table(case)
  #case[, Daily_dosage2 := as.numeric(as.character(strsplit(case$Daily_Dosage, "mg")))]
  case[, Daily_dosage2 := DailyDosage]
  case[, DDD_perday := round(Daily_dosage2/DDD, 2)]
  case[, DDDs := DaysSupply*DDD_perday]
  case <- case %>% select(MemberId, DispenseDate, ATC, DailyDosage, DaysSupply, DDDs)
  case <- case[, sum(DDDs), by = MemberId]
  colnames(case)[colnames(case)=="V1"] <- "DDDs"

  colnames(case)[colnames(case)=="MemberId"] <- deparse(substitute(PatientIdColName))
  colnames(case)[colnames(case)=="DispenseDate"] <- deparse(substitute(DispensingColName))
  colnames(case)[colnames(case)=="ATC"] <- deparse(substitute(AtcCodeColName))
  colnames(case)[colnames(case)=="DailyDosage"] <- deparse(substitute(DailyDosageColName))
  colnames(case)[colnames(case)=="DaysSupply"] <- deparse(substitute(DurationColName))
  return(case)

}

