## plot4.R
#  Diciembre 15 de 2020 - NSS
## Respuesta a la  tercera pregunta: 

#  4. Across the United States, how have emissions from coal combustion-related
#     sources changed from 1999–2008?.

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

# Extraer datos de combustión de carbón solamente 
CoalCombustionSCC0 <- subset(SCC, EI.Sector %in% 
                               c("Fuel Comb - Comm/Instutional - Coal",
                                 "Fuel Comb - Electric Generation - Coal",
                                 "Fuel Comb - Industrial Boilers, ICEs - Coal"))

# Comparar de tal forma que los datos coincidan con Comb y Coal
CoalCombustionSCC1 <- subset(SCC, grepl("Comb", Short.Name) & 
                               grepl("Coal", Short.Name))

# 
print(paste("Number of subsetted lines via EI.Sector:", nrow(CoalCombustionSCC0)))
print(paste("Number of subsetted lines via Short.Name:", nrow(CoalCombustionSCC1)))

# Establecer la diferencias
diff0 <- setdiff(CoalCombustionSCC0$SCC, CoalCombustionSCC1$SCC)
diff1 <- setdiff(CoalCombustionSCC1$SCC, CoalCombustionSCC0$SCC)

print(paste("Number of setdiff (data via EI.Sector & Short.Name):", length(diff0)))
print(paste("Number of setdiff (data via Short.Name & EI.Sector):", length(diff1)))

# Crear un vector con la unión de SCCs via EI.Sector & Short.Name
CoalCombustionSCCCodes <- union(CoalCombustionSCC0$SCC, CoalCombustionSCC1$SCC)
print(paste("Number of SCCs:", length(CoalCombustionSCCCodes)))

# Chequear los datos y extraer lo necesario de NEI data via SCCs
CoalCombustion <- subset(NEI, SCC %in% CoalCombustionSCCCodes)

# Calcular la emisión total por año y tipo
coalCombustionPM25ByYear <- CoalCombustion %>% select(year, type, Emissions) %>%
  group_by(year, type) %>%
  summarise_each(funs(sum))

# Graficar el resultado
qplot(year, Emissions, data = coalCombustionPM25ByYear, color = type, geom = "line") + 
  stat_summary(fun.y = "sum", fun.ymin = "sum", fun.ymax = "sum", color = "purple", aes(shape="total"), geom="line") +
  # geom_line(aes(size="total", shape = NA, col = "purple")) + 
  ggtitle(expression("Coal Combustion" ~ PM[2.5] ~ "Emissions by Source Type and Year")) + 
  xlab("Year") + 
  ylab(expression  ("Total" ~ PM[2.5] ~ "Emissions (tons)"))

# Graficar el resultado
qplot(year, Emissions, data = coalCombustionPM25ByYear, color = type, geom = "line") + 
  stat_summary(fun.y = "sum", aes(year, Emissions, color = "Total"), geom="line") +
  ggtitle(expression("Coal Combustion" ~ PM[2.5] ~ "Emissions by Source Type and Year")) + 
  xlab("Year") + 
  ylab(expression  ("Total" ~ PM[2.5] ~ "Emissions (tons)"))


# Copiar la gráfica en un archivo png
dev.copy(device = png, filename = 'plot4.png', width = 500, height = 400)
dev.off ()

