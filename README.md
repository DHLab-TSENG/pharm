## Introduction
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
English:

Chinese: https://dhlab-tseng.github.io/pharm/articles/Pharm_Overview.html

## Install version
```r
# install.packages("devtools")
devtools::install_github("DHLab-TSENG/pharm")
library(pharm)
library(dplyr)
```

## Overview
(picture)

## Data source
* Chang Gung Medical Research Database
  * Chang Gung Medical drug code
* ATC Database for Classification of Drugs and Pharmacological Treatments
  * Taiwan Food and Drug Administration, 2019
* RxNorm API
  * U.S.National Library of Medicine, 2019b

## Getting help
See the [GitHub issues page](<https://github.com/DHLab-TSENG/pharm/issues>) to see open issues and feature requests.
