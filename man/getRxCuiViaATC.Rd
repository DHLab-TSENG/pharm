% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/funPharm.R, R/getRxCuiViaATC.R
\name{getRxCuiViaATC}
\alias{getRxCuiViaATC}
\title{Get RxCui via Anatomical Therapeutic Chemical Classification System(ATC) code}
\usage{
getRxCuiViaATC(df, AtcColName = ATC, cores = 8)
}
\arguments{
\item{df}{data.frame, a drug ingredient ATC code of the specific indication}

\item{AtcColName}{a column name for ATC code of df}

\item{cores}{number of parallel operation}

\item{Differ_ColName}{if colum for NHINo of df is not named ATC}
}
\value{
A new data.table \code{sample_atc_rxcui} with following columns.

\code{RxCui} drug RxCui

\code{ATC} drug ATC code
}
\description{
This is a function to get RxCui via Anatomical Therapeutic Chemical Classification System(ATC) code
}
\details{
Users can obtain additional drug information via other drug integrated by RxCui, such as the contraindications and indications for drugs available in the MED-RT database of the US Veterans Bureau integrated by RxNorm.
User inputs the data frame with drug column which encoded in ATC code, then the output will add a column named RxCui in the original input data frame.
}
\examples{
# sample of getting RxCui via ATC.
sample_atc_rxcui <- getRxCuiViaATC(df = sample_ATC,AtcColName = ATC,cores = 2)
head(sample_atc_rxcui)
}
