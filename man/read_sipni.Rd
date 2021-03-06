% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_sipni.R
\name{read_sipni}
\alias{read_sipni}
\title{Read SIPNI files from Brazilian Health Ministry}
\usage{
read_sipni(files_folder, chunk_size = 1e+05)
}
\arguments{
\item{files_folder}{Path to folder containing CSV files from Brazilian Health Ministry}

\item{chunk_size}{Integer. Chunk size to read CSV files. Default 100,000 lines.}
}
\value{
A lazy connection to SIPNI table in a SQLite database stored in a temporary folder.
}
\description{
Read SIPNI files from Brazilian Health Ministry
}
