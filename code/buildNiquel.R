# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/buildNiquel.R 
# FECHA 19/08/2018
# Ariel E. Meilij
#
# BRIEF Construye serie de datos del niquel

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
niquel_data <- Quandl("ODA/PNICK_USD")
# niquel_data <- Quandl("LME/PR_NI") FUENTE ALTERNA PERO INCOMPLETA

# Limpiar serie de tiempo niquel en su data.frame
# niquel_data <- niquel_data[, c(1,2)]
niquel <- subset(niquel_data, niquel_data$Date > "2009-12-31")
#niquel <- na.omit(niquel)
colnames(niquel) <- c("Date", "niquel")

fechas <- seq(as.Date("2010-01-01"), as.Date("2017-12-31"), "days")
quote <- c(1:2922)
# Cargar como valor inicial valor mas antiguo de la serie de tiempo
last_quote <- niquel[dim(niquel)[1],2]

for(i in 1:2922)
{if(length(niquel[which(niquel$Date == fechas[i]), ]$niquel))
{quote[i] <- niquel[which(niquel$Date == fechas[i]), ]$niquel
last_quote <- niquel[which(niquel$Date == fechas[i]), ]$niquel}
  else
  {quote[i] <- last_quote}
}

# Build into a time series
niquel_ts <- ts(quote, start=c(2010,1,1), end=c(2017,12,31), frequency=365)
plot(decompose(niquel_ts))
save(niquel_ts, file = "data/niquel_ts")

# Build into data frame
niquel_df <- data.frame(fechas, quote)
colnames(niquel_df) = c("Date", "niquel")
save(niquel_df, file = "data/niquel_df")
# EOC
