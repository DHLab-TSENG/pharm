#' Generate Drug Era
#'
#' This can be used to merge pharmacy claims data into drug era with defined window. Exposure days will be cacluated, too.
#'
#' @import dplyr
#' @param df data.frame with MemberID ,Drug,DispenseDate ,DaysSupply, or with MemberID ,Drug, StartDate, EndDate
#' @param window allowed gap between pharmacy claims, default is 30
#' @param DrugColName A colum for drug which patient use
#' @param DispenseDateColName A colum for dispense date
#' @param DaysSupplyColName A colum for drug supply days
#' @param StartDateColName A colum for drug start day
#' @param EndDateColName A colum for drug end day
#' @details
#' This function provides user to concatenate continuous prescription medications into a single prescription length. An event of the time interval is according to the prescription's dispense date plus the prescription's drug supply days. There are two calculation models:
#'
#' 1.If the time interval gap between the patient taking the drug exceeds the persistent window, these two events are regarded as two different drug era.
#'
#' 2.If the time interval gap between the patient taking the drug less than the persistent window, these two events are regarded as same drug era.
#'
#' #This can be used to merge pharmacy claims data into drug era with defined window. Exposure days will be cacluated, too.
#' @examples
#' #sample of calculating drug era.
#' getDrugEra(MemberIDColName = MemberId,sample_data_subset,DrugColName = NationalDrugCode,DispenseDateColName = DispenseDate,DaysSupplyColName = DaysSupply)
#' @export
#@import data.table

getDrugEra <- function(df, window = 30,
                        MemberIDColName = MemberID,
                        DrugColName = Drug,
                        DispenseDateColName ,
                        DaysSupplyColName ,
                        StartDateColName ,
                        EndDateColName ){

  if(!missing(DispenseDateColName) & !missing(DaysSupplyColName) & missing(StartDateColName) & missing(EndDateColName)){

    colnames(df)[colnames(df)==deparse(substitute(MemberIDColName))] <- "MemberID"
    colnames(df)[colnames(df)==deparse(substitute(DrugColName))] <- "Drug"
    colnames(df)[colnames(df)==deparse(substitute(DispenseDateColName))] <- "DispenseDate"
    colnames(df)[colnames(df)==deparse(substitute(DaysSupplyColName))] <- "DaysSupply"

    case <- df
    case <- arrange(case, MemberID, Drug, DispenseDate) %>% as.data.table()
    case[, DispenseDate := as.Date(DispenseDate)]
    case[, duration2 := shift(DaysSupply,1), by = c("MemberID", "Drug")]
    case[, duration3 := if_else(is.na(duration2), 0, as.double(duration2))]
    case[, Diff := c(1, diff(DispenseDate)), by = c("MemberID", "Drug")]
    case[, gap := if_else(window<(Diff-duration3) , 1, 0), by = c("MemberID", "Drug")]
    case[, DrugEra := cumsum(gap)+1, by = c("MemberID", "Drug")]
    case[, duration4 := shift(DaysSupply,1), by = c("MemberID", "Drug", "DrugEra")]
    case[, duration5 := if_else(is.na(duration4), 0, as.double(duration4))]
    case[, Diff2 := c(0, diff(DispenseDate)), by = c("MemberID", "Drug", "DrugEra")]
    case[, Gap := Diff2-duration5, by = c("MemberID", "Drug", "DrugEra")]
    case[, DrugEraStartDate := DispenseDate[1], by = c("MemberID", "Drug", "DrugEra")]
    case[, DrugEraEndDate := DispenseDate[.N]+DaysSupply[.N], by = c("MemberID", "Drug", "DrugEra")]
    case[, ExposureDays := DrugEraEndDate - DrugEraStartDate]
    case[, SupplyDays := sum(DaysSupply), by = c("MemberID", "Drug", "DrugEra")]
    case <- select(case, MemberID, Drug, DispenseDate, DrugEra, DrugEraStartDate, DrugEraEndDate, Gap, ExposureDays, SupplyDays)

    DateWithDrugEra <- inner_join(df, case, by = c("MemberID", "DispenseDate", "Drug")) %>% arrange(MemberID, Drug, DrugEra)

    colnames(DateWithDrugEra)[colnames(DateWithDrugEra)=="MemberID"] <- deparse(substitute(MemberIDColName))
    colnames(DateWithDrugEra)[colnames(DateWithDrugEra)=="Drug"] <- deparse(substitute(DrugColName))
    colnames(DateWithDrugEra)[colnames(DateWithDrugEra)=="DispenseDate"] <- deparse(substitute(DispenseDateColName))
    colnames(DateWithDrugEra)[colnames(DateWithDrugEra)=="DaysSupply"] <- deparse(substitute(DaysSupplyColName))
    DateWithDrugEra

  }else if(missing(DispenseDateColName) & missing(DaysSupplyColName) & !missing(StartDateColName) & !missing(EndDateColName)){

    colnames(df)[colnames(df)==deparse(substitute(MemberIDColName))] <- "MemberID"
    colnames(df)[colnames(df)==deparse(substitute(DrugColName))] <- "Drug"
    colnames(df)[colnames(df)==deparse(substitute(StartDateColName))] <- "StartDate"
    colnames(df)[colnames(df)==deparse(substitute(EndDateColName))] <- "EndDate"

    case <- df
    case <- arrange(case, MemberID, Drug, StartDate) %>% as.data.table()
    case[, preEndDate := shift(EndDate,1), by = c("MemberID", "Drug")]
    case[, preEndDate2 := if_else(is.na(preEndDate), StartDate, preEndDate)]
    case[, gap := if_else((as.numeric(as.Date(StartDate) - as.Date(preEndDate2)))>window, 1, 0), by = c("MemberID", "Drug")]
    case[, Gap := as.numeric(as.Date(StartDate) - as.Date(preEndDate2)), by = c("MemberID", "Drug")]
    case[, DrugEra := cumsum(gap)+1, by = c("MemberID", "Drug")]
    case[, DrugEraStartDate := StartDate[1], by = c("MemberID", "Drug", "DrugEra")]
    case[, DrugEraEndDate := EndDate[.N], by = c("MemberID", "Drug", "DrugEra")]
    case[, ExposureDays := as.numeric(as.Date(DrugEraEndDate) - as.Date(DrugEraStartDate))]
    case[, SupplyDays := as.numeric(as.Date(DrugEraEndDate) - as.Date(DrugEraStartDate))]

    case <- select(case, MemberID, Drug, StartDate, EndDate, DrugEra, DrugEraStartDate, DrugEraEndDate, Gap, ExposureDays, SupplyDays)
    DateWithDrugEra <- inner_join(df, case, by = c("MemberID", "StartDate", "EndDate", "Drug")) %>% arrange(MemberID, Drug, DrugEra)

    colnames(DateWithDrugEra)[colnames(DateWithDrugEra)=="MemberID"] <- deparse(substitute(MemberIDColName))
    colnames(DateWithDrugEra)[colnames(DateWithDrugEra)=="Drug"] <- deparse(substitute(DrugColName))
    colnames(DateWithDrugEra)[colnames(DateWithDrugEra)=="StartDate"] <- deparse(substitute(StartDateColName))
    colnames(DateWithDrugEra)[colnames(DateWithDrugEra)=="EndDate"] <- deparse(substitute(EndDateColName))
    DateWithDrugEra

  }else{
    warning("Please check your input value")
  }
}
