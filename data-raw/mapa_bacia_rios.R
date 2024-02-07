## code to prepare `mapa_bacia_rios` dataset goes here

mapa_hidro <- sf::read_sf('data/macro_RH/macro_RH.shp')
mapa_rio <- sf::read_sf('data/GEOFT_BHO_REF_RIO/GEOFT_BHO_REF_RIO.shp')
load('data/estacoes_fluviometricas.rda')

estacoes_flu_mapa <- estacoes_fluviometricas |>
  st_as_sf(coords = c("longitude","latitude"))

mapa_hidro <- st_transform(mapa_hidro, crs = st_crs("+proj=longlat +datum=WGS84"))
mapa_rio <- st_transform(mapa_rio, crs = st_crs("+proj=longlat +datum=WGS84"))
st_crs(estacoes_flu_mapa) <- st_crs("+proj=longlat +datum=WGS84")

mapa_rio_reduzido <- mapa_rio |>
  mutate(
    tamanho = sf::st_length(mapa_rio) |> as.numeric()
  ) |>
  filter(
    tamanho>100000
  )

pegar_intersecao_rio <- function(x) {
  st_intersection(mapa_hidro |>
                    filter(fid==x),mapa_rio_reduzido)
}

safe_pegar_intersecao_rio <- safely(pegar_intersecao_rio,tibble())

mapa_bacia_ <-
  map(1:12,\(x){
    safe_pegar_intersecao_rio(x)
  },.progress = TRUE)

mapa_bacia_ <-
  keep(mapa_bacia_,\(x) is.null(x$error))

mapa_bacia_rios <- mapa_bacia_

mapa_bacia_rios <- map(mapa_bacia_rios,'result')

usethis::use_data(mapa_bacia_rios, overwrite = TRUE)

