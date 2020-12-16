## plot1.R
#  Diciembre 15 de 2020 - NSS
## Respuesta a la primera pregunta: 
## 1. Have total emissions from PM2.5 decreased in the United States from 1999
## to 2008? Using the __base__ plotting system, make a plot showing the total 
## PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and
## 2008.

# Cargar librerias
library(dplyr)
library(ggplot2)

################################################################################
# All the data has been downloaded and unzipped in the project's data folder.
# Therefore, it is assumed that they are already located in the mentioned folder.
################################################################################

# Identificar la ruta de los archivos a analizar
archivoSCC <- "data/Source_Classification_Code.rds"
archivoSummarySCC_PM25 <- "data/summarySCC_PM25.rds"
# Leer los archivos
NEI <- readRDS(archivoSummarySCC_PM25)
SCC <- readRDS(archivoSCC)

# Calcular el total de emisión por año
totalPM25ByYear <- tapply(NEI$Emissions, NEI$year, sum)

# Graficar el resultado
plot(names(totalPM25ByYear), totalPM25ByYear, type = "l",
     xlab = "Year", ylab = expression("Total" ~ PM[2.5] ~ "Emissions (tons)"),
     main = expression("Total US" ~ PM[2.5] ~ "Emissions by Year"))

# Copiar la gráfica en un archivo png
dev.copy(device = png, filename = 'plot1.png', width = 500, height = 400)
dev.off ()
