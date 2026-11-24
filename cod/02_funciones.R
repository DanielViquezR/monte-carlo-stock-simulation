# Proyecto individual - Simulación Monte Carlo
# 02_funciones.R
# Funciones para limpíeza, calculo de rendimientos y simulacion.

library(tidyverse)
# 1.Limpieza de apple


limpiar_apple <- function(datos){
  colnames(datos) <- c("date","open","high","low","close","volume")
  
  datos <-datos %>% 
    slice(-1) %>% 
    mutate(
      date =as.Date(date),
      across(c(open,high,low,close, volume),as.numeric
      )
      )
      return(datos)
}


# 2. Limpieza Nvidia.


limpiar_nvidia <-  function(datos){
  datos <-  datos %>% 
    rename(date= Date,
           close= `Close/Last`
           ) %>% 
    mutate(
      date = as.Date(date, format = "%m/%d/%Y"),
      close = as.numeric(gsub("\\$", "", close))
    )
  return(datos)
}

# 3. Cálculo de rendimientos.


calcular_rendimientos <- function(datos){
  datos <- datos %>% 
    arrange(date) %>% 
    mutate(
      daily.return = 100 * log(close / lag(close))
    )
  
return(datos)
}


# 4. Simulación MonteCarlo

montecarlo <-  function(P0,mu,sigma,n.dias,n.tray){
  simulaciones <-  matrix(0,nrow = n.dias,ncol = n.tray)
  for(i in 1: n.tray){
    
    rendimientos <- rnorm(n.dias,mean = mu,sd = sigma)
    precios <- P0 *exp(cumsum(rendimientos)/100)
    
    simulaciones[,i] <-  precios
  }
  return(simulaciones)
}
