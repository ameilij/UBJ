# UBJ - Doctoral Thesis
# Marco Teorico - Series de Tiempo
# Ejemplo de plot ACF de una serie de tiempo

library(Quandl)
Quandl.api_key("KzzS8Vfxkw1ZgTWgU4jH")
COP_raw <- Quandl("CURRFX/USDCOP", collapse = "monthly", type = "ts")
COP <- COP_raw[,1]
Acf(COP)

