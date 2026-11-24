# Simulación Monte Carlo de precios de Apple y Nvidia

**Universidad de Costa Rica**  
**CA0204 — Herramientas de Ciencias de Datos I**  
**Autor:** Daniel Víquez

## Descripción

Este proyecto utiliza simulación Monte Carlo para generar posibles trayectorias de los precios de las acciones de Apple (AAPL) y Nvidia (NVDA), a partir de sus rendimientos logarítmicos diarios durante el período 2021–2024.

Se estiman la media y la desviación estándar de los rendimientos históricos, suponiendo que siguen una distribución normal y son independientes. Posteriormente, se generan 1000 trayectorias de 30 días bursátiles para cada acción.

Los resultados se comparan con los precios reales observados durante los primeros 30 días bursátiles de 2025.

## Estructura del proyecto

| Carpeta | Contenido |
|---|---|
| `cod/` | Scripts de importación, limpieza, funciones, análisis y resultados. |
| `data/` | Bases históricas de Apple y Nvidia en formato Excel. |
| `info/` | Información complementaria y fuentes de referencia. |
| `config/` | Archivos de configuración del proyecto. |
| `res/` | Gráficos, tablas y documentos de resultados. |

## Scripts principales

- **01_importar.R:** importa las bases históricas de Apple y Nvidia.
- **02_funciones.R:** contiene las funciones de limpieza, cálculo de rendimientos y simulación Monte Carlo.
- **03_analisis.R:** delimita el período de trabajo, estima los parámetros, ejecuta las simulaciones y compara los resultados con los precios reales.
- **04_resultados.R:** genera las tablas y visualizaciones del análisis.

## Herramientas utilizadas

El proyecto se desarrolló en R y RStudio, utilizando principalmente los paquetes `tidyverse`, `readxl`, `ggplot2` y `patchwork`.

## Ejecución

Para reproducir el análisis:

1. Descargar o clonar el repositorio.
2. Abrir RStudio y establecer la carpeta principal del proyecto como directorio de trabajo.
3. Instalar los paquetes necesarios, si todavía no están disponibles.
4. Ejecutar `source("cod/03_analisis.R")` para realizar las simulaciones.
5. Ejecutar `source("cod/04_resultados.R")` para generar las tablas y los gráficos.

Las simulaciones utilizan una semilla aleatoria fija para facilitar la reproducibilidad.

## Consideraciones

Los resultados dependen de los datos históricos y de los supuestos estadísticos utilizados. Las trayectorias simuladas representan escenarios posibles bajo el modelo, no predicciones exactas de los precios futuros.