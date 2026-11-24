# Proyecto individual - Simulación Monte Carlo
# 01_importar.R
# Importación de los precios históricos de Apple y Nvidia

library(readxl)

Apple <- read_excel("data/Apple.xlsx", skip = 14)

NVDA <- read_excel("data/NVDA.xlsx")