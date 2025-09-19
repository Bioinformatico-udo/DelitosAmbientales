# R/table_functions.R
# ==========================================
# Funciones para tablas del dashboard
# ==========================================
library(dplyr)
library(DT)

# --- Resumen de delitos ---
tabla_resumen_delitos <- function(datos) {
  if (nrow(datos) == 0) {
    return(datatable(data.frame(Mensaje = "No hay datos para mostrar"), rownames = FALSE))
  }
  
  df <- datos %>%
    group_by(Tipo_Delito) %>%
    summarise(Casos = sum(Frecuencia, na.rm = TRUE)) %>%
    arrange(desc(Casos)) %>%
    rename(Delito = Tipo_Delito)   # Cambiar cabecera
  
  datatable(df,
            options = list(
              pageLength = 17,
              order = list(list(1, 'desc')),
              dom = 't',
              language = list(
                url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json'
              )
            ),
            rownames = FALSE) %>%
    formatCurrency('Casos', currency = "", digits = 0, mark = ".", dec.mark = ",")
}

# --- Resumen de sanciones ---
tabla_resumen_sanciones <- function(datos) {
  if (nrow(datos) == 0) {
    return(datatable(data.frame(Mensaje = "No hay datos para mostrar"), rownames = FALSE))
  }
  
  df <- datos %>%
    mutate(Sanción = ifelse(is.na(Sanción) | Sanción == "", "Sin sanción", Sanción)) %>%
    group_by(Sanción) %>%
    summarise(Casos = sum(Frecuencia, na.rm = TRUE)) %>%
    arrange(desc(Casos))
  
  datatable(df,
            options = list(
              pageLength = 6,
              order = list(list(1, 'desc')),
              dom = 't',
              language = list(
                url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json'
              )
            ),
            rownames = FALSE) %>%
    formatCurrency('Casos', currency = "", digits = 0, mark = ".", dec.mark = ",")
}

# --- Tabla filtrada completa ---
tabla_filtrada <- function(datos) {
  if (nrow(datos) == 0) {
    return(datatable(data.frame(Mensaje = "No hay datos para mostrar con los filtros aplicados"), rownames = FALSE))
  }
  
  df <- datos %>%
    mutate(Sanción = ifelse(is.na(Sanción) | Sanción == "", "Sin sanción", Sanción))
  
  datatable(df, 
            extensions = c('Buttons', 'Scroller'),
            options = list(
              pageLength = 10,
              dom = 'Bfrtip',
              buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
              scrollX = TRUE,
              scrollY = "400px",
              scroller = TRUE,
              autoWidth = TRUE,
              language = list(
                url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json'
              )
            ),
            rownames = FALSE) %>%
    formatStyle(columns = names(df), fontSize = '12px')
}