## plot3.R
#  Diciembre 15 de 2020 - NSS
## Respuesta a la  tercera pregunta: 

# 3. Of the four types of sources indicated by the type (point, nonpoint, onroad,
#    nonroad) variable, which of these four sources have seen decreases in
#    emissions from 1999–2008 for Baltimore City?
#    Which have seen increases in emissions from 1999–2008?
#    Use the ggplot2 plotting system to make a plot answer this question.

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


# Extraer los datos de BaltimoreCity
BaltimoreCity <- subset(NEI, fips == "24510")

# Calcular el total de emisiones por tipo para cada año, para BaltimoreCity
typePMPM25ofBMar <- BaltimoreCity %>% select (year, type, Emissions) %>% 
  group_by(year, type) %>% 
  summarise_each(funs(sum))

# Graficar el resultado
qplot(year, Emissions, data = typePMPM25ofBMar, color = type, geom = "line") +
  ggtitle(expression("Baltimore City" ~ PM[2.5] ~ "Emissions by Source Type and Year")) +
  xlab("Year") +
  ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))

# Copiar la gráfica en un archivo png
dev.copy(device = png, filename = 'plot3.png', width = 500, height = 400)
dev.off ()
