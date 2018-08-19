# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/visualRegresoresTS 
# FECHA 19/08/2018
# Ariel E. Meilij
#
# BRIEF EDA regresores TRM en forma de serie de tiempo

# Carga de librerias necesarias
library(tseries)
library(ggplot2)
library(ggfortify)
library(Hmisc)
library(corrplot)
library(PerformanceAnalytics)
library(reshape2)
library(ggpubr)

# Cargar data frames en memoria
load("data/trm_df")
load("data/palma_df")
load("data/oro_df")
load("data/wti_df")
load("data/cafe_df")
load("data/banana_df")
load("data/niquel_df")
load("data/gasoil_df")
load("data/polipropileno_df")
load("data/hulla_df")
load("data/carbon_df")

# Multiple Graph
graf1 <- ggplot(trm_df, aes(x = Date, y = trm)) + geom_line(color = "#00AFBB", size = 1) + 
  xlab("Fechas") + ylab("Cotizacion TRM")
graf2 <- ggplot(palma_df, aes(x = Date, y = palma)) + geom_line(color = "#00AFBB", size = 1) + 
  xlab("Fechas") + ylab("Cotizacion Aceite de Palma")
graf3 <- ggplot(oro_df, aes(x = Date, y = oro)) + geom_line(color = "#00AFBB", size = 1) + 
  xlab("Fechas") + ylab("Cotizacion Oro")
graf4 <- ggplot(wti_df, aes(x = Date, y = wti)) + geom_line(color = "#00AFBB", size = 1) + 
  xlab("Fechas") + ylab("Cotizacion Petroleo WTI")
graf5 <- ggplot(cafe_df, aes(x = Date, y = cafe)) + geom_line(color = "#00AFBB", size = 1) + 
  xlab("Fechas") + ylab("Cotizacion Cafe")
graf6 <- ggplot(banana_df, aes(x = Date, y = banana)) + geom_line(color = "#00AFBB", size = 1) + 
  xlab("Fechas") + ylab("Cotizacion Banano")
graf7 <- ggplot(niquel_df, aes(x = Date, y = niquel)) + geom_line(color = "#00AFBB", size = 1) + 
  xlab("Fechas") + ylab("Cotizacion Ferroniquel")
graf8 <- ggplot(gasoil_df, aes(x = Date, y = gasoil)) + geom_line(color = "#00AFBB", size = 1) + 
  xlab("Fechas") + ylab("Cotizacion Gasoil")
graf9 <- ggplot(polipropileno_df, aes(x = Date, y = polipropileno)) + geom_line(color = "#00AFBB", size = 1) + 
  xlab("Fechas") + ylab("Cotizacion Polipropileno")
graf10 <- ggplot(hulla_df, aes(x = Date, y = hulla)) + geom_line(color = "#00AFBB", size = 1) + 
  xlab("Fechas") + ylab("Cotizacion Hulla Termica")
graf11 <- ggplot(carbon_df, aes(x = Date, y = carbon)) + geom_line(color = "#00AFBB", size = 1) + 
  xlab("Fechas") + ylab("Cotizacion Carbon")

ggarrange(graf1, graf2, graf3, graf4, graf5, graf6, graf7, graf8, graf9, graf10, graf11 + rremove("x.text"), 
          labels = c("TRM", "PALMA", "ORO", "WTI", "CAFE", "BANANA", "FERRONIQUEL", "GASOIL", "POLIPROPILENO", "HULLA TERMICA", "CARBON" ),
          ncol = 3, nrow = 4)

