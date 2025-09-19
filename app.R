# app.R
# ==========================================
# Dashboard dinámico estilo Power BI
# ==========================================

# --- Librerías ---
library(shiny)
library(shinydashboard)
library(openxlsx) # para exportar a Excel
library(leaflet)  # para mapas interactivos
library(shinycssloaders) # para indicadores de carga
library(shinyBS)  # para tooltips informativos

# --- Cargar funciones ---
source("R/load_data.R")
source("R/kpi_functions.R")
source("R/plot_functions.R")
source("R/table_functions.R")
source("R/map_functions.R") # Nuevo archivo para funciones de mapa

# --- Cargar datos ---
datos <- cargar_datos("data/Datos_Tesis.xlsx")

# ========================================================
# UI
# ========================================================

ui <- dashboardPage(
  dashboardHeader(title = "Delitos Ambientales - Nueva Esparta"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Resumen", tabName = "resumen", icon = icon("dashboard")),
      menuItem("Gráficos", tabName = "graficos", icon = icon("chart-bar")),
      menuItem("Mapa", tabName = "mapa", icon = icon("map")),
      menuItem("Tablas", tabName = "tablas", icon = icon("table")),
      menuItem("Datos Filtrados", tabName = "datos", icon = icon("database"))
    ),
    selectInput("filtroParque", "Parque/Monumento",
                choices = c("Todos", sort(unique(datos$Parque))),
                selected = "Todos"),
    selectInput("filtroAño", "Año",
                choices = c("Todos", sort(unique(datos$Año))),
                selected = "Todos"),
    selectInput("filtroDelito", "Tipo de Delito",
                choices = c("Todos", sort(unique(datos$Tipo_Delito))),
                selected = "Todos"),
    selectInput("filtroSancion", "Sanción",
                choices = c("Todos", sort(unique(datos$Sanción))),
                selected = "Todos"),
    actionButton("resetFiltros", "Resetear Filtros", icon = icon("refresh"),
                 style = "color: #fff; background-color: #dc3545; border-color: #dc3545; width: 87%")
  ),
  
  dashboardBody(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
    tabItems(
      # Resumen
      tabItem(tabName = "resumen",
              fluidRow(
                valueBoxOutput("totalCasos"),
                valueBoxOutput("parques"),
                valueBoxOutput("anios"),
                valueBoxOutput("delitosUnicos"),
                valueBoxOutput("sancionesUnicas"),
                valueBoxOutput("promedioCasos")
              )),
      
      # Gráficos
      tabItem(tabName = "graficos",
              fluidRow(
                box(title = "Delitos por Parque", width = 6, status = "primary",
                    withSpinner(plotlyOutput("graficoPorParque"), type = 6, color = "#1E90FF")),
                box(title = "Delitos por Año", width = 6, status = "primary",
                    withSpinner(plotlyOutput("graficoPorAño"), type = 6, color = "#1E90FF"))
              ),
              fluidRow(
                box(title = "Distribución Tipos de Delito (%)", width = 6, status = "primary",
                    withSpinner(plotlyOutput("graficoTortaDelitos"), type = 6, color = "#1E90FF")),
                box(title = "Distribución Tipos de Sanción (%)", width = 6, status = "primary",
                    withSpinner(plotlyOutput("graficoTortaSancion"), type = 6, color = "#1E90FF"))
              )),
      # Mapa
      tabItem(tabName = "mapa",
              fluidRow(
                box(title = "Distribución Geográfica de Delitos", width = 12, status = "primary",
                    withSpinner(leafletOutput("mapaDelitos"), type = 6, color = "#1E90FF"))
              )),
      # Tablas
      tabItem(tabName = "tablas",
              fluidRow(
                box(title = "Resumen Delitos", width = 6, status = "primary",
                    withSpinner(DTOutput("tablaResumenDelitos"), type = 6, color = "#1E90FF")),
                box(title = "Resumen Sanciones", width = 6, status = "primary",
                    withSpinner(DTOutput("tablaResumenSanciones"), type = 6, color = "#1E90FF"))
              )),
      # Datos Filtrados
      tabItem(tabName = "datos",
              fluidRow(
                box(title = "Datos Filtrados", width = 12, status = "primary",
                    downloadButton("descargarCSV", "Descargar CSV", class = "btn-primary"),
                    downloadButton("descargarXLSX", "Descargar Excel", class = "btn-success"),
                    withSpinner(DTOutput("tablaFiltrada"), type = 6, color = "#1E90FF"))
              ))
    )
  )
)

# ========================================================
# SERVER
# ========================================================

server <- function(input, output, session) {
  
  # --- Filtros dinámicos ---
  observe({
    df <- datos
    updateSelectInput(session, "filtroParque", choices = c("Todos", sort(unique(df$Parque))))
  })
  
  observe({
    df <- datos
    if (input$filtroParque != "Todos") {
      df <- df[df$Parque == input$filtroParque,]
    }
    updateSelectInput(session, "filtroAño", choices = c("Todos", sort(unique(df$Año))))
  })
  
  observe({
    df <- datos
    if (input$filtroParque != "Todos") {
      df <- df[df$Parque == input$filtroParque,]
    }
    if (input$filtroAño != "Todos") {
      df <- df[df$Año == input$filtroAño,]
    }
    updateSelectInput(session, "filtroDelito", choices = c("Todos", sort(unique(df$Tipo_Delito))))
  })
  
  observe({
    df <- datos
    if (input$filtroParque != "Todos") {
      df <- df[df$Parque == input$filtroParque,]
    }
    if (input$filtroAño != "Todos") {
      df <- df[df$Año == input$filtroAño,]
    }
    if (input$filtroDelito != "Todos") {
      df <- df[df$Tipo_Delito == input$filtroDelito,]
    }
    updateSelectInput(session, "filtroSancion", choices = c("Todos", sort(unique(df$Sanción))))
  })
  
  # Función para resetear filtros
  observeEvent(input$resetFiltros, {
    updateSelectInput(session, "filtroParque", selected = "Todos")
    updateSelectInput(session, "filtroAño", selected = "Todos")
    updateSelectInput(session, "filtroDelito", selected = "Todos")
    updateSelectInput(session, "filtroSancion", selected = "Todos")
  })
  
  # --- Datos filtrados dinámicamente ---
  datos_filtrados <- reactive({
    df <- datos
    if (input$filtroParque != "Todos") df <- df[df$Parque == input$filtroParque,]
    if (input$filtroAño != "Todos") df <- df[df$Año == input$filtroAño,]
    if (input$filtroDelito != "Todos") df <- df[df$Tipo_Delito == input$filtroDelito,]
    if (input$filtroSancion != "Todos") df <- df[df$Sanción == input$filtroSancion,]
    df
  })
  
  # KPIs
  output$totalCasos <- renderValueBox({
    valueBox(kpi_total_casos(datos_filtrados()), "Total de Casos", icon = icon("exclamation-triangle"), color = "red")
  })
  output$parques <- renderValueBox({
    valueBox(kpi_parques(datos_filtrados()), "Parques/Monumentos", icon = icon("tree"), color = "green")
  })
  output$anios <- renderValueBox({
    valueBox(kpi_anios(datos_filtrados()), "Años Registrados", icon = icon("calendar"), color = "blue")
  })
  output$delitosUnicos <- renderValueBox({
    valueBox(kpi_delitos_unicos(datos_filtrados()), "Delitos", icon = icon("gavel"), color = "orange")
  })
  output$sancionesUnicas <- renderValueBox({
    valueBox(kpi_sanciones_unicas(datos_filtrados()), "Sanciones", icon = icon("balance-scale"), color = "purple")
  })
  output$promedioCasos <- renderValueBox({
    valueBox(kpi_promedio_casos(datos_filtrados()), "Promedio por Año", icon = icon("chart-line"), color = "teal")
  })
  
  # Gráficos
  output$graficoPorParque <- renderPlotly({ plot_por_parque(datos_filtrados()) })
  output$graficoPorAño <- renderPlotly({ plot_por_año(datos_filtrados()) })
  output$graficoTortaDelitos <- renderPlotly({ plot_torta_delitos(datos_filtrados()) })
  output$graficoTortaSancion <- renderPlotly({ plot_torta_sancion(datos_filtrados()) })
  
  # Mapa
  output$mapaDelitos <- renderLeaflet({ mapa_delitos(datos_filtrados()) })
  
  # Tablas resumen
  output$tablaResumenDelitos <- renderDT({ tabla_resumen_delitos(datos_filtrados()) })
  output$tablaResumenSanciones <- renderDT({ tabla_resumen_sanciones(datos_filtrados()) })
  
  # Tabla filtrada
  output$tablaFiltrada <- renderDT({ tabla_filtrada(datos_filtrados()) })
  
  # Descarga CSV
  output$descargarCSV <- downloadHandler(
    filename = function() { paste0("delitos_ambientales_", Sys.Date(), ".csv") },
    content = function(file) { write.csv2(datos_filtrados(), file, row.names = FALSE, fileEncoding = "UTF-8") }
  )
  
  # Descarga Excel
  output$descargarXLSX <- downloadHandler(
    filename = function() { paste0("delitos_ambientales_", Sys.Date(), ".xlsx") },
    content = function(file) { openxlsx::write.xlsx(datos_filtrados(), file) }
  )
}

# ========================================================
# Lanzar app
# ========================================================
shinyApp(ui, server)