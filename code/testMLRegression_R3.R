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
library(MASS)
library(car)

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
regresionMV <- glm(trm ~ ., data = training)
modelFit3 <- stepAIC(regresionMV, direction = "both")
modelFit3 
summary(modelFit3)

# Conclusion: modelo igual a modelo R1

