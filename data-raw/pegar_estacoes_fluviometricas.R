## code to prepare `pegar_estacoes_fluviometricas` dataset goes here

link <- 'https://www.ana.gov.br/telemetria1ws/ServiceANA.asmx/HidroInventario?codEstDE=&codEstATE=&tpEst=1&nmEst=&nmRio=&codSubBacia=&codBacia=&nmMunicipio=&nmEstado=&sgResp=&sgOper=&telemetrica='

url_estacoes_flu <- httr::GET(link) |> httr::content()

doc <- XML::xmlParse(url_estacoes_flu)

lista_estacoes <- doc |>
  XML::xmlToDataFrame(nodes = XML::getNodeSet(doc,"//Table")) |>
  tibble::as_tibble() |>
  janitor::clean_names()

pegar_estacoes_fluviometricas <- lista_estacoes |>
  dplyr::filter(!nm_estado %in% c('EQUADOR','ARGENTINA','PERU','COLÔMBIA','BOLÍVIA','SURINAME','PARAGUAI','URUGUAI','GUIANA','GUIANA FRANCESA'))

pegar_estacoes_fluviometricas <- pegar_estacoes_fluviometricas |>
  dplyr::distinct(.keep_all = TRUE) |>
  dplyr::select(codigo,nome,bacia_codigo,sub_bacia_codigo,
         nm_estado,municipio_codigo,nm_municipio,
         latitude,longitude,altitude,periodo_escala_inicio,periodo_escala_fim)


usethis::use_data(pegar_estacoes_fluviometricas, overwrite = TRUE)
