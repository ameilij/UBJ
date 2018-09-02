# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/testStackedModelVariant 
# FECHA 31/08/2018
# Ariel E. Meilij
#
# BRIEF Modelo Ensamblado de Prediccion de la TRM
# VARIANTE Utiliza juego de test para crear tercer modelo

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

# Merge data frames
df1 <- merge(trm_df, palma_df)
df1 <- merge(df1, oro_df)
df1 <- merge(df1, wti_df)
df1 <- merge(df1, cafe_df)
df1 <- merge(df1, banana_df)
df1 <- merge(df1, niquel_df)
df1 <- merge(df1, gasoil_df)
df1 <- merge(df1, polipropileno_df)
df1 <- merge(df1, hulla_df)
df1 <- merge(df1, carbon_df)
summary(df1)

# Eliminar datos, no hacen falta para este ejercicio
rm(trm_df, palma_df, oro_df, wti_df, cafe_df, banana_df, niquel_df, gasoil_df, polipropileno_df, hulla_df, carbon_df)

# Crear juegos de datos para entrenamiento y prueba
# Cargar juegos de datos
load("data/trm_ts")
set.seed(7556014)

# Modelo 1: ARIMA
modelFitARIMA <- auto.arima(trm_ts)

# Model 2: Regresion Multivariable
inTrain <- createDataPartition(y = df1$trm, p = 0.7, list = FALSE)
training <- df1[inTrain, ]
testing <- df1[-inTrain, ]
modelFitGLM <- train(trm ~ palma + oro + wti + cafe + banana + niquel +
                       gasoil + polipropileno + hulla + carbon, 
                     data = training, method = "glm")

# Crear data frame de modelos ensamblados
# variable independiente Y : TRM
# variables dependientes Xi : predicciones
# UTILIZAR DATOS TEST!
predGLM <- predict(modelFitGLM, testing)

# Para la serie de tiempo extraer solo las predicciones que 
# coinciden con el juego de datos de test *lo opuesto de inTrain
# guardamos en foo las predicciones como df y leidas como 
# numerico para que funcione (extraer TS es aun dificil en R)
foo = as.data.frame(as.numeric(modelFitARIMA$fitted))
predARIMA = foo[-inTrain, ]
rm(foo)

# Crear data frame datos modelo ensamblado 
df_ensamblado <- data.frame(testing$trm, predARIMA, predGLM)
colnames(df_ensamblado) = c("trm", "predARIMA", "predGLM")

# Revisar y graficar modelo para verificar integridad de los datos
summary(df_ensamblado)
plot(df_ensamblado, main = "Validacion Datos Modelo Ensamblado")

# Entrenar modelo ensamblado con GAM
modeloEnsamblado <- train(trm ~ ., method = "gam", data = df_ensamblado)
modeloEnsamblado
summary(modeloEnsamblado)

# Test individual de valores aleatorios comparativos
size_b <- dim(testing)[1]
indices_aleatorios <-  sample.int(size_b, 10)
y_values <- df_ensamblado[indices_aleatorios, 1]
y1_hat <- predARIMA[indices_aleatorios]
y2_hat <- predGLM[indices_aleatorios]
y3_hat <- modeloEnsamblado$finalModel$fitted.values[indices_aleatorios]
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
  geom_point(alpha = 0.1)  + geom_smooth(method='lm',formula=y~x, colour = "orange", 
                                          show.legend = TRUE) +
  labs(x = "Valores Prediccion Modelo Ensamblado", y = "Valores Reales TRM", 
       title = "Valores Reales vs. Valores Prediccion | Validacion Modelo Ensamblado")

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
tabla_comparativa

# End of Code