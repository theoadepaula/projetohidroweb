#' pagina_inicial UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom htmltools includeMarkdown
#'
library(markdown)
mod_pagina_inicial_ui <- function(id){
  ns <- NS(id)
  tagList(
    htmltools::includeMarkdown("intro.md"),
  )
}

#' pagina_inicial Server Functions
#'
#' @noRd
mod_pagina_inicial_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_pagina_inicial_ui("pagina_inicial_1")

## To be copied in the server
# mod_pagina_inicial_server("pagina_inicial_1")
