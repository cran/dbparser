% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/drug_sequence_node_parser.R
\name{drug_sequences}
\alias{drug_sequences}
\title{Drug Sequences parser}
\usage{
drug_sequences()
}
\value{
a tibble with the following variables:
\describe{
 \item{sequence}{a textual representation of the sequence}
 \item{format}{Currently, only the FASTA format is used}
 \item{\emph{drugbank_id}}{drugbank id}
}
}
\description{
The amino acid sequence; provided if the drug is a peptide.
}
\details{
Describes peptide sequences of biotech drugs
}
\keyword{internal}
