% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/drug_parsers.R
\name{drug_patents}
\alias{drug_patents}
\title{Drug Patents parser
A property right issued by the United States Patent and Trademark
Office (USPTO) to an inventor for a limited time, in exchange for public
disclosure of the invention when the patent is granted. Drugs may be issued
multiple patents.}
\usage{
drug_patents()
}
\value{
a tibble with the following variables:
\describe{
 \item{number}{The patent number(s) associated with the drug.}
 \item{country}{The country that issued the patent rights.}
 \item{approved}{The date that the patent request was filed.}
 \item{expires}{The date that the patent rights expire.}
 \item{pediatric-extension}{Indicates whether or not a pediatric extension has been approved for
  the patent. Granted pediatric extensions provide an additional 6 months of
  market protection.}
 \item{\emph{drugbank_id}}{drugbank id}
}
}
\description{
Drug Patents parser
A property right issued by the United States Patent and Trademark
Office (USPTO) to an inventor for a limited time, in exchange for public
disclosure of the invention when the patent is granted. Drugs may be issued
multiple patents.
}
\keyword{internal}
