# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/testAutoARIMA 
# FECHA 19/08/2021
# Ariel E. Meilij
#
# BRIEF Prueba de autocorrelacion ACF y PACF de la TRM

library(forecast)
library(ggplot2)

load("data/trm_ts")

# Descomposicion de serie de tiempo TRM
plot(decompose(trm_ts))

# Evaluar autocorrelacion
par(mfrow=c(1,2))
acf(trm_ts)
pacf(trm_ts)
