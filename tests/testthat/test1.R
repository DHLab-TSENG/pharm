
i <- 1
Testdf <- data.table("RxCui" = numeric(), "Name" = numeric(), "MinConcept.Id" = numeric(), "MinConcept.Name"= numeric())

while(is.null(Esophagitis_List$RxCui[i]) == FALSE){
  
  Testdf <- rbind(c(Esophagitis_List$RxCui[i],Esophagitis_List$Name[i],Esophagitis_List$MinConcept.Id[i],Esophagitis_List$MinConcept.Name[i]))
  i <- i+1
}

Testdf

Esophagitis_List <- getRxcuiViaMaytreat("esophagitis")
test_that("getRxcuiViaMaytreat -> short Error",{expect_output(str(Esophagitis_List), "28 obs")})
test_that("getRxcuiViaMaytreat -> short Error",{expect_output(str(Esophagitis_List), "28 obs")})
test_that("getRxcuiViaMaytreat -> short Error",{expect_equal(sqrt(2) ^ 2, 2)})

