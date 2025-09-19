# ========================================================
# install_packages.R
# Instala todas las librerías necesarias para el dashboard
# ========================================================

# Vector con los paquetes requeridos
paquetes <- c(
  "shiny",
  "shinydashboard",
  "readxl",
  "dplyr",
  "ggplot2",
  "plotly",
  "DT"
)

# Función para instalar si no está ya instalado
instalar_si_falta <- function(pkg){
  if(!requireNamespace(pkg, quietly = TRUE)){
    install.packages(pkg)
  }
}

# Instalar todos los paquetes
invisible(lapply(paquetes, instalar_si_falta))

# Cargar todos los paquetes (opcional)
lapply(paquetes, library, character.only = TRUE)

cat("\n✅ Todas las librerías están instaladas y cargadas.\n")
