#' Get ingredient RxCui via specific indication
#'
#' This function provides user to get drug ingredient RxCui of the specific indication may treat.
#'
#' @name getRxCuiViaMayTreat123
#' @import data.table
#' @param strmaytreat user can input an indication name
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
#' The data source is from the U.S. Veterans Administration's \code{MED-RT} database.
#' Since RxNorm integrates the US Veterans Administration MED-RT drug vocabulary and provides API (/rxclass/relaSources) that mediates RxCui into the drug vocabulary.
#' Therefore, we establishes a function through this API, so that users can obtain complete contraindications, indications and other information in the MED-RT vocabulary through the drug RxCui.
#' In addition to drug contraindications and indications for RxNorm coding, this study also uses web crawler technology to crawl information on contraindications and indications for all drugs in the MED-RT data sheet.
#' Establish a function for finding drugs from contraindications and indications.
#' @examples
#' # sample of searching an indication esophagitis may treat.
#' Esophagitis_List <- getRxCuiViaMayTreat123("esophagitis")
#' # sample of getting drug ingredient RxCui list of esophagitis.
#' head(Esophagitis_List)
NULL



#' Get ingredient RxCui via specific indication
#'
#' This function provides user to get drug ingredient RxCui of the specific indication may prevent.
#'
#' @name getRxCuiViaMayPrevent123
#' @import data.table
#' @param strmayprevent user can input an indication name
NULL



#' Get specific indication may prevent via RxCui
#'
#' This function provides user to get the specific indication may prevent via drug RxCui.
#'
#' @name getMayPrevent
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @import foreach
#' @import doParallel
#' @param df data.frame, a drug ingredient RxCui
#' @param RxCuiColName a column name for RxCui of df
#' @param cores number of parallel operation
NULL


#' Get Semantic Branded Drug(SBD) or Semantic Clinical Drug(SCD) RxCui via RxCui
#'
#' This function provides user to get Semantic Branded Drug(SBD) or Semantic Clinical Drug(SCD) RxCui via ingredient RxCui.
#'
#' @name getSBDRxCuiViaRxCui123
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @import foreach
#' @import doParallel
#' @param df data.frame, a drug ingredient RxCui of the specific indication
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
#' After obtaining the data.frame from \code{getRxCuiViaMayTreat()} and \code{getRxCuiViaMayPrevent()}, user can further obtain a commercially available pharmaceutical brand and clinical drug contained these drug ingredients.
#' The content is to add a column named \code{SBD.rxcui} in the original input data frame, stores the result of converting ingredient to brand drug and clinical drug containing a specific drug component.
#' @examples
#' # sample of getting SBD or SCD Rxcui list of esophagitis.
#' Esophagitis_SBD_SCD_List <- getSBDRxCuiViaRxCui123(df = Esophagitis_List[3,],RxCuiColName = RxCui,cores = 2)
#' head(Esophagitis_SBD_SCD_List)
NULL



#' Get U.S National Drug Code(NDC) via Semantic Branded Drug(SBD) or Semantic Clinical Drug(SCD) RxCui
#'
#' This function provides user tO get U.S National Drug Code(NDC) via Semantic Branded Drug(SBD) RxCui or Semantic Clinical Drug(SCD) RxCui contained these drug ingredients.
#'
#' @name getNDCViaSBDRxCui123
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @import foreach
#' @import doParallel
#' @param df data.frame, a drug ingredient SBD or SCD RxCui of the specific indication
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
#' User can screen out the patient who has the record of receiving these drugs in the medication data, but not all medication data are encoded in RxNorm.
#' In the United States, for example, the drug code commonly used in medical data is NDC code.
#' NDC code cannot be directly filtered with RxNorm coded data.
#' Therefore, user can input the data.frame from \code{getRxCuiViaMayTreat()}, then convert to NDC code and screen out a new data.frame.
#'
#' However, a drug will have different packaging and NDC because it comes from different pharmaceutical brands.
#' There will be different NDC for the same drug type but different packaging. Hence, the output results will be one-to-many.
#' A drug RxCui will matche to multiple NDC of pharmaceutical brands, and no corresponding NDC will be \code{NA}.
#' @examples
#' # sample of getting NDC via SBD SCD RxCui list of esophagitis
#' Esophagitis_NDC_List <- getNDCViaSBDRxCui123(df = Esophagitis_SBD_SCD_List[1,],SBDRxCuiColName = SBD.rxcui,cores = 2)
#' head(Esophagitis_NDC_List)
NULL



#' Get RxCui via U.S National Drug Code(NDC)
#'
#' This is a function to get RxCui via National Drug Code(NDC)
#'
#' @name getRxCuiViaNDC123
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
#' \code{RxCui} drug code for the drug in the RxNorm drug vocabulary
#'
#' \code{ndcStatus} NDC status
#' @details
#' User can input the data.frame with drug column which encoded in NDC.
#' The content is to add a column named RxCui in the original input data frame, storing the result of converting NDC to RxNorm in this column.
#' The column \code{ndcStatus} is to show whether the converted NDC is now used.
#' @examples
#' #sample of getting RxCui via NDC.
#' sample_data_subset_rxcui <- getRxCuiViaNDC123(df = sample_data_subset, NdcColName = NationalDrugCode)
#' head(sample_data_subset_rxcui)
NULL



#' Get Anatomical Therapeutic Chemical Classification System(ATC) code via RxCui
#'
#' This is a function to get Anatomical Therapeutic Chemical Classification System(ATC) code via RxCui
#'
#' @name getATCViaRxCui123
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
#' \code{ATC} drug ATC code
#' @details
#' User can input the data.frame with drug column which encoded in RxCui, and to add the result of converting column named ATC.
#'
#' The same drug components in ATC might depend on different ATC medication route.
#' Hence, this function also refer to the research of \code{Bodenreider et al.}(https://www.researchgate.net/publication/276067397_Analyzing_US_prescription_lists_with_RxNorm_and_the_ATCDDD_Index) and adds the parameter \code{MatchRoute} for user to consider.
#' If user wants to compare the ATC medication route, input \code{TRUE} in the parameter \code{MatchRoute}, otherwise input \code{FALSE}.
#' Because RxCui is slightly different from the ATC drug vocabulary, not every RxCui has a corresponding ATC code.
#' Therefore, if RxCui does not have a corresponding ATC code, this field will display \code{NA}, and pharm does not provide the code conversion of the clinical drug and brand drug combination package, such as birth control pills.
#' If the input RxCui is a drug combination package, the field output result will be filled in GPCK or BPCK.
#' @examples
#' # sample of getting ATC via RxCui.
#' sample_data_subset_atc <- getATCViaRxCui123(df = sample_data_subset_rxcui,RxCuiColName = RxCui,cores = 2,MatchRoute = FALSE)
#' head(sample_data_subset_atc)
NULL



#' Get RxCui via Anatomical Therapeutic Chemical Classification System(ATC) code
#'
#' This is a function to get RxCui via Anatomical Therapeutic Chemical Classification System(ATC) code
#'
#' @name getRxCuiViaATC123
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @import foreach
#' @import doParallel
#' @param df data.frame, a drug ingredient ATC code of the specific indication
#' @param AtcColName a column name for ATC code of df
#' @param Differ_ColName if colum for NHINo of df is not named ATC
#' @param cores number of parallel operation
#' @return
#' A new data.table \code{sample_atc_rxcui} with following columns.
#'
#' \code{RxCui} drug RxCui
#'
#' \code{ATC} drug ATC code
#' @details
#' Users can obtain additional drug information via other drug integrated by RxCui, such as the contraindications and indications for drugs available in the MED-RT database of the US Veterans Bureau integrated by RxNorm.
#' User inputs the data frame with drug column which encoded in ATC code, then the output will add a column named RxCui in the original input data frame.
#' @examples
#' # sample of getting RxCui via ATC.
#' sample_atc_rxcui <- getRxCuiViaATC123(df = sample_ATC,AtcColName = ATC,cores = 2)
#' head(sample_atc_rxcui)
NULL



#' Get Taiwan Health Insurance drug code(NHINo) via Hospital Code(HC)
#'
#' This is a function to get Taiwan Health Insurance drug code(NHINo) via Hospital Code(HC)
#'
#' @name getNHINoViaHC
#' @param df data.frame, the specific hospital drug code
#' @param HospitalCodeColName a column name for a specific hospital drug code of df
#' @param SourceDf data.frame include mapping between specific hospital drug code and NHINo
#' @param Source_NhinoColName a column name for NHINo in Sourcedf
#' @param Source_HospitalCodeColName a column name for specific hospital drug code in Sourcedf
NULL



#' Get Taiwan Health Insurance drug code(NHINo) via Hospital drug code(RCFNo)
#'
#' This is a function to get Taiwan Health Insurance drug code(NHINo) via Chang Gung Medical Hospital drug code(RCFNo)
#'
#' @name getNHINoViaRCFNo
#' @param df data.frame, the specific hospital drug code
#' @param RCFNoColName a colum name for RCFNo of df
#' @return
#'  A new data.table with following columns.
#'
#' \code{CGMH_CODE} Chang Gung Medical Hospital drug code RCFNo
#'
#' \code{NHINO1} drug NHINo
#' @details
#' User can input the specific hospital drug code
#' If there is no corresponed NHINo, then display \code{NA}.
#' @examples
#' # sample of getting NHINo via RCFNo of Chang Gung Medical Hospital.
#' head(getNHINoViaRCFNo(df = sample_taiwan_drug, RCFNoColName = CGMH_CODE))
NULL



#' Get Anatomical Therapeutic Chemical Classification System(ATC) code via Taiwan Health Insurance drug code(NHINo)
#'
#' This is a function to get Anatomical Therapeutic Chemical Classification System(ATC) code via Taiwan Health Insurance drug code(NHINo)
#'
#' @name getATCViaNHINo123
#' @param df data.frame include NHINO
#' @param NHINoColName A colum for NHINo of df
#' @return
#' @details
#' This function filter the patient to be analyzed with the target indication drug, which encode in RxCui and be converted to ATC code by the function \code{getATCViaRxCui()}.
#' User inputs the data frame with drug column which encoded in NHINo, then the output will add a column named ATC in the original input data frame.
#' @examples
#' # sample of getting ATC code via NHINo.
#' head(getATCViaNHINo123(df = sample_nhino_code,NHINoColName = NHINo))
NULL



#' Generate Drug Era
#'
#' This is a function to calculate the drug era
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
#' \code{Quantity} drug ration
#'
#' \code{DaysSupply} days of patient`s drug supplied
#'
#' \code{Drug Era} the row of medicine records belongs to the drug era
#'
#' \code{Drug Era Start Date} the begin date to calculate drug era
#'
#' \code{Drug Era End Date} the end date to calculate drug era
#'
#' \code{Gap} interval between each drug delivery record date and the previous medication end date
#'
#' \code{Exposure Days} number of days of drug era
#'
#' \code{Supply Days} the days of drug era that patient`s drug supplied
#' @details
#' Because the patient does not seek medical treatment every time to treat a specific disease, in the medication records, the continuous drug record is not necessarily the drug for the treatment of a specific disease.
#' The patient's medication records for the treatment of a particular disease are often scattered throughout the data, so the serialization of these discrete drug records into a continuous medication is an important step in the analysis.
#'
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



#' Calculate total daily dosage drugs(DDDs) in RxCui
#'
#' This is a function to calculate daily dosage drugs(DDDs) in RxCui
#'
#' @name calDDDsViaRxCui
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
#' The calculation model: The dosage of the drug multiplied by the number of the days of drug taken, and then divided by the number of days of drug supplied.
#' @examples
#' # sample of calculating DDDs in RxCui.
#' sample_data_subset_atc <- calDDDsViaRxCui(df = sample_data_subset_atc, RxCuiColName = RxCui, QuantityColName = Quantity, DaysSupplyConName = DaysSupply, cores = 2)
#' head(sample_data_subset_atc)
NULL



#' Calculate subjects' total daily dosage drugs(DDDs)
#'
#' \code{calDDDsAccumulation} is a function to calculate subjects' accumulated daily dosage drugs(DDDs) in RxCui before last dispensed.
#' \code{getDDDs} is a function to get DDDs in ATC code
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
#' User can input data frame containing the patient id, dispensing date, the drug ATC code, drug supply days, and daily dose of the drug column.
#' This function will output a data frame which store DDDs accumulated by patients.
#' @examples
#' # sample of calculating subjects' accumulated DDDs
#' accumulat_DDD <- calDDDsAccumulation(case = sample_data_subset_atc, PatientIdColName = MemberId,DispensingColName = DispenseDate,AtcCodeColName = ATC,DailyDosageColName = DailyDosage,DurationColName = DaysSupply)
#' head(accumulat_DDD)
NULL



#' Calculate subjects' accumulated daily dosage drugs(DDDs) in custom interval period
#'
#' \code{calDDDsRange} is a function to calculate subjects' accumulated daily dosage drugs(DDDs) in RxCui in custom interval period
#' \code{getDDDs} is a function to get DDDs in ATC code
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
#' User can get the total amount of DDDs accumulated of patients before and after a specific date in a custom interval period or specific date.
#' @examples
#' # sample of calculating subjects' accumulated DDDs in a custom interval period
#' index_DDD <- calDDDsRange(case = sample_data_subset_atc,index_dayColName = Index_Day,expo_range_before = 15,expo_range_after = 30,idColName = MemberId,AtcCodeColName = ATC,DispenseDateColName = DispenseDate,DaysSupplyColName = DaysSupply,DailyDosageColName = DailyDosage)
#' head(index_DDD)
NULL


#' Get  Anatomical Therapeutic Chemical Classification System(ATC) code level code distribution histogram plot
#'
#' \code{getAtcLevelPlot} is a function to get daily dosage drugs(DDDs) in Anatomical Therapeutic Chemical Classification System(ATC) code level histogram plot.
#'
#' @name getATCLevelPlot123
#' @import ggplot2
#' @import data.table
#' @param df data.frame, include ATC code
#' @param ATCColName a column name for ATC code of df
#' @details
#' If the amount of drug information obtained by the user is large and messy, the user can first visualize the data using basic statistical tools, explore the characteristics of the data, and obtain the information, structure and features contained in the data.
#' Because before having a complicated or rigorous analysis, user must have more knowledge of the data to determine the direction of the data analysis.
#' @examples
#' # sample of getting ATC first-level code distribution bar chart
#' getATCLevelPlot123(df = sample_data_ATC1LevelPlot, ATCColName = ATC, level = 1)
#' # sample of getting ATC second-level code distribution bar chart
#' getATCLevelPlot123(df = sample_data_ATC1LevelPlot, ATCColName = ATC, level = 2)
NULL



#' Get drug era histogram plot
#'
#' This function provides user to get drug era histogram plot.
#'
#' @name getDrugEraPlot
#' @import ggplot2
#' @import data.table
#' @param df data.frame include drug era info
#' @param MemberIDColName a column name for member id of df
#' @param DrugColName a column name for drug name df
#' @param DrugEraColName a column name for drug era of df
#' @param SupplyDaysColName A column name for supply days of df
#' @details
#' User can get the drug data, the length of each drug record, and the number of days of drug supply in the drug era.
#' In addition to the analysis of each drug route by the drug era, user can also visualize the drug data of the drug era.
#' @examples
#' #sample of getting drug era histogram plot.
#' getDrugEraPlot(df = sample_data_DrugEraPlot,MemberIDColName = MemberId,DrugColName = ATC,DrugEraColName = DrugEra,SupplyDaysColName = SupplyDays)
NULL



#' Get specific medication history dispensing plot
#'
#' This function provides user to select specific patient to visualize their medication history in a custom interval period or specific date.
#'
#' @name getDispensingPlot
#' @import ggplot2
#' @import data.table
#' @param df data.frame, include dispensed info
#' @param MemberIDColName a column name for member id of df
#' @param Member a column name for the member name of plot
#' @param DrugColName a column name for drug name of df
#' @param DispenseDateColName a column name for dispensed date of df
#' @param DaysSupplyColName a column name for day supplied of df
#' @param TimeInterval a column name for time interval of df
#' @param Unit a column name for time unit of df
#' @details
#' In addition to visualize the results of the drug era for all patients in the data, user can also select a single patient to see the medication history of the patient's specific drug, and mark the length of each medication record and the time interval between each medication record.
#' @examples
#' #sample of getting dispensing plot.
#' getDispensingPlot(df = sample_data_subset, MemberIDColName = MemberId,DrugColName = NationalDrugCode,DispenseDateColName = Dispensing,Member = 42, TimeInterval = 20, Unit = day)
NULL



#' Get RxCui information
#'
#' This function can get the information of RxCui
#'
#' @name getRxCuiInfo123
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @import foreach
#' @import doParallel
#' @param df data.frame, included RxCui
#' @param RxCuiColName a column name for RxCui of df
#' @param cores number of parallel operation
NULL



#' Get Ingredient and Basis of Strength Substance (BoSS) information via RxCui
#'
#' This function can get BoSS information.
#'
#' @name getBoSSViaRxCui
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @import foreach
#' @import doParallel
#' @param df data.frame, included RxCui
#' @param RxCuiColName a column name for RxCui of df
#' @param cores number of parallel operation
NULL



#' Get the Veterans Health Administration's Medication Reference Terminology (MED-RT) information via RxCui
#'
#' This function can get \code{MED-RT} information via RxCui.
#' @name getMEDRTInfo
#' @importFrom parallel makeCluster
#' @importFrom parallel stopCluster
#' @import foreach
#' @import doParallel
#' @param df data.frame, included RxCui
#' @param RxCuiColName a column name for RxCui of df
#' @param cores number of parallel operation
NULL

