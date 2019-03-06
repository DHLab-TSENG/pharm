#' Generate Drug Era
#'
#' This can be used to merge pharmacy claims data into drug era with defined window. Exposure days will be cacluated, too.
#'
#' @import dplyr
#' @import data.table
#' @param df data.frame with MemberID ,Drug,DispenseDate ,DaysSupply, or with MemberID ,Drug, StartDate, EndDate
#' @param window allowed gap between pharmacy claims, default is 30
#' @param DrugColName A colum for drug which patient use
#' @param DispenseDateColName A colum for dispense date
#' @param DaysSupplyColName A colum for drug supply days
#' @param StartDateColName A colum for drug start day
#' @param EndDateColName A colum for drug end day
#' @export
#'

get.DrugEra <- function(df, window = 30,
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
    case[, duration2 := shift(DaysSupply,1), by = c("MemberID", "Drug")]
    case[, duration3 := if_else(is.na(duration2), 0, as.double(duration2))]
    case[, Diff := c(1, diff(DispenseDate)), by = c("MemberID", "Drug")]
    case[, gap := if_else(window<(Diff-duration3) , 1, 0)]
    case[, DrugEra := cumsum(gap)+1, by = c("MemberID", "Drug")]
    case[, DrugEraStartDate := DispenseDate[1], by = c("MemberID", "Drug", "DrugEra")]
    case[, DrugEraEndDate := DispenseDate[.N]+DaysSupply[.N], by = c("MemberID", "Drug", "DrugEra")]
    case[, ExposureDays := DrugEraEndDate - DrugEraStartDate]
    case[, SupplyDays := sum(DaysSupply), by = c("MemberID", "Drug", "DrugEra")]
    case <- select(case, MemberID, Drug, DispenseDate, DrugEra, DrugEraStartDate, DrugEraEndDate, ExposureDays, SupplyDays)

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
    case[, gap := if_else((as.numeric(as.Date(StartDate) - as.Date(preEndDate2)))>window, 1, 0)]
    case[, DrugEra := cumsum(gap)+1, by = c("MemberID", "Drug")]
    case[, DrugEraStartDate := StartDate[1], by = c("MemberID", "Drug", "DrugEra")]
    case[, DrugEraEndDate := EndDate[.N], by = c("MemberID", "Drug", "DrugEra")]
    case[, ExposureDays := as.numeric(as.Date(DrugEraEndDate) - as.Date(DrugEraStartDate))]
    case[, SupplyDays := as.numeric(as.Date(DrugEraEndDate) - as.Date(DrugEraStartDate))]

    case <- select(case, MemberID, Drug, StartDate, EndDate, DrugEra, DrugEraStartDate, DrugEraEndDate, ExposureDays, SupplyDays)
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
