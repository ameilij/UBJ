# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/buildOro.R 
# FECHA 19/08/2018
# Ariel E. Meilij
#
# BRIEF Construye serie de datos oro

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
gold_data <- Quandl("WGC/GOLD_DAILY_USD")

# Limpiar serie de tiempo GOLD en su data.frame
oro <- subset(gold_data, gold_data$Date > "2009-12-31")
colnames(oro) <- c("Date", "oro")

fechas <- seq(as.Date("2010-01-01"), as.Date("2017-12-31"), "days")
quote <- c(1:2922)
# Cargar como valor inicial valor mas antiguo de la serie de tiempo
last_quote <- oro[dim(oro)[1],2]

for(i in 1:2922)
{if(length(oro[which(oro$Date == fechas[i]), ]$oro))
{quote[i] <- oro[which(oro$Date == fechas[i]), ]$oro
last_quote <- oro[which(oro$Date == fechas[i]), ]$oro}
  else
  {quote[i] <- last_quote}
}

# Build into a time series
oro_ts <- ts(quote, start=c(2010,1,1), end=c(2017,12,31), frequency=365)
plot(decompose(oro_ts))
save(oro_ts, file = "data/oro_ts")

# Build into data frame
oro_df <- data.frame(fechas, quote)
colnames(oro_df) = c("Date", "oro")
save(oro_df, file = "data/oro_df")
# EOC