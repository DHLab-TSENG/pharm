#' Get ATC 1 level histogram plot
#' @import data.table
#' @import ggplot2
#' @param df data.frame include ATC code
#' @param ATCColName A colum for ATC of df
#' @export
get.ATC1LevelPlot <- function(df, ATCColName = ATC){

  colnames(df)[colnames(df)==deparse(substitute(ATCColName))] <- "ATC"
  df$ATC <- as.character(df$ATC)
  df <- data.table(df)
  df[, ATC1Level := if_else(ATC == "BPCK" | ATC == "GPCK", ATC, substr(ATC, 1, 1))]
  ggplot(df,
         aes(x=ATC1Level)) + geom_bar(color="darkblue",
                                            fill="lightblue",
                                            stat = "count")

}
