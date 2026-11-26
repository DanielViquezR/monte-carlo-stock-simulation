# Proyecto individual - Simulación Monte Carlo
# 04_resultados.R
# Elaboración de gráficos y tablas
library(patchwork)
# 1. Cargar análisis
source("cod/03_analisis.R")

# 2. Gráfico de precios históricos
grafico_apple <- ggplot(apple_trabajo, aes(x = date, y = close)) +
  geom_line(color = "#9EADFF") +
  labs(
    title = "Evolución del precio de Apple",
    x = "Fecha",
    y = "Precio de cierre (USD)"
  ) +
  theme_minimal()

# 3. Tabla comparativa
tabla_comparacion <- comparacion_precios

# 4. Trayectorias simuladas de Apple

sim_apple_df <- as.data.frame(sim_apple[, 1:100])

sim_apple_df$dia <- 1:nrow(sim_apple_df)

sim_apple_long <- sim_apple_df %>%
  pivot_longer(
    cols = -dia,
    names_to = "trayectoria",
    values_to = "precio"
  )

grafico_sim_apple <- ggplot(
  sim_apple_long,
  aes(x = dia, y = precio, group = trayectoria)
) +
  geom_line(alpha = 0.3, color = "blue") +
  labs(
    title = "Trayectorias simuladas de Apple mediante Monte Carlo",
    x = "Día bursátil",
    y = "Precio simulado (USD)"
  ) +
  theme_minimal()


# 5. Trayectorias simuladas de Nvidia

sim_nvidia_df <- as.data.frame(sim_nvidia[, 1:100])

sim_nvidia_df$dia <- 1:nrow(sim_nvidia_df)

sim_nvidia_long <- sim_nvidia_df %>%
  pivot_longer(
    cols = -dia,
    names_to = "trayectoria",
    values_to = "precio"
  )

grafico_sim_nvidia <- ggplot(
  sim_nvidia_long,
  aes(x = dia, y = precio, group = trayectoria)
) +
  geom_line(alpha = 0.3, color = "darkgreen") +
  labs(
    title = "Trayectorias simuladas de Nvidia mediante Monte Carlo",
    x = "Día bursátil",
    y = "Precio simulado (USD)"
  ) +
  theme_minimal()

# 6. Comparación visual de las simulaciones

grafico_simulaciones <- grafico_sim_apple + grafico_sim_nvidia +
  plot_layout(ncol = 2)

# 7. Distribución de precios finales simulados

final_apple <- sim_apple[30, ]
final_nvidia <- sim_nvidia[30, ]

# Histograma de Apple
grafico_final_apple <- ggplot(
  data.frame(precio = final_apple),
  aes(x = precio)
) +
  geom_histogram(
    bins = 40,
    fill = "steelblue",
    color = "white"
  ) +
  labs(
    title = "Distribución de precios finales de Apple",
    x = "Precio final simulado (USD)",
    y = "Frecuencia"
  ) +
  theme_minimal()

# Histograma de Nvidia
grafico_final_nvidia <- ggplot(
  data.frame(precio = final_nvidia),
  aes(x = precio)
) +
  geom_histogram(
    bins = 40,
    fill = "darkgreen",
    color = "white"
  ) +
  labs(
    title = "Distribución de precios finales de Nvidia",
    x = "Precio final simulado (USD)",
    y = "Frecuencia"
  ) +
  theme_minimal()

# 8. Comparación de distribuciones finales

grafico_distribuciones <- grafico_final_apple +
  grafico_final_nvidia +
  plot_layout(ncol = 2)

# 9. Estadísticas de los precios finales simulados

stats_finales_apple <- tibble(
  accion = "Apple",
  media = mean(final_apple),
  desviacion = sd(final_apple),
  mediana = median(final_apple),
  p5 = as.numeric(quantile(final_apple, 0.05)),
  p95 = as.numeric(quantile(final_apple, 0.95))
)

stats_finales_nvidia <- tibble(
  accion = "Nvidia",
  media = mean(final_nvidia),
  desviacion = sd(final_nvidia),
  mediana = median(final_nvidia),
  p5 = as.numeric(quantile(final_nvidia, 0.05)),
  p95 = as.numeric(quantile(final_nvidia, 0.95))
)

# Unir los resultados en una sola tabla

tabla_estadisticas <- bind_rows(
  stats_finales_apple,
  stats_finales_nvidia
)

# Preparación de datos para el gráfico comparativo

comparacion_larga <- comparacion_precios %>%
  select(accion, promedio_simulado, precio_real) %>%
  pivot_longer(
    cols = c(promedio_simulado, precio_real),
    names_to = "tipo",
    values_to = "precio"
  ) %>%
  mutate(
    tipo = recode(
      tipo,
      promedio_simulado = "Simulado",
      precio_real = "Real"
    )
  )

# 10. Comparación entre precios simulados y reales

grafico_comparacion <- ggplot(
  comparacion_larga,
  aes(x = tipo, y = precio, fill = tipo)
) +
  geom_col(width = 0.55) +
  geom_text(
    aes(label = paste0("$", sprintf("%.2f", precio))),
    vjust = -0.7,
    size = 4,
    fontface = "bold",
    color = "#243244"
  ) +
  facet_wrap(~accion, scales = "free_y") +
  scale_fill_manual(
    values = c(
      "Simulado" = "#4C78A8",
      "Real" = "#A8B5C4"
    )
  ) +
  scale_y_continuous(
    labels = scales::label_dollar(),
    expand = expansion(mult = c(0, 0.15))
  ) +
  labs(
    title = "Simulación frente a realidad",
    subtitle = "Comparación de precios al 14 de febrero de 2025",
    x = NULL,
    y = "Precio de cierre (USD)",
    caption = "Fuente: elaboración propia."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(
      face = "bold",
      size = 16,
      color = "#243244"
    ),
    plot.subtitle = element_text(
      size = 11,
      color = "#666666"
    ),
    strip.text = element_text(
      face = "bold",
      size = 13
    ),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(
      color = "#E8E8E8"
    ),
    axis.text.x = element_text(
      face = "bold",
      color = "#444444"
    ),
    legend.position = "none",
    plot.caption = element_text(
      color = "#777777",
      hjust = 0
    )
  )