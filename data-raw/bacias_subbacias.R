## code to prepare `bacias_subbacias` dataset goes here

link_bac <- 'https://www.ana.gov.br/telemetria1ws//ServiceANA.asmx/HidroBaciaSubBacia?codBacia=&codSubBacia='

url_bacias <- httr::GET(link_bac) |> httr::content()

doc_bac <- XML::xmlParse(url_bacias)

lista_bacias <- XML::xmlParse(url_bacias) |>
  XML::xmlToDataFrame(nodes = getNodeSet(doc_bac,"//Table")) |>
  tibble::as_tibble() |>
  janitor::clean_names()

bacias_subbacias <- lista_bacias |>
  dplyr::distinct(cod_bacia,nm_bacia,cod_sub_bacia,nm_sub_bacia,.keep_all = TRUE)


usethis::use_data(bacias_subbacias, overwrite = TRUE)
