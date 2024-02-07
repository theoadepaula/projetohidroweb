## code to prepare `estacoes_fluviometricas` dataset goes here


estacoes_fluviometricas <- pegar_estacoes_fluviometricas |>
  dplyr::left_join(bacias_subbacias,by = join_by(bacia_codigo == cod_bacia, sub_bacia_codigo == cod_sub_bacia)) |>
  dplyr::relocate(nm_bacia,nm_sub_bacia,.after = nome ) |>
  dplyr::select(-sub_bacia_codigo)

usethis::use_data(estacoes_fluviometricas, overwrite = TRUE)
