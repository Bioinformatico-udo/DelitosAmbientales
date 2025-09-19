# 🚨 Dashboard de Delitos Ambientales - Nueva Esparta

Dashboard interactivo para el análisis y visualización de delitos ambientales cometidos en parques y monumentos naturales del Estado Nueva Esparta, Venezuela.

## 📊 Características

- **Visualización Interactiva**: Gráficos dinámicos con Plotly
- **Filtros Avanzados**: Filtrado por parque, año, tipo de delito y sanción
- **Mapa Interactivo**: Visualización geográfica de los delitos (si hay datos de coordenadas)
- **KPIs en Tiempo Real**: Métricas actualizadas según los filtros aplicados
- **Exportación de Datos**: Descarga de datos en CSV y Excel
- **Diseño Responsive**: Adaptable a diferentes dispositivos

## 🛠️ Tecnologías Utilizadas

- **R**: Lenguaje de programación estadístico
- **Shiny**: Framework para aplicaciones web interactivas
- **ShinyDashboard**: Plantilla para dashboards profesionales
- **Plotly**: Gráficos interactivos
- **Leaflet**: Mapas interactivos
- **DT**: Tablas dinámicas con DataTables
- **Docker**: Contenerización para despliegue

## 📦 Instalación Local

### Prerrequisitos

- R (≥ 4.0.0)
- RStudio (recomendado)

### Pasos de Instalación

1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/tu-usuario/delitos-ambientales.git
   cd DelitosAmbientales
Instalar dependencias de R:

2. **Instalar dependencias de R:**

r
install.packages(c("shiny", "shinydashboard", "openxlsx", "readxl", "dplyr", 
                  "ggplot2", "plotly", "DT", "leaflet", "shinycssloaders", "shinyBS"))

3. **Colocar los datos:**

Asegúrate de tener el archivo Datos_Tesis.xlsx en la carpeta app/data/

4. **Ejecutar la aplicación:**

r
shiny::runApp("app") 

🐳 **Ejecución con Docker**

**Construir la imagen**
bash
docker build -t delitos-ambientales .
**Ejecutar el contenedor**
bash
docker run -p 3838:3838 delitos-ambientales
**Usar docker-compose**
bash
docker-compose up -d
La aplicación estará disponible en: http://localhost:3838

🌐 **Despliegue en Producción**

**Opción 1: ShinyApps.io (Recomendado)**
1. Crear cuenta en shinyapps.io

2. Configurar secrets en GitHub:

SHINYAPPS_TOKEN

SHINYAPPS_SECRET

**Opción 2: Servidor propio**
bash
# En el servidor
git clone https://github.com/tu-usuario/delitos-ambientales.git
cd delitos-ambientales
docker-compose up -d

📁 **Estructura del Proyecto**

delitos-ambientales/
├── app/
│   ├── app.R                 # Aplicación principal Shiny
│   ├── R/
│   │   ├── load_data.R       # Carga y limpieza de datos
│   │   ├── kpi_functions.R   # Funciones para KPIs
│   │   ├── plot_functions.R  # Funciones para gráficos
│   │   ├── table_functions.R # Funciones para tablas
│   │   └── map_functions.R   # Funciones para mapas
│   ├── data/
│   │   └── Datos_Tesis.xlsx  # Datos originales
│   └── www/
│       └── custom.css        # Estilos personalizados
├── .github/
│   └── workflows/
│       └── deploy.yml        # GitHub Actions para deploy
├── docs/
│   └── index.html           # Landing page para GitHub Pages
├── Dockerfile               # Configuración de Docker
├── docker-compose.yml       # Orquestación de contenedores
├── .gitignore              # Archivos ignorados por git
└── README.md               # Este archivo

🚀 **Uso del Dashboard**
1. **Panel de Resumen**: Visualiza los KPIs principales

2. **Gráficos**: Explora los datos through gráficos interactivos

3. **Mapa**: Ve la distribución geográfica de los delitos

4. **Tablas**: Consulta los datos detallados

5. **Filtros**: Usa los filtros laterales para segmentar los datos

6. **Exportación**: Descarga los datos filtrados en CSV o Excel

📊 **KPIs Disponibles**
✅ Total de casos registrados

✅ Número de parques/monumentos afectados

✅ Años con registros disponibles

✅ Tipos de delitos únicos

✅ Tipos de sanciones aplicadas

✅ Promedio de casos por año

🤝 **Contribución**
1. Fork el proyecto

2. Crear una rama para tu feature (git checkout -b feature/AmazingFeature)

3. Commit tus cambios (git commit -m 'Add some AmazingFeature')

4. Push a la rama (git push origin feature/AmazingFeature)

5. Abrir un Pull Request

📝 **Licencia**
Este proyecto está bajo la Licencia MIT. Ver el archivo LICENSE para más detalles.

📞 **Soporte**
Si tienes preguntas o problemas:

Revisa la documentación de Shiny

Abre un issue en GitHub

Contacta al equipo de desarrollo

🙏 **Agradecimientos**
Equipo de RStudio por las herramientas de Shiny

Comunidad de R por el soporte continuo

Gobierno de Nueva Esparta por proveer los datos

Desarrollado con ❤️ para la conservación ambiental de Nueva Esparta



 
