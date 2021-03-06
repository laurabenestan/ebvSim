% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/downloadRun.R
\name{downloadRun}
\alias{downloadRun}
\title{Download a Simulation Run}
\usage{
downloadRun(label, google.drive.id, out.folder = NULL)
}
\arguments{
\item{label}{label of simulation run to download.}

\item{google.drive.id}{id of root Google Drive to download run from.}

\item{out.folder}{local folder to download run to. If `NULL`, a temporary 
folder is created and used.}
}
\value{
path of folder where run was downloaded to.
}
\description{
Download scenario specification and genotype csv files from 
  Google Drive.
}
\author{
Eric Archer \email{eric.archer@noaa.gov}
}
