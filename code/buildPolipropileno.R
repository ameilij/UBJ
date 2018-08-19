# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/buildPolipropileno.R 
# FECHA 19/08/2018
# Ariel E. Meilij
#
# BRIEF Construye serie de datos prolipropileno

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
polipropileno_data <- Quandl("FRED/WPU091303223")

# Limpiar serie de tiempo polipropileno en su data.frame
polipropileno <- polipropileno_data[, c(1,6)]
polipropileno <- subset(polipropileno, polipropileno$Date > "2009-12-31")
colnames(polipropileno) <- c("Date", "polipropileno")

fechas <- seq(as.Date("2010-01-01"), as.Date("2017-12-31"), "days")
quote <- c(1:2922)
# Cargar como valor inicial valor mas antiguo de la serie de tiempo
last_quote <- polipropileno[dim(polipropileno)[1],2]

for(i in 1:2922)
{if(length(polipropileno[which(polipropileno$Date == fechas[i]), ]$polipropileno))
{quote[i] <- polipropileno[which(polipropileno$Date == fechas[i]), ]$polipropileno
last_quote <- polipropileno[which(polipropileno$Date == fechas[i]), ]$polipropileno}
  else
  {quote[i] <- last_quote}
}

# Build into a time series
polipropileno_ts <- ts(quote, start=c(2010,1,1), end=c(2017,12,31), frequency=365)
plot(decompose(polipropileno_ts))
save(polipropileno_ts, file = "data/polipropileno_ts")

# Build into data frame
polipropileno_df <- data.frame(fechas, quote)
colnames(polipropileno_df) = c("Date", "polipropileno")
save(polipropileno_df, file = "data/polipropileno_df")
# EOC