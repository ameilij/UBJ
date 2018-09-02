# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/buildCafe.R 
# FECHA 19/08/2018
# Ariel E. Meilij
#
# BRIEF Construye serie de datos cafe

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
cafe_data <- Quandl("CHRIS/ICE_KC1")

# Limpiar serie de tiempo cafe en su data.frame
cafe <- cafe_data[,c(1,5)]
cafe <- subset(cafe, cafe$Date > "2009-12-31")
cafe <- na.omit(cafe)
colnames(cafe) <- c("Date", "cafe")

fechas <- seq(as.Date("2010-01-01"), as.Date("2017-12-31"), "days")
quote <- c(1:2922)
# Cargar como valor inicial valor mas antiguo de la serie de tiempo
last_quote <- cafe[dim(cafe)[1],2]

for(i in 1:2922)
{if(length(cafe[which(cafe$Date == fechas[i]), ]$cafe))
{quote[i] <- cafe[which(cafe$Date == fechas[i]), ]$cafe
last_quote <- cafe[which(cafe$Date == fechas[i]), ]$cafe}
  else
  {quote[i] <- last_quote}
}

# Build into a time series
cafe_ts <- ts(quote, start=c(2010,1,1), end=c(2017,12,31), frequency=365)
plot(decompose(cafe_ts))
save(cafe_ts, file = "data/cafe_ts")

# Build into data frame
cafe_df <- data.frame(fechas, quote)
colnames(cafe_df) = c("Date", "cafe")
save(cafe_df, file = "data/cafe_df")
# EOC
