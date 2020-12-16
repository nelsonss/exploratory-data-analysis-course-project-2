## plot5.R
#  Diciembre 15 de 2020 - NSS
## Respuesta a la  tercera pregunta: 

#  5. How have emissions from motor vehicle sources changed from 1999–2008
#    in Baltimore City?

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

#  Extraer los datos de BaltimoreCity de tipo ON-ROAD
BaltimoreCityMV <- subset(NEI, fips == "24510" & type=="ON-ROAD")

# Calcular el total de emisiones por año
BaltimoreMVPM25ByYear <- BaltimoreCityMV %>% select (year, Emissions) %>% 
  group_by(year) %>% 
  summarise_each(funs(sum))

# Graficar el resultado
qplot(year, Emissions, data=BaltimoreMVPM25ByYear, geom="line") +
  ggtitle(expression("Baltimore City" ~ PM[2.5] ~ "Motor Vehicle Emissions by Year")) +
  xlab("Year") + 
  ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))

# Copiar la gráfica en un archivo png
dev.copy(device = png, filename = 'plot5.png', width = 500, height = 400)
dev.off ()
