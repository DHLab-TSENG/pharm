#' Get RxCui via may treat
#'
#' \code{getRxcuiViaMaytreat} is a function to get RxCui via may treat.
#'
#' @name getRxcuiViaMaytreat
#' @import data.table
#' @param strmaytreat user can input an indication name.
#' @return
#' A new data.table \code{maytreat_List} with following columns.
#'
#' \code{RxCui} drug RxCui
#'
#' \code{Name} drug name
#'
#' \code{MinConcept.Id} indication Id
#'
#' \code{MinConcept.Name} indication name
#' @details
#' The data source is from the U.S. Veterans Administration's \code{MED-RT} database. This function provides user to get drug ingredient`s RxCui of the specific indication may treat.
#' @examples
#' # sample of searching an indication - esophagitis.
#' Esophagitis_List <- getRxcuiViaMaytreat("esophagitis")
#' # sample of getting drug RxCui list of esophagitis.
#' head(Esophagitis_List)
NULL



#' Get SBD RxCui via RxCui
#'
#' \code{getSbdRxcuiViaRxcui} is a function to get Semantic Branded Drug(SBD) or Semantic Clinical Drug(SCD) RxCui via RxCui
#'
#' @name getSbdRxcuiViaRxcui
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @import foreach
#' @import doParallel
#' @param df data.frame, a drug ingredient`s RxCui of the specific indication
#' @param RxCuiColName a column name for RxCui of df
#' @param cores number of parallel operation
#' @return
#' A new data.table \code{maytreat_SBD_SCD_List} with following columns.
#'
#' \code{RxCui} drug RxCui
#'
#' \code{Name} drug name
#'
#' \code{MinConcept.Id} indication Id
#'
#' \code{MinConcept.Name} indication name
#'
#' \code{SBD.rxcui} drug SBD RxCui
#' @details
#' After obtaining drug ingredient`s RxCui of the specific indication, user can get all pharmaceutical brand and clinical drug contained these drug ingredients. This function provides user to get SBD or SCD RxCui via ingredient RxCui.
#' @examples
#' # sample of getting SBD or SCD Rxcui via RxCui list of esophagitis.
#' Esophagitis_SBD_SCD_List <- getSbdRxcuiViaRxcui(df = Esophagitis_List[3,],RxCuiColName = RxCui,cores = 2)
#' head(Esophagitis_SBD_SCD_List)
NULL



#' Get NDC via SBD RxCui
#'
#' \code{getNdcViaSbdRxcui} is a function to get National Drug Code(NDC) via Semantic Branded Drug(SBD) RxCui or Semantic Clinical Drug(SCD) RxCui
#'
#' @name getNdcViaSbdRxcui
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @import foreach
#' @import doParallel
#' @param df data.frame, a drug ingredient`s SBD or SCD RxCui of the specific indication
#' @param RxCuiColName a column name for RxCui of df
#' @param cores number of parallel operation
#' @return
#' A new data.table \code{maytreat_NDC_List} with following columns.
#'
#' \code{RxCui} drug RxCui
#'
#' \code{Name} drug name
#'
#' \code{MinConcept.Id} indication Id
#'
#' \code{MinConcept.Name} indication name
#'
#' \code{SBD.rxcui} drug SBD RxCui
#'
#' \code{NDC} drug NDC
#' @details
#' After obtaining drug ingredient`s SBD RxCui of the specific indication, user can get drug NDC contained these drug ingredients. However, a drug will have different packaging and NDC because it comes from different pharmaceutical brands. There will be different NDC for the same drug type but different packaging. Hence, the output results will be one-to-many. A drug RxCui will matche to multiple NDC of pharmaceutical brands, and no corresponding NDC will be \code{NA}. This function provides user to get NDC via SBD or SCD RxCui.
#' @examples
#' # sample of getting NDC via SBD SCD RxCui list of esophagitis
#' Esophagitis_NDC_List <- getNdcViaSbdRxcui(df = Esophagitis_SBD_SCD_List[1,],SBDRxCuiColName = SBD.rxcui,cores = 2)
#' head(Esophagitis_NDC_List)
NULL



#' Get RxCui via NDC
#'
#' \code{getRxcuiViaNdc} is a function to get RxCui via National Drug Code(NDC)
#'
#' @name getRxcuiViaNdc
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @import foreach
#' @import doParallel
#' @param df data.frame, a drug ingredient`s NDC of the specific indication
#' @param NdcColName a column name for NDC of df
#' @param cores number of parallel operation
#' @return
#' A new data.table \code{sample_data_subset_rxcui} with following columns.
#'
#' \code{MemberId} patient Id
#'
#' \code{DispenseDate} patient`s drug dispensed date, and the time interval is from 2025-12-06 to 2038-01-25
#'
#' \code{NationalDrugCode} drug NDC, total of 17,326 different drug codes
#'
#' \code{Quantity} quantity of patient`s drug dispensed
#'
#' \code{DaysSupply} days of patient`s drug dispensed
#'
#' \code{RxCui} drug RxCui
#'
#' \code{ndcStatus} drug NDC status??
#' @details
#' After obtaining \code{sample_data_subset}, user can get drug RxCui contained these drug ingredients. This function provides user to get RxCui via NDC.
#' @examples
#' #sample of getting RxCui via NDC.
#' sample_data_subset_rxcui <- getRxcuiViaNdc(df = sample_data_subset,NdcColName = NationalDrugCode)
#' head(sample_data_subset_rxcui)
NULL



#' Get ATC via RxCui
#'
#' \code{getRxcuiViaNdc} is a function to get Anatomical Therapeutic Chemical Classification System(ATC) via RxCui
#'
#' @name getAtcViaRxcui
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @import foreach
#' @import data.table
#' @import doParallel
#' @param df data.frame, a drug ingredient`s RxCui of the specific indication
#' @param RxCuiColNamea a column name for RxCui of df
#' @param cores number of parallel operation
#' @param MatchRoute an option to mapping drug ingredient and route
#' @return
#' A new data.table \code{sample_data_subset_atc} with following columns.
#'
#' \code{MemberId} patient Id
#'
#' \code{DispenseDate} patient`s drug dispensed date, and the time interval is from 2025-12-06 to 2038-01-25
#'
#' \code{NationalDrugCode} drug NDC, total of 17,326 different drug codes
#'
#' \code{Quantity} quantity of patient`s drug dispensed
#'
#' \code{DaysSupply} days of patient`s drug dispensed
#'
#' \code{RxCui} drug RxCui
#'
#' \code{ATC} drug ATC
#' @details
#' WHO Collaborating Centre for Drug Statistics Methodology, ATC classification index with DDDs, 2019. Oslo, Norway 2018.
#' The same drug components in ATC might depend on different ATC medication route.
#' Hence, this function also  refer to the research of \code{Bodenreider et al.}(https://www.researchgate.net/publication/276067397_Analyzing_US_prescription_lists_with_RxNorm_and_the_ATCDDD_Index) and adds the parameter MatchRoute for user to consider.
#' If user wants to consider and compare the ATC medication route, input \code{TRUE} in the parameter \code{MatchRoute}, otherwise input \code{FALSE}.
#' This function provides user to get ATC via RxCui.
#' @examples
#' # sample of getting ATC via RxCui.
#' sample_data_subset_atc <- getAtcViaRxcui(df = sample_data_subset_rxcui,RxCuiColName = RxCui,cores = 2,MatchRoute = FALSE)
#' head(sample_data_subset_atc)
NULL



#' Get RxCui via ATC
#'
#' \code{getRxcuiViaAtc} is a function to get RxCui via Anatomical Therapeutic Chemical Classification System(ATC)
#'
#' @name getRxcuiViaAtc
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @import foreach
#' @import doParallel
#' @param df data.frame, a drug ingredient`s ATC of the specific indication
#' @param AtcColName a column name for ATC of df
#' @param Differ_ColName if colum for NHINo of df is not named ATC
#' @param cores number of parallel operation
#' @return
#' A new data.table \code{sample_atc_rxcui} with following columns.
#'
#' \code{RxCui} drug RxCui
#'
#' \code{ATC} drug ATC
#' @details
#' This function provides user to get RxCui via ATC.
#' @examples
#' # sample of getting RxCui via ATC.
#' sample_atc_rxcui <- getRxcuiViaAtc(df = sample_ATC,AtcColName = ATC,cores = 2)
#' head(sample_atc_rxcui)
NULL



#' Get NHINo via HC
#'
#' \code{getNHINoViaHC} is a function to get Taiwan Health Insurance drug code(NHINo) via Hospital Code(HC)
#'
#' @name getNHINoViaHC
#' @param df data.frame, the specific hospital drug code
#' @param HospitalCodeColName a column name for a specific hospital drug code of df
#' @param SourceDf data.frame include mapping between specific hospital drug code and NHINo
#' @param Source_NhinoColName a column name for NHINo in Sourcedf
#' @param Source_HospitalCodeColName a column name for specific hospital drug code in Sourcedf
#' @return
#' @details
#' This function provides user to get NHINo via HC.
NULL



#' Get NHINo via RCFNo
#'
#' \code{getNHINoViaRCFNo} is a function to get Taiwan Health Insurance drug code(NHINo) via Chang Gung Medical Hospital drug code(RCFNo)
#'
#' @name getNHINoViaRCFNo
#' @param df data.frame, the specific hospital drug code
#' @param RCFNoColName a colum name for RCFNo of df
#' @return
#'  A new data.table with following columns.
#'
#' \code{CGMH_CODE} Chang Gung Medical Hospital drug code RCFNo
#'
#' \code{NHINO1}drug NHINo
#' @details
#' If there is no corresponed NHINo, then display \code{NA}. This function provides user to get NHINo via RCFNo.
#' @examples
#' # sample of getting NHINo via RCFNo of Chang Gung Medical Hospital.
#' head(getNHINoViaRCFNo(df = sample_taiwan_drug, RCFNoColName = CGMH_CODE))
NULL



#' Get ATC via NHINO
#'
#' \code{getAtcViaNHINo} is a function to get Anatomical Therapeutic Chemical Classification System(ATC) via Taiwan Health Insurance drug code(NHINo)
#'
#' @name getAtcViaNHINo
#' @param df data.frame include NHINO
#' @param NHINoColName A colum for NHINo of df
#' @details
#' This function provides user to get Anatomical Therapeutic Chemical Classification System(ATC) via Taiwan Health Insurance drug code(NHINo).
#' @examples
#' # sample of getting ATC via NHINo.
#' head(getAtcViaNHINo(df = sample_nhino_code,NHINoColName = NHINo))
NULL



#' Generate Drug Era
#'
#' \code{getDrugEra} is a function to calculate the drug era
#'
#' @name getDrugEra
#' @import data.table
#' @param df data.frame with MemberID ,Drug,DispenseDate ,DaysSupply, or with MemberID ,Drug, StartDate, EndDate
#' @param window allowed gap between pharmacy claims, default is 30
#' @param DrugColName a column name for drug which patient use
#' @param DispenseDateColName a column name for dispense date
#' @param DaysSupplyColName A column for drug supply days
#' @param StartDateColName a column name for patient use drug start day
#' @param EndDateColName a column name for patient use drug end day
#' @return
#' A new data.table with following columns.
#'
#' \code{MemberId} patient Id
#'
#' \code{DispenseDate} patient`s drug dispensed date, and the time interval is from 2025-12-06 to 2038-01-25
#'
#' \code{NationalDrugCode} drug NDC, total of 17,326 different drug codes
#'
#' \code{Quantity} quantity of patient`s drug dispensed
#'
#' \code{DaysSupply} days of patient`s drug supplied
#'
#' \code{Drug Era} drug era
#'
#' \code{Drug Era Start Date} the begin date to calculate drug era
#'
#' \code{Drug Era End Date} the end date to calculate drug era
#'
#' \code{Gap} the time interval of drug dispensed date
#'
#' \code{Exposure Days} the date of drug era
#'
#' \code{Supply Days} the days of drug era that patient`s drug supplied
#' @details
#' This can be used to merge pharmacy claims data into drug era with defined window and Exposure days will be cacluated, too.
#' An event of the time interval is according to the prescription's dispense date plus the prescription's drug supply days.
#' There are two calculation models:
#'
#' 1.If the time interval gap between the patient taking the drug exceeds the persistent window, these two events are regarded as two different drug era.
#'
#' 2.If the time interval gap between the patient taking the drug less than the persistent window, these two events are regarded as same drug era.
#'
#' This function provides user to concatenate continuous prescription medications into a single prescription length.
#' @examples
#' #sample of calculating drug era.
#' getDrugEra(MemberIDColName = MemberId,sample_data_subset,DrugColName = NationalDrugCode,DispenseDateColName = DispenseDate,DaysSupplyColName = DaysSupply)
NULL



#' Calculate DDDs in RxCui
#'
#' \code{calDailyDosage} is a function to calculate daily dosage drugs(DDDs) in RxCui
#'
#' @name calDailyDosage
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @import foreach
#' @import doParallel
#' @import ggplot2
#' @import data.table
#' @param df data.frame, a drug ingredient`s ATC of the specific indication
#' @param RxCuiColName a column name for RxCui of df
#' @param QuantityColName a column name for drug quantity of df
#' @param DaysSupplyConName a column name for the days that patient`s drug supplied of df
#' @return
#' A new data.table \code{sample_data_subset_atc} with following columns.
#'
#' \code{MemberId} patient Id
#'
#' \code{DispenseDate} patient`s drug dispensed date, and the time interval is from 2025-12-06 to 2038-01-25
#'
#' \code{NationalDrugCode} drug NDC, total of 17,326 different drug codes
#'
#' \code{Quantity} quantity of patient`s drug dispensed
#'
#' \code{DaysSupply} days of patient`s drug supplied
#'
#' \code{RxCui} drug RxCui
#'
#' \code{ATC} drug ATC
#'
#' \code{DailyDosage} daily dosage drugs
#'
#' \code{Unit} drug calculate unit
#' @details
#' This function provides user to simply calculate daily dosage for drug in RxCui.
#'
#' The calculation model: The dosage of the drug multiplied by the number of the days of drug taken, and then divided by the number of days of drug supplied.
#' @examples
#' # sample of calculating DDDs in RxCui.
#' sample_data_subset_atc <- calDailyDosage(df = sample_data_subset_atc, RxCuiColName = RxCui, QuantityColName = Quantity, DaysSupplyConName = DaysSupply, cores = 2)
#' head(sample_data_subset_atc)
NULL



#' Calculate subjects' accumulated DDDs
#'
#' \code{calDailyDosage} is a function to Calculate subjects' accumulated daily dosage drugs(DDDs) in RxCui before last dispensed
#' \code{getDDDs} is a function to get DDDs in ATC
#'
#' @name calDDDsAccumulation
#' @import data.table
#' @param case data.frame, include subjects' id, dispensing date, drug ATC code, daily dosage, duration
#' @param atc data.frame include ATC code
#' @return
#' A new data.table \code{accumulat_DDD} with following columns.
#'
#' \code{MemberId} patient Id
#'
#' \code{DDDs} accumulated DDDs
#' @details
#' This function provides user to calculate patient`s total amount of DDDs for accumulation medication time.
#' @examples
#' # sample of calculating subjects' accumulated DDDs
#' accumulat_DDD <- calDDDsAccumulation(case = sample_data_subset_atc, PatientIdColName = MemberId,DispensingColName = DispenseDate,AtcCodeColName = ATC,DailyDosageColName = DailyDosage,DurationColName = DaysSupply)
#' head(accumulat_DDD)
NULL



#' Calculate subjects' accumulated DDDs in custom interval period
#'
#' \code{calDDDsRange} is a function to Calculate subjects' accumulated daily dosage drugs(DDDs) in RxCui in custom interval period
#' \code{getDDDs} is a function to get DDDs in ATC
#'
#' @name calDDDsRange
#' @import data.table
#' @param case data.frame include subjects' id, dispensing date, drug ATC code, daily dosage, duration
#' @param index_day observation day
#' @param expo_range_before days before observation day
#' @param expo_range_after days after observation day
#' @param idColName a column name for subject's id
#' @param DispenseDateColName a column name for dispensing
#' @param DaysSupplyColName a column name for supply day
#' @param DailyDosageColName a column name for DDDs
#' @return
#' A new data.table \code{index_DDD} with following columns.
#'
#' \code{MemberId} patient Id
#'
#' \code{Start_day} the begin date of patient take medicine
#'
#' \code{Index_Day} the begin date of calculating the DDDs
#'
#' \code{End_day} the end date of patient take medicine
#'
#' \code{DDDs_Before_15_Days} calculate DDDs in custom time interval before index 15 day
#'
#' \code{DDDs_After_30_Days} calculate DDDs in custom time interval after index 30 day
#' @details
#' This function provides user to calculate the total amount of DDDs accumulated by the patient in a custom interval period or specific date.
#' @examples
#' # sample of calculating subjects' accumulated DDDs in a custom interval period
#' index_DDD <- calDDDsRange(case = sample_data_subset_atc,index_dayColName = Index_Day,expo_range_before = 15,expo_range_after = 30,idColName = MemberId,AtcCodeColName = ATC,DispenseDateColName = DispenseDate,DaysSupplyColName = DaysSupply,DailyDosageColName = DailyDosage)
#' head(index_DDD)
NULL



