# R/map_functions.R
# ==========================================
# Funciones para mapas del dashboard
# ==========================================
library(leaflet)
library(dplyr)

# Mapa de calor de delitos por parque
mapa_delitos <- function(datos) {
  # Agrupar datos por parque
  df <- datos %>%
    group_by(Parque) %>%
    summarise(
      Total = sum(Frecuencia, na.rm = TRUE),
      Latitud = first(na.omit(Latitud)),
      Longitud = first(na.omit(Longitud))
    ) %>%
    filter(!is.na(Latitud) & !is.na(Longitud))
  
  if (nrow(df) == 0) {
    return(leaflet() %>% 
             addTiles() %>% 
             addControl("No hay datos de ubicación disponibles", position = "topright"))
  }
  
  # Paleta de colores
  pal <- colorNumeric(palette = "Reds", domain = df$Total)
  
  # Crear mapa
  mapa <- leaflet(df) %>%
    addTiles() %>%
    addCircleMarkers(
      lng = ~Longitud, 
      lat = ~Latitud,
      radius = ~sqrt(Total)*3 + 5, # Tamaño proporcional
      color = ~pal(Total),
      fillColor = ~pal(Total),
      fillOpacity = 0.7,
      stroke = TRUE,
      weight = 1,
      popup = ~paste("<b>Parque:</b>", Parque, "<br>",
                    "<b>Total de casos:</b>", Total)
    ) %>%
    addLegend(
      position = "bottomright",
      pal = pal,
      values = ~Total,
      title = "Número de casos",
      opacity = 1
    )
  
  return(mapa)
}