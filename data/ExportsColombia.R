# ExportsColombia.R
# Ariel E. Meilij
# 24/12/2017
# Lectura principales rubros de exportacion Colombia 2010-2016

exports = read.csv("exportsColTidy.csv")
summary(exports)
opt <- options("scipen" = 20)

boxplot((VOLUME/1000000) ~ X...EXPORT, exports, yaxt="n", ylim = c(0,30), las = 2)
pts <- pretty(exports$VOLUME / 1000000)
axis(2, at = pts, labels = paste(pts, "BN", sep = ""), las = 1)
