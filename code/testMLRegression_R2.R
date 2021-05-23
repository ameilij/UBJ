# UBJ Doctorado en Administracion Gerencial
# Modelo Predictivo de la TRM Utilizando Machine Learning
# LIB ubj/code/testMLRegression
# FECHA 19/08/2018
# Ariel E. Meilij
#
# BRIEF Evalua Modelo de Regresion Multivariable con Machine Learning
# Utiliza biblioteca CARET para aprendizaje automatizado

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
df_data <- df1[, 2:12]
rm(df1, trm_df, palma_df, oro_df, wti_df, cafe_df, banana_df, niquel_df, gasoil_df, polipropileno_df, hulla_df, carbon_df)

# Crear juegos de datos para entrenamiento y prueba
set.seed(7556014)
inTrain <- createDataPartition(y = df_data$trm, p = 0.7, list = FALSE)
training <- df_data[inTrain, ]
testing <- df_data[-inTrain, ]

# Comenzar entrenamiento
modelFit2 <- train(trm ~ hulla + gasoil + wti + carbon + niquel + palma, data = training, method = "glm")

# Graficas de verificacion de modelo
plot(modelFit2$finalModel)
plot(modelFit2$finalModel, 4, pch = 19, cex = 0.5, col = "#00000010")
plot(modelFit2$finalModel$residuals, pch = 19)
abline(0,0, col = "red")

# Plot Data Entrenada en Prediccion vs. Valores Reales
valores_reales <- df_data[inTrain, 1]
valores_prediccion <- predict(modelFit2, training[,2:11])
testVector <- data.frame(valores_prediccion, valores_reales)
ggplot(aes(x = valores_prediccion, y = valores_reales), data = testVector) + 
  geom_point(alpha = 0.05)  + geom_smooth(method='lm',formula=y~x, colour = "green") + 
  labs(x = "Valores Prediccion", y = "Valores Reales", 
       title = "Valores Reales vs. Valores Prediccion Modelo Entrenado Regresion Multivariable")

# Plot Data de Prueba vs. Valores Reales
valores_reales <- df_data[-inTrain, 1]
valores_prediccion <- predict(modelFit2, testing[,2:11])
testVector <- data.frame(valores_prediccion, valores_reales)
ggplot(aes(x = valores_prediccion, y = valores_reales), data = testVector) + 
  geom_point(alpha = 0.05)  + geom_smooth(method='lm',formula=y~x, colour = "yellow") +
  labs(x = "Valores Prediccion", y = "Valores Reales", 
       title = "Valores Reales vs. Valores Prediccion Data Validacion Regresion Multivariable")

# Test individual de valores aleatorios comparativos
indices_aleatorios <-  sample.int(dim(inTrain)[1], 20)
y_values <- df_data[indices_aleatorios, 1]
y_hat <- predict(modelFit2, df_data[indices_aleatorios, 2:11])
testMatrix <- data.frame(y_values, y_hat, round(((y_hat/y_values)-1)*100,1))
colnames(testMatrix) = c("VALOR REAL", "PREDICCION", "ERROR %")
print(testMatrix)
print(mean(testMatrix$`ERROR %`))

# Grafica Residuales
residuales <- modelFit2$finalModel$residuals
indice <- seq(1:2047)
data_residuales <- data.frame(residuales, indice)
ggplot(aes(y = residuales, x = indice), data = data_residuales) + geom_jitter(alpha = 1/05) +
  labs(y = "Error Aleatorio", x = "", title = "Valores Residuales")


