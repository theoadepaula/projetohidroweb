% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pegar_dados_hidrometeorologicos.R
\name{pegar_dados_hidrometeorologicos}
\alias{pegar_dados_hidrometeorologicos}
\title{Função pegar dados hidrometeorológicos da estação}
\usage{
pegar_dados_hidrometeorologicos(estacao, dataInicio, dataFim = "")
}
\arguments{
\item{estacao}{Código da Estação}

\item{dataInicio}{Data no formato dd/mm/aaaa}

\item{dataFim}{Data no formato dd/mm/aaaa}
}
\value{
Tibble
}
\description{
Função pegar dados hidrometeorológicos da estação
}
\examples{
pegar_dados_hidrometeorologicos('10100000',dataInicio=format(Sys.Date(),'\%d/\%m\%/\%Y'))

}
