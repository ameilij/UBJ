# buildPalma.R
# 2018-08-15
# Ariel E. Meilij
# UBJ - DBA

# Build palm oil time series and expand
# 2010-01-01 thru 2017-12-31
# Fill-in NA's or 0 values
# Last known quote takes precedence

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
palma_data <- Quandl("ODA/PPOIL_USD")

palma <- subset(palma_data, palma_data$Date > "2009-12-01")
colnames(palma) <- c("Date", "palma")

fechas <- seq(as.Date("2010-01-01"), as.Date("2017-12-31"), "days")
quote <- c(1:2922)
last_quote <- palma[dim(palma)[1],2]

for(i in 1:2922)
{if(length(palma[which(palma$Date == fechas[i]), ]$palma))
  {quote[i] <- palma[which(palma$Date == fechas[i]), ]$palma
  last_quote <- palma[which(palma$Date == fechas[i]), ]$palma}
      else
  {quote[i] <- last_quote}
}

qplot(x = fechas, y = quote, geom = "line", main = "Cotizacion Aceite de Palma (2010-2017)")

# Build into a time series
palma_ts <- ts(quote, start=c(2010,1,1), end=c(2017,12,31), frequency=365)
plot(decompose(palma_ts))
save(palma_ts, file = "data/palma_ts")

# Build into data frame
palma_df <- data.frame(fechas, quote)
colnames(palma_df) = c("Date", "palma")
save(palma_df, file = "data/palma_df")

# EOC
