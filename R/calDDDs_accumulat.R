
calDDDs.accumulat <- function(case){
  case <- get.ddd(case)
  case <- arrange(case, patient_id, Dispensing)
  case <- data.table(case)
  case[, Daily_dosage2 := as.numeric(as.character(strsplit(case$Daily_dosage, "mg")))]
  case[, DDD_perday := round(Daily_dosage2/DDD, 2)]
  case[, DDDs := duration*DDD_perday]
  case <- case %>% select(patient_id, Dispensing, ATC, Daily_dosage, duration, DDDs)
  case <- case[, sum(DDDs), by = patient_id]
  colnames(case)[colnames(case)=="V1"] <- "DDDs"
  return(case)

}

