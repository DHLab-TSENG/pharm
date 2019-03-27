#' Get ATC code' ddd value
#'
#' @import dplyr
#' @param atc data.frame include ATC code

get.ddd <- function(atc){

  ddd <- atc%>%
    left_join(resATC_DDD, by = c("ATC_CODE" = "ATC_CODE") )
  return(ddd)
}
