## plot2.R
#  Diciembre 15 de 2020 - NSS
## Respuesta a la segunda pregunta: 

# 2. Have total emissions from PM2.5 decreased in the Baltimore City,
#    Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system
#    to make a plot answering this question


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


# Extraer los datos de la ciudad de BaltimoreCity
BaltimoreCity <- subset(NEI, fips == "24510") 

# Calcular el total de emisión por año
totalPM25ofBCByYear <- tapply(BaltimoreCity$Emissions, BaltimoreCity$year, sum)

# Plot the result
plot(names(totalPM25ofBCByYear), totalPM25ofBCByYear, type = "l", xlab = "Year", 
     ylab = expression("Total" ~ PM[2.5] ~ "Emissions (tons)"), 
     main = expression("Total Baltimore City" ~ PM[2.5] ~ "Emissions by Year"))

# Copy Plot in png-file
dev.copy(device = png, filename = 'plot2.png', width = 500, height = 400)
dev.off ()

