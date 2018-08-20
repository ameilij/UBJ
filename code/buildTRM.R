# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/buildTRM.R 
# FECHA 19/08/2018
# Ariel E. Meilij
#
# BRIEF Construye serie de datos TRM

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
trm_data <- Quandl("CURRFX/USDCOP")

# Limpiar serie de tiempo TRM en su data.frame
trm <- trm_data[, 1:2]
trm <- subset(trm, trm$Date > "2009-12-31")
trm <- subset(trm, trm$Rate > 1500)
colnames(trm) <- c("Date", "trm")

fechas <- seq(as.Date("2010-01-01"), as.Date("2017-12-31"), "days")
quote <- c(1:2922)
# Cargar como valor inicial valor mas antiguo de la serie de tiempo
last_quote <- trm[dim(trm)[1],2]

for(i in 1:2922)
{if(length(trm[which(trm$Date == fechas[i]), ]$trm))
{quote[i] <- trm[which(trm$Date == fechas[i]), ]$trm
last_quote <- trm[which(trm$Date == fechas[i]), ]$trm}
  else
  {quote[i] <- last_quote}
}

# Build into a time series
trm_ts <- ts(quote, start=c(2010,1,1), frequency=365)
plot(decompose(trm_ts))
save(trm_ts, file = "data/trm_ts")

# Build into data frame
trm_df <- data.frame(fechas, quote)
colnames(trm_df) = c("Date", "trm")
save(trm_df, file = "data/trm_df")
# EOC
