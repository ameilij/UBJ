# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/testStackedModel 
# FECHA 19/08/2018
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
plot(df_ensamblado, main = "Validacion Datos Modelo Ensamblado")

# Entrenar modelo ensamblado con GAM
modeloEnsamblado <- train(trm ~ ., method = "gam", data = df_ensamblado)
modeloEnsamblado
summary(modeloEnsamblado)

# Test individual de valores aleatorios comparativos
indices_aleatorios <-  sample.int(dim(inTrain)[1], 100)
y_values <- df_data[indices_aleatorios, 1]
y1_hat <- modelFitARIMA$fitted[indices_aleatorios]
y2_hat <- predict(modelFitGLM, df_data[indices_aleatorios, 2:11])
y3_hat <- predict(modeloEnsamblado, df_ensamblado[indices_aleatorios, 2:3])
testMatrix <- data.frame(y_values, y1_hat, y2_hat, y3_hat, round(((y1_hat/y_values)-1)*100,1), round(((y2_hat/y_values)-1)*100,1), round(((y3_hat/y_values)-1)*100,1))
colnames(testMatrix) = c("VALOR REAL", "Y1_HAT", "Y2_HAT", "Y3_HAT", "ERROR % Y1", "ERROR % Y2", "ERROR % Y3")
print(testMatrix)
print(mean(testMatrix$`ERROR % Y1`))
print(mean(testMatrix$`ERROR % Y2`))
print(mean(testMatrix$`ERROR % Y3`))

# Grafica del Modelo Ensamblado: Valores Reales vs. Valores Esperados
this_y <- df_ensamblado$trm
this_x <- modeloEnsamblado$finalModel$fitted.values
this_frame <- data.frame(this_y, this_x)
ggplot(aes(x = this_x, y = this_y), data = this_frame) + 
  geom_point(alpha = 0.05)  + geom_smooth(method='lm',formula=y~x, colour = "yellow", 
                                          show.legend = TRUE) +
  labs(x = "Valores Prediccion Modelo Ensamblado", y = "Valores Reales TRM", 
       title = "Valores Reales vs. Valores Prediccion Validacion Modelo Ensamblado")

# Tabla comparativa de valores
rmse_ARIMA <- summary(modelFitARIMA)[2]
rmse_GLM <- modelFitGLM$results$RMSE
rmse_STACKED <- as.double(modeloEnsamblado$results$RMSE[1])
R2_ARIMA <- as.double(summary(lm(as.double(trm_ts) ~ modelFitARIMA$fitted))[8])
R2_GLM <- modelFitGLM$results$Rsquared
R2_STACKED <- modeloEnsamblado$results$Rsquared[1]

tabla_comparativa <- data.frame(c(rmse_ARIMA,R2_ARIMA),
                                c(rmse_GLM,R2_GLM),
                                c(rmse_STACKED,R2_STACKED))
  
colnames(tabla_comparativa) <- c("ARIMA", "GLM", "ENSAMBLADO")
rownames(tabla_comparativa)[1] <- c("RMSE")
rownames(tabla_comparativa)[2] <- c("R2")

# End of Code