#' mapas_bacias UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @importFrom shiny renderLeaflet renderReactable leafletOutput reactableOutput
#' @importFrom leaflet leaflet addTiles addCircleMarkers leafletOutput
#' @importFrom reactable reactable reactableOutput
#' @importFrom echarts4r echarts4rOutput
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_mapas_bacias_ui <- function(id,bacia){
  ns <- NS(id)
  tagList(
      h2(bacia),
      h3('Mapa'),
      leaflet::leafletOutput(ns("mapa")),
      h3('Tabela'),
      reactable::reactableOutput(ns("tabela")),
      h3('Gráfico'),
      echarts4r::echarts4rOutput(ns("grafico"))
    )

}

#' mapas_bacias Server Functions
#' @importFrom shiny
#' @importFrom leaflet leaflet addTiles addCircleMarkers renderReactable addPolylines
#' @importFrom reactable reactable renderLeaflet coldDef colFormat
#' @importFrom sf read_sf st_transform st_crs
#' @importFrom dplyr case_when filter mutate select across
#' @importFrom lubridate ymd_hms
#' @importFrom echarts4r e_charts e_line e_tooltip e_title e_x_axis e_y_axis e_datazoom e_locale e_legend e_text_style e_color
#' @noRd
mod_mapas_bacias_server <- function(id, bacia){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    numero_bacia <- function(x){
      dplyr::case_when(
        x == 'Bacia Amazônica' ~ 1,
        x == 'Bacia do Tocantins-Araguaia' ~ 2,
        x == 'Bacia do São Francisco' ~ 5
      )
    }

    n_bacia <- numero_bacia(bacia)

    mapa_hidro <- sf::read_sf('data/macro_RH/macro_RH.shp')
    mapa_hidro <- sf::st_transform(mapa_hidro, crs = sf::st_crs("+proj=longlat +datum=WGS84"))

    output$mapa <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addTiles(data=mapa_hidro|> dplyr::filter(fid==n_bacia)) |>
        leaflet::addPolylines(data = mapa_bacia_rios[[n_bacia]],weight = 0.8) |>
        leaflet::addCircleMarkers(data = mapa_bacia_estacoes[[n_bacia]],radius = 3,
                                  layerId = ~codigo,
                                  color = "red",
                                  popup =paste('Código:', mapa_bacia_estacoes[[n_bacia]]$codigo,"<br/>",
                                               'Nome:', mapa_bacia_estacoes[[n_bacia]]$nome))

    })

    # Renderize a tabela Reactable
    output$tabela <- reactable::renderReactable({

      validate(need(!is.null(input$mapa_marker_click),
                    'Clique em uma estação para ver os dados'))


      reactable::reactable(dados_estacoes_fluviometricas |>
                             dplyr::filter(cod_estacao==input$mapa_marker_click) |>
                             dplyr::select(cod_estacao,data_hora,nivel,vazao,chuva) |>
                             dplyr::mutate(
                               data_hora = lubridate::ymd_hms(data_hora),
                               dplyr::across(c(nivel,chuva,vazao),as.numeric)
                             ),
                           columns = list(
                             cod_estacao = reactable::colDef(name = "Código da Estação"),
                             data_hora = reactable::colDef(name = "Horário de Medição",
                                                           format = reactable::colFormat(datetime = TRUE, locales = "pt-BR")),
                             vazao = reactable::colDef(name = "Vazão m^3/s",format = reactable::colFormat(locales = "pt-BR")),
                             nivel = reactable::colDef(name = "Nível (m)",format = reactable::colFormat(locales = "pt-BR")),
                             chuva = reactable::colDef(name = "Chuva (mm)",format = reactable::colFormat(locales = "pt-BR"))
                           ),
                           highlight = TRUE,
                           defaultPageSize = 10)
    })

    # Renderize o gráfico echarts
    output$grafico <- echarts4r::renderEcharts4r({

      validate(need(!is.null(input$mapa_marker_click),
                    'Clique em uma estação para ver os dados'))

      dados_estacoes_fluviometricas |>
        dplyr::filter(cod_estacao==input$mapa_marker_click) |>
        dplyr::select(cod_estacao,data_hora,nivel,vazao,chuva) |>
        dplyr::mutate(
          data_hora = lubridate::ymd_hms(data_hora),
          dplyr::across(c(nivel,chuva,vazao),as.numeric)
        ) |>
        echarts4r::e_charts(x = data_hora) |>
        echarts4r::e_line(serie = nivel) |>
        echarts4r::e_title("Gráfico de Nível",textStyle = list(fontSize = 24, fontFamily = 'Nunito',color='white')) |>
        echarts4r::e_tooltip(trigger = "axis", formatter = htmlwidgets::JS(
          "function (params) {",
          "  var date = new Date(params[0].axisValue);",
          "  var formattedDate = date.getDate() + '/' + (date.getMonth() + 1) + '/' + date.getFullYear() + ' ' + date.getHours() + ':' + (date.getMinutes() < 10 ? '0' : '') + date.getMinutes();",
          "  var value = params[0].value[1];",
          "  return 'Data: ' + formattedDate + '<br/>Nível: ' + value;",
          "}"
        )) |>
        echarts4r::e_x_axis(name = "Horário de medição", type = "time", time_format = "%d/%m/%Y %H:%M") |>
        echarts4r::e_y_axis(name = "Metros") |>
        echarts4r::e_datazoom() |>
        echarts4r::e_locale("PT-br") |>
        echarts4r::e_text_style(fontFamily = "Nunito", font_size = 12, font_weight = "bold", color='white') |>
        echarts4r::e_color(color = c("white")) |>
        echarts4r::e_legend(textStyle = list(fontSize = 16, fontFamily = 'Nunito',color='white'))

    })

  })
}
## To be copied in the UI
# mod_mapas_bacias_ui("mapas_bacias_1")

## To be copied in the server
# mod_mapas_bacias_server("mapas_bacias_1")
