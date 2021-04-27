#' Get ATC DDDs value
#'
#' @import dplyr
#' @param atc data.frame include ATC code
#' @export

getDDDs <- function(atc){

  ddd <- atc%>%
    left_join(unique(resATC_DDD), by = c("ATC" = "ATC_CODE") )
  return(ddd)
}
