get.ddd <- function(atc){

  ddd <- atc%>%
    left_join(resATC_DDD, by = c("ATC" = "ATC_CODE") )
  return(ddd)
}
