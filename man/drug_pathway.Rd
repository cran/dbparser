% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/drug_pathway_node_parsers.R
\name{drug_pathway}
\alias{drug_pathway}
\title{Drug Pathway parser}
\usage{
drug_pathway()
}
\value{
a tibble with the following variables:
\describe{
 \item{smpdb-id}{Small Molecule Pathway Database identifier for this
 pathway.}
 \item{name}{Pathway name}
 \item{category}{Pathway category}
 \item{\emph{drugbank_id}}{drugbank id}
}
}
\description{
Metabolic, disease, and biological pathways that the drug is involved in, as
identified by the Small Molecule Protein Database (SMPDB).
}
\keyword{internal}
