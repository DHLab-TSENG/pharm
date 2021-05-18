#' @rdname getDrugEraPlot
#' @export

getDrugEraPlot <- function(df,
                            MemberIDColName = MemberID,
                            DrugColName,
                            DrugEraColName = DrugEra,
                            SupplyDaysColName = SupplyDays){

  colnames(df)[colnames(df)==deparse(substitute(MemberIDColName))] <- "MemberID"
  colnames(df)[colnames(df)==deparse(substitute(DrugColName))] <- "Drug"
  colnames(df)[colnames(df)==deparse(substitute(DrugEraColName))] <- "DrugEra"
  colnames(df)[colnames(df)==deparse(substitute(SupplyDaysColName))] <- "SupplyDays"

  tempDF <- data.table(df)
  tempDF[, DispenseTimes := as.character(.N), by = c("MemberID", "Drug", "DrugEra")]
  tempDF$DispenseTimes <- as.factor(tempDF$DispenseTimes)
  tempDF <- select(tempDF, MemberID, DrugEra, SupplyDays, DispenseTimes) %>% unique()
  breaks <- c(seq(0, sort(tempDF$SupplyDays, T)[1], 28), round(sort(tempDF$SupplyDays, T)[1]/28)*28+28)
  labels <- c("1-28")
  for(i in 2:(length(breaks)-1)){
    labels <- c(labels, paste0((i-1)*28+1, "-", i*28))
  }
  tempDF <-  mutate(tempDF, SupplyDaysRange = cut(SupplyDays, breaks = breaks, labels = labels))
  tempDF$DispenseTimes <- factor(tempDF$DispenseTimes, levels = rev(levels(tempDF$DispenseTimes)))
  ggplot(tempDF, aes(SupplyDaysRange, fill = DispenseTimes)) +
    geom_bar(position = "stack", colour="black") +
    geom_text(stat='count',aes(label=..count..),position=position_stack(0.5), color="black", size=3.5) +
    theme_bw() + theme(panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank())+
    labs(x = "Total Supply Days",
         y = "Drug Era") +
    theme(axis.text.x = element_text(angle = 45, vjust = 0.5)) +
    scale_colour_grey(name = "Dispense\nTime",aesthetics = "fill", start = 0.1, end = 0.99)
}
