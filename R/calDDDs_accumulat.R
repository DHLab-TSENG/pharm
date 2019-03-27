#' Calculate subjects' acculated ddd before last dispensing
#'
#' @import dplyr
#' @import data.table
#' @param case data.frame include subjects' id, dispensing date, drug ATC code, daily dosage, duration
#' @export

calDDDs.accumulat <- function(case,
                              PatientIdColName = Patient_ID,
                              DispensingColName = Dispensing,
                              AtcCodeColName = ATC_CODE,
                              DailyDosageColName = Daily_Dosage,
                              DurationColName = Duration){

  colnames(case)[colnames(case)==deparse(substitute(PatientIdColName))] <- "Patient_ID"
  colnames(case)[colnames(case)==deparse(substitute(DispensingColName))] <- "Dispensing"
  colnames(case)[colnames(case)==deparse(substitute(AtcCodeColName))] <- "ATC_CODE"
  colnames(case)[colnames(case)==deparse(substitute(DailyDosageColName))] <- "Daily_Dosage"
  colnames(case)[colnames(case)==deparse(substitute(DurationColName))] <- "Duration"

  case <- get.ddd(case)
  case <- arrange(case, Patient_ID, Dispensing)
  case <- data.table(case)
  case[, Daily_dosage2 := as.numeric(as.character(strsplit(case$Daily_Dosage, "mg")))]
  case[, DDD_perday := round(Daily_dosage2/DDD, 2)]
  case[, DDDs := Duration*DDD_perday]
  case <- case %>% select(Patient_ID, Dispensing, ATC_CODE, Daily_Dosage, Duration, DDDs)
  case <- case[, sum(DDDs), by = Patient_ID]
  colnames(case)[colnames(case)=="V1"] <- "DDDs"

  colnames(case)[colnames(case)=="Patient_ID"] <- deparse(substitute(PatientIdColName))
  colnames(case)[colnames(case)=="Dispensing"] <- deparse(substitute(DispensingColName))
  colnames(case)[colnames(case)=="ATC_CODE"] <- deparse(substitute(AtcCodeColName))
  colnames(case)[colnames(case)=="Daily_Dosage"] <- deparse(substitute(DailyDosageColName))
  colnames(case)[colnames(case)=="Duration"] <- deparse(substitute(DurationColName))
  return(case)

}

