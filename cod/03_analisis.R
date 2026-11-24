# Proyecto individual - Simulación Monte Carlo
# 03_analisis.R
# Procesamiento de datos y ejecución de simulaciones


# 1. Limpieza de datos
source("cod/01_importar.R")
source("cod/02_funciones.R")
apple <- limpiar_apple(Apple)
nvda <- limpiar_nvidia(NVDA)

# 2. Delimitacion del periodo de trabajo (2021 - 2024)


apple_trabajo <- apple %>%
  filter(
    date >= as.Date("2021-01-01"),
    date <= as.Date("2024-12-31")
  ) %>%
  arrange(date) %>%
  select(date, close)

nvda_trabajo <- nvda %>%
  filter(
    date >= as.Date("2021-01-01"),
    date <= as.Date("2024-12-31")
  ) %>%
  arrange(date) %>%
  select(date, close)


# 3. Cálculo de rendimientos logarítmicos

apple_trabajo <- calcular_rendimientos(apple_trabajo)

nvda_trabajo <- calcular_rendimientos(nvda_trabajo)


# 4. Estimación de parametros
apple_stats <- apple_trabajo %>%
  summarise(
    mu = mean(daily.return, na.rm = TRUE),
    sigma = sd(daily.return, na.rm = TRUE)
  )

nvda_stats <- nvda_trabajo %>%
  summarise(
    mu = mean(daily.return, na.rm = TRUE),
    sigma = sd(daily.return, na.rm = TRUE)
  )

# 5. Simulación Monte Carlo

set.seed(1)

sim_apple <- montecarlo(
  P0 = tail(apple_trabajo$close, 1),
  mu = apple_stats$mu,
  sigma = apple_stats$sigma,
  n.dias = 30,
  n.tray = 1000
)

sim_nvidia <- montecarlo(
  P0 = tail(nvda_trabajo$close, 1),
  mu = nvda_stats$mu,
  sigma = nvda_stats$sigma,
  n.dias = 30,
  n.tray = 1000
)

# 6. Precios reales de los primeros 30 días bursátiles de 2025

apple_real <- apple %>%
  filter(date >= as.Date("2025-01-01")) %>%
  arrange(date) %>%
  slice_head(n = 30) %>%
  select(date, close)

nvda_real <- nvda %>%
  filter(date >= as.Date("2025-01-01")) %>%
  arrange(date) %>%
  slice_head(n = 30) %>%
  select(date, close)

# 7. Comparación entre precios simulados y reales

comparacion_precios <- tibble(
  accion = c("Apple", "Nvidia"),
  promedio_simulado = c(
    mean(sim_apple[30, ]),
    mean(sim_nvidia[30, ])
  ),
  precio_real = c(
    tail(apple_real$close, 1),
    tail(nvda_real$close, 1)
  )
) %>%
  mutate(
    diferencia = promedio_simulado - precio_real,
    diferencia_porcentual = 100 * diferencia / precio_real
  )