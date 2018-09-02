# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/buildWti.R 
# FECHA 19/08/2018
# Ariel E. Meilij
#
# BRIEF Construye serie de datos petroleo WTI

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
wti_data <- Quandl("EIA/PET_RWTC_D")

# Limpiar serie de tiempo wti en su data.frame
wti <- subset(wti_data, wti_data$Date > "2009-12-31")
colnames(wti) <- c("Date", "wti")

fechas <- seq(as.Date("2010-01-01"), as.Date("2017-12-31"), "days")
quote <- c(1:2922)
# Cargar como valor inicial valor mas antiguo de la serie de tiempo
last_quote <- wti[dim(wti)[1],2]

for(i in 1:2922)
{if(length(wti[which(wti$Date == fechas[i]), ]$wti))
{quote[i] <- wti[which(wti$Date == fechas[i]), ]$wti
last_quote <- wti[which(wti$Date == fechas[i]), ]$wti}
  else
  {quote[i] <- last_quote}
}

# Build into a time series
wti_ts <- ts(quote, start=c(2010,1,1), end=c(2017,12,31), frequency=365)
plot(decompose(wti_ts))
save(wti_ts, file = "data/wti_ts")

# Build into data frame
wti_df <- data.frame(fechas, quote)
colnames(wti_df) = c("Date", "wti")
save(wti_df, file = "data/wti_df")
# EOC
