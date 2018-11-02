#' Calculate subjects' ddd
#'
#' @import dplyr
#' @import data.table
#' @param case data.frame include subjects' id, dispensing date, drug ATC code, daily dosage, duration
#' @export

calDDDs <- function(case){



  case <- get.ddd(case)
  case <- arrange(case, patient_id, Dispensing)
  case <- data.table(case)
  case[, Daily_dosage2 := as.numeric(as.character(strsplit(case$Daily_dosage, "mg")))]
  case[, Diff := c(NA, diff(Dispensing)), by = patient_id]
  case[, DDD_perday := round(Daily_dosage2/DDD, 2)]
  case[, duration2 := shift(duration,1), by = patient_id]
  case[, DDD_perday2 := shift(DDD_perday,1), by = patient_id]
  case[, DDDsA := if_else(Diff>duration2,
                          duration2*DDD_perday2,
                          Diff*DDD_perday2, missing = 0),by = patient_id]

  case[, DDDs := cumsum(DDDsA), by = patient_id]
  case <- case %>% select(patient_id, Dispensing, ATC, Daily_dosage, duration, DDDs)
  return(case)

}

ddd.test.df <- data.frame(patient_id = c("1", "1", "1", "2", "2"),
                          Dispensing = as.Date(c("2013-03-21", "2013-04-18", "2013-05-25", "2013-03-27", "2013-04-23")),
                          ATC = c("R01AA05", "R01AA05", "R01AA05", "R06AX12", "R06AX12"),
                          Daily_dosage = c("0.5mg", "0.4mg", "0.5mg", "0.1mg", "0.12mg"),
                          duration = c(30, 25, 30, 25, 30),
                          stringsAsFactors = FALSE
)

