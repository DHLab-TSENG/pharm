
# check the total object number of result
test_that("getRxcuiViaMaytreat -> short Error", {expect_output(str(Esophagitis_List), "28 obs")})
# check the value of result
test_that("getRxcuiViaMaytreat -> short Error", {expect_equal(sqrt(2) ^ 2, 2)})
# check the return type of result
test_that("getRxcuiViaMaytreat -> decimal Type", {expect_equal(as.character(Esophagitis_List$RxCui[1]), "1792108")})



# check the result list value
i <- 1
Testdf <- data.table("RxCui" = numeric(), "Name" = numeric(), "MinConcept.Id" = numeric(), "MinConcept.Name"= numeric())
while(is.null(Esophagitis_List$RxCui[i]) == FALSE){
  Testdf <- rbind(c(Esophagitis_List$RxCui[i],Esophagitis_List$Name[i],Esophagitis_List$MinConcept.Id[i],Esophagitis_List$MinConcept.Name[i]))
  i <- i+1
}
Testdf
Esophagitis_List <- getRxcuiViaMaytreat("esophagitis")
