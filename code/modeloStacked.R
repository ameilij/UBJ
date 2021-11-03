# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/testStackedModel 
# FECHA 03/11/2021
# Ariel E. Meilij
#
# BRIEF Modelo Ensamblado de Prediccion de la TRM

# Carga de librerias necesarias
library(tseries)
library(ggplot2)
library(ggfortify)
library(Hmisc)
library(corrplot)
library(PerformanceAnalytics)
library(reshape2)
library(ggpubr)
library(caret)
library(forecast)

# Cargar juegos de datos
load("data/trm_ts")
load("data/df_data")
set.seed(7556014)

# Modelo 1: ARIMA
modelFitARIMA <- auto.arima(trm_ts)

# Model 2: Regresion Multivariable
inTrain <- createDataPartition(y = df_data$trm, p = 0.7, list = FALSE)
training <- df_data[inTrain, ]
testing <- df_data[-inTrain, ]
modelFitGLM <- train(trm ~ ., data = training, method = "glm")

# Crear data frame de modelos ensamblados
# variable independiente Y : TRM
# variables dependientes Xi : predicciones
predARIMA <- modelFitARIMA$fitted
predGLM <- predict(modelFitGLM, df_data)
df_ensamblado <- data.frame(df_data$trm, predARIMA, predGLM)
colnames(df_ensamblado) = c("trm", "predARIMA", "predGLM")

# Revisar y graficar modelo para verificar integridad de los datos
summary(df_ensamblado)
plot(df_ensamblado, main = "Validación Datos Modelo Ensamblado")

# Entrenar modelo ensamblado con GLM
inTrainME <- createDataPartition(y = df_ensamblado$trm, p = 0.7, list = FALSE)
trainingME <- df_ensamblado[inTrain, ]
testingME <- df_ensamblado[-inTrain, ]

modelFitME <- train(trm ~ ., data = trainingME, method = "glm")

# Imprimir resumen de modelo ensamblado
modelFitME
summary(modelFitME)

# Plot Data de Prueba vs. Valores Reales
valores_reales <- testingME[,1]
valores_prediccion <- predict(modelFitME, testingME)
testVector <- data.frame(valores_prediccion, valores_reales)
ggplot(aes(x = valores_prediccion, y = valores_reales), data = testVector) + 
  geom_point(alpha = 0.05)  + geom_smooth(method='lm',formula=y~x, colour = "yellow") +
  labs(x = "Valores Prediccion", y = "Valores Reales", 
       title = "Valores Reales vs. Valores Prediccion Data Validacion Modelo Ensamblado") +
  theme(plot.title = element_text(hjust = 0.5))

cor(valores_reales, valores_prediccion, method = "spearman")


# Pruebas Adicionales
# ===================

# Plot de Residuos
# data.frame(df_data$trm, predARIMA, predGLM)
bar = data.frame("x" = c(1:2047), "y" = modelFitME$finalModel$residuals)
ggplot(aes(x = x, y = y ), data = bar) + geom_point(alpha = 0.5) +
  labs(x = "Residuos", y = "Valores Residuales", 
       title = "Distribución de Residuos Modelo Ensamblado") +
  theme(plot.title = element_text(hjust = 0.5))


# End of Code