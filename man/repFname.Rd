% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/repFname.R
\name{repFname}
\alias{repFname}
\alias{repFolder}
\alias{scenariosFname}
\title{Replicate File Name}
\usage{
repFname(label, scenario, replicate)

repFolder(label)

scenariosFname(label)
}
\arguments{
\item{label}{label of simulation run.}

\item{scenario}{scenario number.}

\item{replicate}{replicate number within the scenario.}
}
\value{
for `repFname`, the name of file that should contain genotypes,
  for `repFolder`, the name of the folder that should contain simulation 
  replicate files.
}
\description{
Return file name containing genotypes from a simulation 
  replicate.
}
\author{
Eric Archer \email{eric.archer@noaa.gov}
}
