#' Get dispensing plot
#' @import dplyr
#' @import ggplot2
#' @param df data.frame include dispense info
#' @param MemberIDColName A colum for memebr id
#' @param Member A colum for the member who be plot
#' @param DrugColName A colum for drug name
#' @param DispenseDateColName A colum for dispense date
#' @param DaysSupplyColName A colum for day supplys
#' @param TimeInterval A colum for time interval
#' @param Unit A colum for time unit
#' @details
#' This function provides user to selecting specific patients may visualize their medication history in a custom interval period or specific date.
#' @examples
#' #sample of getting dispensing plot.
#' getDispensingPlot(df = sample_data_subset, MemberIDColName = MemberId,DrugColName = NationalDrugCode,DispenseDateColName = Dispensing,Member = 42, TimeInterval = 20, Unit = day)
#' @export
#@import data.table

getDispensingPlot <- function(df,
                               MemberIDColName = MemberID,
                               Member,
                               DrugColName = NationalDrugCode,
                               DispenseDateColName = Dispensing,
                               DaysSupplyColName = DaysSupply,
                               TimeInterval = 1,
                               Unit = month){

  colnames(df)[colnames(df)==deparse(substitute(MemberIDColName))] <- "MemberID"
  colnames(df)[colnames(df)==deparse(substitute(DrugColName))] <- "Drug"
  colnames(df)[colnames(df)==deparse(substitute(DispenseDateColName))] <- "DispenseDate"
  colnames(df)[colnames(df)==deparse(substitute(DaysSupplyColName))] <- "DaysSupply"

  Time_interval <- paste(TimeInterval, deparse(substitute(Unit)))
  df <- filter(df, MemberID == Member) %>% as.data.table()
  df[, number := 1:.N, by = "Drug"]
  df[, EndDate := DispenseDate + DaysSupply]
  df[, EndDate2 := DispenseDate + DaysSupply]
  df[, countN := .N, by = "Drug"]
  df[number == countN, EndDate2 := NA]
  df[, numberUp := number+0.6]
  df[, numberDown := number+0.4]
  df[, nextDispensing := shift(DispenseDate, fill = NA, type = "lead"), by = "Drug"]
  df[, gap := as.numeric(nextDispensing-EndDate)]
  df[, xmid := DispenseDate + round(DaysSupply/2)]
  df[, xmid2 := EndDate + (round(as.numeric(nextDispensing-EndDate)/2))]
  df[, ymid := number+0.7]

  ggplot(df) +
    geom_rect(aes(xmin = DispenseDate,
                  xmax = EndDate,
                  ymin = number-0.2,
                  ymax = number+0.2), fill = "lightblue")+
    labs(x = "Date",
         y = "Dispensing Times")+
    scale_x_date(date_breaks = Time_interval)+
    geom_text(aes(x = xmid, y = number, label = DaysSupply), na.rm = T)+
    geom_text(aes(x = xmid2, y = ymid, label = gap), na.rm = T)+
    geom_segment(aes(x = EndDate,
                     y = number+0.5,
                     xend = nextDispensing,
                     yend = number+0.5), na.rm = T,
                 size = 1) +
    geom_segment(aes(x = EndDate2,
                     y = numberUp,
                     xend = EndDate2,
                     yend = numberDown), na.rm = T,
                 size = 1) +
    geom_segment(aes(x = nextDispensing,
                     y = numberUp,
                     xend = nextDispensing,
                     yend = numberDown), na.rm = T,
                 size = 1)+
    theme_bw() + theme(panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank()) +
    scale_y_continuous(breaks= c(1:nrow(df))) +
    theme(axis.text.x = element_text(angle = 45, vjust = 0.5)) + facet_grid(rows = vars(Drug))

}
