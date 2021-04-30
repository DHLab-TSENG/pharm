#' Get ATC level histogram plot
#@import dplyr
#' @import ggplot2
#' @import data.table
#' @param df data.frame include ATC code
#' @param ATCColName A colum for ATC of df
#' @details
#' This function provides user to get Anatomical Therapeutic Chemical Classification System(ATC) level 1 or 2 histogram plot.
#' @examples
#' # sample of getting ATC level 1 histogram plot.
#' getAtcLevelPlot(df = sample_data_ATC1LevelPlot, ATCColName = ATC, level = 1)
#' # sample of getting ATC level 2 histogram plot.
#' getAtcLevelPlot(df = sample_data_ATC1LevelPlot, ATCColName = ATC, level = 2)
#' @export

getAtcLevelPlot <- function(df, ATCColName = ATC, level = 1) {

  colnames(df)[colnames(df) == deparse(substitute(ATCColName))] <-
    "ATC"
  df$ATC <- as.character(df$ATC)
  df <- data.table(df)
  if(level == 1){
    df[, ATC1Level := if_else(ATC == "BPCK" |
                                ATC == "GPCK", ATC, substr(ATC, 1, 1))]
  }else if(level == 2){
    df[, ATC1Level := if_else(ATC == "BPCK" |
                                ATC == "GPCK", ATC, substr(ATC, 1, 3))]
  }else{
    return("Wrong input")
  }

  df <- filter(df, ATC1Level != "BPCK" & ATC1Level != "GPCK" & !is.na(ATC1Level))
  ggplot(df,
         aes(x = ATC1Level)) +
    geom_bar(color = "darkblue",
             fill = "lightblue",
             stat = "count") +
    theme_bw() + theme(panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank())

}
