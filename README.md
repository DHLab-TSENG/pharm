## Getting started with pharm package

![pharm](https://user-images.githubusercontent.com/8377506/176843013-50d54235-2fc0-4d54-9720-1bfa9fba1591.png)


Currently, most of the healthcare data, such as electronic medical records(e-MD) and medical insurance data are digitized. However, there is still no unified record standard for drug records.

The Pharm package is an open-source software tool aimed at integrating standard drug code, indication screening and definition of daily dose calculation function.

The Pharm package provides four main mechanisms to get drug ingredient via indication, transform drug code, calculate drug data as well as visualize clinical data.

## Feature
* **Get Drug Ingredient Via Indication**
Using RxNorm API provided by U.S.National Library of Medicine to search drug details and MED-RT drug integration. This mechanism provides user to obtain drug ingredient via contraindication or indication.
* **Drug Code Integration**
When analyzing medical prescription data from different sources, it may be difficult to analyze the drug codes due to the different coding expression in different countries and institutions. This mechanism provides user to transform standard drug code before applying or analyzing data.
* **Calculate Drug Data**
This mechanism provides user to integrate scattered medical records before medical data analysis
* **Visualization**
This mechanism provides user visualization to overview the result of drug data analysis.
* **Get Info**
Using RxNorm API provided by U.S.National Library of Medicine to search drug details and MED-RT drug integration. This mechanism provides user to obtain the complete contraindications, indications and information of the drug.

## Getting start
English version: https://dhlab-tseng.github.io/pharm//articles/Eng_Overview.html

Chinese version: https://dhlab-tseng.github.io/pharm//articles/Chi_Overview.html

## Install version
```r
# install.packages("devtools")
devtools::install_github("DHLab-TSENG/pharm")
library(pharm)
library(dplyr)
```

## Overview
<img src="https://raw.githubusercontent.com/DHLab-TSENG/pharm/master/image/overview.png" style="display:block; margin:auto; width:100%;">

## Data Source
* Chang Gung Medical drug code
  * Chang Gung Medical Research Database
* ATC Database for Classification of Drugs and Pharmacological Treatments
  * Taiwan Food and Drug Administration, 2019
* RxNorm API
  * U.S.National Library of Medicine, 2019b

## Function Example Data List
| sample Esophagitis  | return list              |
|-------------------- | ------------------------ |
| getRxCuiViaMayTreat | Esophagitis_List         |
| getSBDRxCuiViaRxCui | Esophagitis_SBD_SCD_List |
| getNDCViaSBDRxCui   | Esophagitis_NDC_List     |
| getRxCuiViaNDC      | sample_data_subset_rxcui |
| getATCViaRxCui      | sample_data_subset_atc   |
| getRxCuiViaATC      | sample_atc_rxcui         |
| calDailyDosage      | sample_data_subset_atc   |
| calDDDsAccumulation | accumulat_DDD            |
| calDDDsRange        | index_DDD                |


## Getting Help
See the [GitHub issues page](<https://github.com/DHLab-TSENG/pharm/issues>) to see open issues and feature requests.
