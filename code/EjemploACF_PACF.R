# UBJ - Doctoral Thesis
# Marco Teorico - Series de Tiempo
# Ejemplo de plot ACF y PACF

library(Quandl)
library(forecast)
Quandl.api_key("KzzS8Vfxkw1ZgTWgU4jH")
COP_raw <- Quandl("CURRFX/USDCOP", collapse = "monthly", type = "ts")
COP <- COP_raw[,1]
COP_diff <- diff(COP)

par(mfrow=c(1,2))
Acf(COP_diff, main = "ACF Diff Peso Colombiano")
Pacf(COP_diff, main = "PACF Diff Peso Colombiano")
