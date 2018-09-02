# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/buildBanana.R 
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
banana_data <- Quandl("ODA/PBANSOP_USD")

# Limpiar serie de tiempo banana en su data.frame
banana <- subset(banana_data, banana_data$Date > "2009-12-31")
colnames(banana) <- c("Date", "banana")

fechas <- seq(as.Date("2010-01-01"), as.Date("2017-12-31"), "days")
quote <- c(1:2922)
# Cargar como valor inicial valor mas antiguo de la serie de tiempo
last_quote <- banana[dim(banana)[1],2]

for(i in 1:2922)
{if(length(banana[which(banana$Date == fechas[i]), ]$banana))
{quote[i] <- banana[which(banana$Date == fechas[i]), ]$banana
last_quote <- banana[which(banana$Date == fechas[i]), ]$banana}
  else
  {quote[i] <- last_quote}
}

# Build into a time series
banana_ts <- ts(quote, start=c(2010,1,1), end=c(2017,12,31), frequency=365)
plot(decompose(banana_ts))
save(banana_ts, file = "data/banana_ts")

# Build into data frame
banana_df <- data.frame(fechas, quote)
colnames(banana_df) = c("Date", "banana")
save(banana_df, file = "data/banana_df")
# EOC
