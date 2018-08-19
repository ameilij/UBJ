# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/buildCarbon.R 
# FECHA 19/08/2018
# Ariel E. Meilij
#
# BRIEF Construye serie de datos carbon

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
carbon_data <- Quandl("EIA/COAL")

# Limpiar serie de tiempo GOLD en su data.frame
carbon <- carbon_data[, 1:2]
carbon <- subset(carbon, carbon$`Week Ended` > "2009-12-31")
colnames(carbon) <- c("Date", "carbon")

fechas <- seq(as.Date("2010-01-01"), as.Date("2017-12-31"), "days")
quote <- c(1:2922)
# Cargar como valor inicial valor mas antiguo de la serie de tiempo
last_quote <- carbon[dim(carbon)[1],2]

for(i in 1:2922)
{if(length(carbon[which(carbon$Date == fechas[i]), ]$carbon))
{quote[i] <- carbon[which(carbon$Date == fechas[i]), ]$carbon
last_quote <- carbon[which(carbon$Date == fechas[i]), ]$carbon}
  else
  {quote[i] <- last_quote}
}

# Build into a time series
carbon_ts <- ts(quote, start=c(2010,1,1), end=c(2017,12,31), frequency=365)
plot(decompose(carbon_ts))
save(carbon_ts, file = "data/carbon_ts")

# Build into data frame
carbon_df <- data.frame(fechas, quote)
colnames(carbon_df) = c("Date", "carbon")
save(carbon_df, file = "data/carbon_df")
# EOC