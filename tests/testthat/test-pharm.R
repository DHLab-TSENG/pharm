# sample data Esophagitis test

# getRxcuiViaMaytreat
# check the total object number of result
test_that("getRxcuiViaMaytreat -> short Error", {expect_output(str(Esophagitis_List), "28 obs")})
# check the total column number of result
test_that("getRxcuiViaMaytreat -> short Error", {expect_output(str(Esophagitis_List), "4 variables")})
# check all column name of result
test_that("getRxcuiViaMaytreat -> short Error", {expect_named(Esophagitis_List, c('RxCui', 'Name', 'MinConcept.Id', 'MinConcept.Name'))})
# check the return value of result
test_that("getRxcuiViaMaytreat -> decimal Type", {expect_equal(as.character(Esophagitis_List$RxCui[1]), "1792108")})
test_that("getRxcuiViaMaytreat -> decimal Type", {expect_equal(as.character(Esophagitis_List$RxCui[28]), "47618")})



# getSbdRxcuiViaRxcui
# check the total object number of result
test_that("getSbdRxcuiViaRxcui -> short Error", {expect_output(str(Esophagitis_SBD_SCD_List), "36 obs")})
# check the total column number of result
test_that("getSbdRxcuiViaRxcui -> short Error", {expect_output(str(Esophagitis_SBD_SCD_List), "5 variables")})
# check all column name of result
test_that("getSbdRxcuiViaRxcui -> short Error", {expect_named(Esophagitis_SBD_SCD_List, c('RxCui', 'Name', 'MinConcept.Id', 'MinConcept.Name', 'SBD.rxcui'))})
# check the return value of result
test_that("getSbdRxcuiViaRxcui -> decimal Type", {expect_equal(as.character(Esophagitis_SBD_SCD_List$RxCui[1]), "7646")})
test_that("getSbdRxcuiViaRxcui -> decimal Type", {expect_equal(as.character(Esophagitis_SBD_SCD_List$RxCui[36]), "7646")})



# getNdcViaSbdRxcui
# check the total object number of result
test_that("getNdcViaSbdRxcui -> short Error", {expect_output(str(Esophagitis_NDC_List), "1 obs")})
# check the total column number of result
test_that("getNdcViaSbdRxcui -> short Error", {expect_output(str(Esophagitis_NDC_List), "6 variables")})
# check all column name of result
test_that("getNdcViaSbdRxcui -> short Error", {expect_named(Esophagitis_NDC_List, c('RxCui', 'Name', 'MinConcept.Id', 'MinConcept.Name', 'SBD.rxcui', 'NDC'))})
# check the return value of result
test_that("getNdcViaSbdRxcui -> decimal Type", {expect_equal(as.character(Esophagitis_NDC_List$RxCui[1]), "7646")})



# getRxcuiViaNdc
# check the total object number of result
test_that("getRxcuiViaNdc -> short Error", {expect_output(str(sample_data_subset_rxcui), "8 obs")})
# check the total column number of result
test_that("getRxcuiViaNdc -> short Error", {expect_output(str(sample_data_subset_rxcui), "7 variables")})
# check all column name of result
test_that("getRxcuiViaNdc -> short Error", {expect_named(sample_data_subset_rxcui, c('MemberId', 'DispenseDate', 'NationalDrugCode', 'Quantity', 'DaysSupply', 'RxCui', 'ndcStatus'))})
# check the return value of result
test_that("getRxcuiViaNdc -> decimal Type", {expect_equal(as.character(sample_data_subset_rxcui$MemberId[1]), "1")})
test_that("getRxcuiViaNdc -> decimal Type", {expect_equal(as.character(sample_data_subset_rxcui$MemberId[8]), "42")})



# getAtcViaRxCui
# check the total object number of result
test_that("getAtcViaRxCui -> short Error", {expect_output(str(sample_data_subset_atc), "8 obs")})
# check the total column number of result
test_that("getAtcViaRxCui -> short Error", {expect_output(str(sample_data_subset_atc), "8 variables")})
# check all column name of result
test_that("getAtcViaRxCui -> short Error", {expect_named(sample_data_subset_atc, c('MemberId', 'DispenseDate', 'NationalDrugCode', 'Quantity', 'DaysSupply', 'RxCui', 'ndcStatus', 'ATC'))})
# check the return value of result
test_that("getAtcViaRxCui -> decimal Type", {expect_equal(as.character(sample_data_subset_atc$ATC[1]), "A02BC05")})
test_that("getAtcViaRxCui -> decimal Type", {expect_equal(as.character(sample_data_subset_atc$ATC[8]), "A02BC05")})



# getRxCuiViaAtc
# check the total object number of result
test_that("getRxCuiViaAtc -> short Error", {expect_output(str(sample_atc_rxcui), "5 obs")})
# check the total column number of result
test_that("getRxCuiViaAtc -> short Error", {expect_output(str(sample_atc_rxcui), "2 variables")})
# check all column name of result
test_that("getRxcuiViaAtc -> short Error", {expect_named(sample_atc_rxcui, c('ATC', 'RxCui'))})
# check the return value of result
test_that("getRxcuiViaAtc -> decimal Type", {expect_equal(as.character(sample_atc_rxcui$ATC[1]), "G04BX06")})
test_that("getRxcuiViaAtc -> decimal Type", {expect_equal(as.character(sample_atc_rxcui$ATC[5]), "A12CC05")})




# getNHINoViaRCFNo
# check the total object number of result
test_that("getNHINoViaRCFNo -> short Error", {expect_output(str(sample_data_subset_atc), "5 obs")})
# check the total column number of result
test_that("getNHINoViaRCFNo -> short Error", {expect_output(str(sample_data_subset_atc), "2 variables")})
# check all column name of result
test_that("getNHINoViaRCFNo -> short Error", {expect_named(sample_data_subset_atc, c('ATC', 'RxCui'))})
# check the return value of result
test_that("getNHINoViaRCFNo -> decimal Type", {expect_equal(as.character(sample_data_subset_atc$ATC[1]), "G04BX06")})
test_that("getNHINoViaRCFNo -> decimal Type", {expect_equal(as.character(sample_data_subset_atc$ATC[5]), "A12CC05")})


