# UBJ - Doctoral Thesis
# Marco Teorico - Series de Tiempo
# Ejemplo de plot ACF de series de tiempo y series diferenciadas

library(Quandl)
library(forecast)
Quandl.api_key("KzzS8Vfxkw1ZgTWgU4jH")
COP_raw <- Quandl("CURRFX/USDCOP", collapse = "monthly", type = "ts")
COP <- COP_raw[,1]
COP_diff <- diff(COP)

par(mfrow=c(1,2))
Acf(COP, main = "ACF Peso Colombiano")
Acf(COP_diff, main = "ACF Peso Colombiano Diferenciado")
