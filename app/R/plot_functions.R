# R/plot_functions.R
# ==========================================
# Funciones para gráficos del dashboard
# ==========================================
library(dplyr)
library(ggplot2)
library(plotly)

# --- Gráfico de delitos por parque con tooltips informativos ---
plot_por_parque <- function(datos) {
  if (nrow(datos) == 0) return(plotly_empty())
  
  df <- datos %>%
    group_by(Parque) %>%
    summarise(Total = sum(Frecuencia, na.rm = TRUE)) %>%
    arrange(desc(Total))
  
  # Limitar a los 15 parques principales para mejor visualización
  if (nrow(df) > 15) {
    otros <- sum(df$Total[16:nrow(df)])
    df <- df[1:15, ]
    df <- rbind(df, data.frame(Parque = "Otros", Total = otros))
  }
  
  plot_ly(df, 
          x = ~reorder(Parque, -Total), 
          y = ~Total, 
          type = 'bar',
          marker = list(color = '#1f77b4'),
          hoverinfo = 'text',
          text = ~paste('</br> <b>Parque:</b> ', Parque,
                        '</br> <b>Casos:</b> ', format(Total, big.mark = ".", decimal.mark = ","),
                        '</br> <b>Porcentaje:</b> ', round(Total/sum(Total)*100, 1), '%'),
          hovertemplate = '%{text}<extra></extra>') %>%
    layout(title = list(text = "", y = 0.98),
           xaxis = list(title = "", tickangle = 45, categoryorder = "total descending"),
           yaxis = list(title = "Cantidad de Casos"),
           hoverlabel = list(bgcolor = "white", font = list(size = 12)),
           margin = list(b = 100)) # Margen inferior para etiquetas largas
}

# --- Gráfico de delitos por año con línea de tendencia ---
plot_por_año <- function(datos) {
  if (nrow(datos) == 0) return(plotly_empty())
  
  df <- datos %>%
    group_by(Año) %>%
    summarise(Total = sum(Frecuencia, na.rm = TRUE)) %>%
    arrange(Año)
  
  # Determinar breaks cada 5 años
  years <- sort(unique(df$Año))
  min_year <- min(years, na.rm = TRUE)
  max_year <- max(years, na.rm = TRUE)
  breaks_5 <- seq(min_year, max_year, by = 5)
  
  plot_ly(df) %>%
    add_bars(x = ~Año, y = ~Total, name = "Casos por año",
             marker = list(color = '#2ca02c'),
             hoverinfo = 'text',
             text = ~paste('</br> <b>Año:</b> ', Año,
                           '</br> <b>Casos:</b> ', format(Total, big.mark = ".", decimal.mark = ",")),
             hovertemplate = '%{text}<extra></extra>') %>%
    add_lines(x = ~Año, y = ~fitted(loess(Total ~ Año)), name = "Tendencia", 
              line = list(color = 'red', width = 3, dash = 'dash'),
              hoverinfo = 'none') %>%
    layout(title = list(text = "", y = 0.98),
           xaxis = list(title = "Año", tickvals = breaks_5),
           yaxis = list(title = "Cantidad de Casos"),
           showlegend = FALSE,
           hoverlabel = list(bgcolor = "white", font = list(size = 12)))
}

# --- Pie chart de tipos de delito con mejor visualización ---
plot_torta_delitos <- function(datos) {
  if (nrow(datos) == 0) return(plotly_empty())
  
  df <- datos %>%
    group_by(Tipo_Delito) %>%
    summarise(Total = sum(Frecuencia, na.rm = TRUE)) %>%
    arrange(desc(Total))
  
  # Limitar a los 5 delitos principales para mejor visualización
  if (nrow(df) > 5) {
    otros <- sum(df$Total[11:nrow(df)])
    df <- df[1:5, ]
    df <- rbind(df, data.frame(Tipo_Delito = "Otros", Total = otros))
  }
  
  plot_ly(df,
          labels = ~Tipo_Delito,
          values = ~Total,
          type = 'pie',
          textinfo = 'label+percent',
          insidetextorientation = 'radial',
          hoverinfo = 'label+value+percent',
          texttemplate = '%{label}<br>%{percent:.1%}',
          hovertemplate = '<b>%{label}</b><br>Casos: %{value}<br>Porcentaje: %{percent}<extra></extra>',
          showlegend = FALSE) %>%
    layout(title = list(text = "", y = 0.98),
           uniformtext = list(minsize = 10, mode = "hide"))
}

# --- Pie chart de tipos de sanción con mejor visualización ---
plot_torta_sancion <- function(datos) {
  if (nrow(datos) == 0) return(plotly_empty())
  
  df <- datos %>%
    mutate(Sanción = ifelse(is.na(Sanción) | Sanción == "", "Sin sanción", Sanción)) %>%
    group_by(Sanción) %>%
    summarise(Total = sum(Frecuencia, na.rm = TRUE)) %>%
    arrange(desc(Total))
  
  # Limitar a los 8 tipos principales de sanción
  if (nrow(df) > 8) {
    otros <- sum(df$Total[9:nrow(df)])
    df <- df[1:8, ]
    df <- rbind(df, data.frame(Sanción = "Otras", Total = otros))
  }
  
  plot_ly(df,
          labels = ~Sanción,
          values = ~Total,
          type = 'pie',
          textinfo = 'label+percent',
          insidetextorientation = 'radial',
          hoverinfo = 'label+value+percent',
          texttemplate = '%{label}<br>%{percent:.1%}',
          hovertemplate = '<b>%{label}</b><br>Casos: %{value}<br>Porcentaje: %{percent}<extra></extra>',
          showlegend = FALSE) %>%
    layout(title = list(text = "", y = 0.98),
           uniformtext = list(minsize = 10, mode = "hide"))
}