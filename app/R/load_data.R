# R/load_data.R
# ==========================================
# Función para cargar y preparar los datos
# ==========================================

cargar_datos <- function(path) {
  library(readxl)
  library(dplyr)
  
  # Verificar que el archivo existe
  if (!file.exists(path)) {
    stop("El archivo de datos no existe en la ruta especificada: ", path)
  }
  
  # Cargar primera hoja del Excel
  datos <- read_excel(path)
  
  # Verificar columnas esenciales
  columnas_requeridas <- c("Año", "Parque o Monumento", "Ilícito", "Sanción")
  if (!all(columnas_requeridas %in% names(datos))) {
    stop("El archivo no tiene las columnas requeridas: ", paste(columnas_requeridas, collapse = ", "))
  }
  
  # Renombrar columnas clave a nombres estándar del dashboard
  datos <- datos %>%
    rename(
      Año = `Año`,
      Parque = `Parque o Monumento`,
      Tipo_Delito = `Ilícito`,
      Sanción = `Sanción`
    )
  
  # Si la columna Frecuencia tiene NA, poner 1 por defecto
  if("Frecuencia" %in% names(datos)){
    datos$Frecuencia[is.na(datos$Frecuencia)] <- 1
  } else {
    datos$Frecuencia <- 1
  }
  
  # Convertir a tipos de datos apropiados
  datos$Año <- as.numeric(datos$Año)
  datos$Frecuencia <- as.numeric(datos$Frecuencia)
  
  # Limpiar textos
  datos$Parque <- trimws(datos$Parque)
  datos$Tipo_Delito <- trimws(datos$Tipo_Delito)
  datos$Sanción <- trimws(datos$Sanción)
  
  message("Datos cargados exitosamente: ", nrow(datos), " registros")
  
  return(datos)
}