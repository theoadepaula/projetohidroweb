#' Função pegar dados hidrometeorológicos da estação
#'
#' @param estacao Código da Estação
#' @param dataInicio Data no formato dd/mm/aaaa
#' @param dataFim Data no formato dd/mm/aaaa
#'
#' @return Tibble
#' @export
#'
#' @examples pegar_dados_hidrometeorologicos('10100000',dataInicio=format(Sys.Date(),'%d/%m%/%Y'))
#'
pegar_dados_hidrometeorologicos <- function(estacao,dataInicio,dataFim='') {

  link <- glue::glue('https://www.ana.gov.br/telemetria1ws/ServiceANA.asmx/DadosHidrometeorologicos?codEstacao={estacao}&dataInicio={dataInicio}&dataFim={dataFim}')


  url_dados_estacoes <-
    httr::GET(link  )|> httr::content()

  doc <- XML::xmlParse(url_dados_estacoes)

  lista_dados_estacoes <- XML::xmlParse(url_dados_estacoes) |>
    XML::xmlToDataFrame(nodes = XML::getNodeSet(doc,"//DadosHidrometereologicos")) |>
    tibble::as_tibble() |>
    janitor::clean_names()

  lista_dados_estacoes

}
