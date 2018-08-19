# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/buildgasoil.R 
# FECHA 19/08/2018
# Ariel E. Meilij
#
# BRIEF Construye serie de datos del banano

library(Quandl)
library(tseries)
library(ggplot2)
library(ggfortify)
library(Hmisc)
library(corrplot)
library(PerformanceAnalytics)
library(reshape2)
library(ggpubr)

Quandl.api_key("KzzS8Vfxkw1ZgTWgU4jH")
gasoil_data <- Quandl("NASDAQOMX/NQCIGOER")

# Limpiar serie de tiempo gasoil en su data.frame
gasoil <- gasoil_data[, c(1:2)]
gasoil <- subset(gasoil, gasoil$`Trade Date` > "2009-12-31")
gasoil <- subset(gasoil, gasoil$`Index Value` > 0)
colnames(gasoil) <- c("Date", "gasoil")

fechas <- seq(as.Date("2010-01-01"), as.Date("2017-12-31"), "days")
quote <- c(1:2922)
# Cargar como valor inicial valor mas antiguo de la serie de tiempo
last_quote <- gasoil[dim(gasoil)[1],2]

for(i in 1:2922)
{if(length(gasoil[which(gasoil$Date == fechas[i]), ]$gasoil))
{quote[i] <- gasoil[which(gasoil$Date == fechas[i]), ]$gasoil
last_quote <- gasoil[which(gasoil$Date == fechas[i]), ]$gasoil}
  else
  {quote[i] <- last_quote}
}

# Build into a time series
gasoil_ts <- ts(quote, start=c(2010,1,1), end=c(2017,12,31), frequency=365)
plot(decompose(gasoil_ts))
save(gasoil_ts, file = "data/gasoil_ts")

# Build into data frame
gasoil_df <- data.frame(fechas, quote)
colnames(gasoil_df) = c("Date", "gasoil")
save(gasoil_df, file = "data/gasoil_df")
# EOC
