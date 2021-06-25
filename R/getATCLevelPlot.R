#' @rdname getATCLevelPlot
#' @export

getATCLevelPlot <- function(df, ATCColName = ATC, level = 1) {

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
