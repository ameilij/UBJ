# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/buildHulla.R 
# FECHA 19/08/2018
# Ariel E. Meilij
#
# BRIEF Construye serie de datos hulla termica

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
hulla_data <- Quandl("CHRIS/SGX_CFF3")

# Limpiar serie de tiempo HULLA en su data.frame
hulla <- hulla_data[, c(1,6)]
hulla <- subset(hulla, hulla$Date > "2009-12-31")
colnames(hulla) <- c("Date", "hulla")

fechas <- seq(as.Date("2010-01-01"), as.Date("2017-12-31"), "days")
quote <- c(1:2922)
# Cargar como valor inicial valor mas antiguo de la serie de tiempo
last_quote <- hulla[dim(hulla)[1],2]

for(i in 1:2922)
{if(length(hulla[which(hulla$Date == fechas[i]), ]$hulla))
{quote[i] <- hulla[which(hulla$Date == fechas[i]), ]$hulla
last_quote <- hulla[which(hulla$Date == fechas[i]), ]$hulla}
  else
  {quote[i] <- last_quote}
}

# Build into a time series
hulla_ts <- ts(quote, start=c(2010,1,1), end=c(2017,12,31), frequency=365)
plot(decompose(hulla_ts))
save(hulla_ts, file = "data/hulla_ts")

# Build into data frame
hulla_df <- data.frame(fechas, quote)
colnames(hulla_df) = c("Date", "hulla")
save(hulla_df, file = "data/hulla_df")
# EOC