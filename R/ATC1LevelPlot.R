#' Get ATC 1 level histogram plot

#' @importFrom data.table::last()
#' @importFrom data.table::first()
#' @importFrom data.table::between()
#' @import ggplot2
#' @param df data.frame include ATC code
#' @param ATCColName A colum for ATC of df
#' @export
get.ATC1LevelPlot <- function(df, ATCColName = ATC) {
  colnames(df)[colnames(df) == deparse(substitute(ATCColName))] <-
    "ATC"
  df$ATC <- as.character(df$ATC)
  df <- data.table(df)
  df[, ATC1Level := if_else(ATC == "BPCK" |
                              ATC == "GPCK", ATC, substr(ATC, 1, 1))]
  df <- filter(df, ATC1Level != "BPCK" & ATC1Level != "GPCK" & !is.na(ATC1Level))
  ggplot(df,
         aes(x = ATC1Level)) +
    geom_bar(color = "darkblue",
             fill = "lightblue",
             stat = "count") +
    theme_bw() + theme(panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank())

}
