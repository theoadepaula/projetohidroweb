## code to prepare `dados_estacoes_fluviometricas` dataset goes here

lista_dados <- purrr::map(
  estacoes_fluviometricas$codigo,
  function(x){
    pegar_dados_hidrometeorologicos(x,'20/12/2023')
  },.progress = TRUE
)

dados_estacoes_fluviometricas <-
  dplyr::bind_rows(lista_dados) |>
  dplyr::left_join(estacoes_fluviometricas,dplyr::join_by(cod_estacao==codigo))

dados_estacoes_fluviometricas <- dados_estacoes_fluviometricas |>
  dplyr::filter(nivel!='')

codigos_nivel <- dados_estacoes_fluviometricas |>
  dplyr::distinct(cod_estacao) |>
  dplyr::pull()

usethis::use_data(dados_estacoes_fluviometricas, overwrite = TRUE)
