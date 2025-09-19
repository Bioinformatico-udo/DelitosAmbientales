# R/kpi_functions.R
# ==========================================
# Funciones para calcular KPIs
# ==========================================

# Total de casos
kpi_total_casos <- function(datos) {
  sum(datos$Frecuencia, na.rm = TRUE)
}

# Número de parques únicos
kpi_parques <- function(datos) {
  length(unique(datos$Parque))
}

# Número de años registrados
kpi_anios <- function(datos) {
  length(unique(datos$Año))
}

# Número de delitos únicos
kpi_delitos_unicos <- function(datos) {
  length(unique(datos$Tipo_Delito))
}

# Número de sanciones únicas
kpi_sanciones_unicas <- function(datos) {
  length(unique(datos$Sanción))
}

# Promedio de casos por año
kpi_promedio_casos <- function(datos) {
  if (nrow(datos) == 0) return(0)
  años <- unique(datos$Año)
  if (length(años) == 0) return(0)
  promedio <- sum(datos$Frecuencia, na.rm = TRUE) / length(años)
  round(promedio, 1)
}