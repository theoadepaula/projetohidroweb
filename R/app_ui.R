#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @importFrom shiny fluidPage titlePanel leafletOutput reactableOutput
#' @importFrom leaflet leaflet addTiles addCircleMarkers
#' @importFrom reactable reactable
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    navbarPage(title = 'Hidroweb',
               tabPanel(
                 title='Pagina inicial',
                 h2('Página Inicial'),
                 mod_pagina_inicial_ui('inicio')
               ),
               tabPanel(
                 title='Bacia Amazônica',
                 mod_mapas_bacias_ui('1','Bacia Amazônica')
               ),
               tabPanel(
                 title='Bacia do Tocantins-Araguaia',
                 mod_mapas_bacias_ui('2','Bacia do Tocantins-Araguaia')
               ),
               tabPanel(
                 title='Bacia do São Francisco',
                 mod_mapas_bacias_ui('3','Bacia do São Francisco')
               )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "projetohidroweb",

    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()

  )
}
