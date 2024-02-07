#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @importFrom shiny renderLeaflet renderReactable leafletOutput reactableOutput
#' @importFrom leaflet leaflet addTiles addCircleMarkers
#' @importFrom reactable reactable
#' @noRd
app_server <- function(input, output, session) {
  # # Your application server logic
  #
  mod_pagina_inicial_server('inicio')
  mod_mapas_bacias_server('1','Bacia Amazônica')
  mod_mapas_bacias_server('2','Bacia do Tocantins-Araguaia')
  mod_mapas_bacias_server('3','Bacia do São Francisco')

}
