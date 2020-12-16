## plot6.R
#  Diciembre 15 de 2020 - NSS
## Respuesta a la  tercera pregunta: 

#  6 Compare emissions from motor vehicle sources in Baltimore City 
#    with emissions from motor vehicle sources in Los Angeles County,
#    California (fips == "06037"). 
#    Which city has seen greater changes over time in motor vehicle emissions?

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

# Extraer etch data of type "ON-ROAD" from Baltimore City & Los Angeles County, California
MV <- subset(NEI, (fips == "24510" | fips == "06037") & type=="ON-ROAD")
# Use more meaningful variable names
MV <- transform(MV, region = ifelse(fips == "24510", "Baltimore City", 
                                    "Los Angeles County"))

# Calculate the sum of emission by year and region
MVPM25ByYearAndRegion <- MV %>% select (year, region, Emissions) %>% 
  group_by(year, region) %>% 
  summarise_each(funs(sum))

# Create a plot normalized to 1999 levels to better show change over time
Balt1999Emissions <- subset(MVPM25ByYearAndRegion, year == 1999 & 
                              region == "Baltimore City")$Emissions
LAC1999Emissions <- subset(MVPM25ByYearAndRegion, year == 1999 & 
                             region == "Los Angeles County")$Emissions
MVPM25ByYearAndRegionNorm <- transform(MVPM25ByYearAndRegion,
                                       EmissionsNorm = ifelse(region == 
                                                                "Baltimore City",
                                                              Emissions / Balt1999Emissions,
                                                              Emissions / LAC1999Emissions))

# Plot the result
qplot(year, EmissionsNorm, data=MVPM25ByYearAndRegionNorm, geom="line", color=region) +
  ggtitle(expression("Total" ~ PM[2.5] ~ "Motor Vehicle Emissions Normalized to 1999 Levels")) + 
  xlab("Year") +
  ylab(expression("Normalized" ~ PM[2.5] ~ "Emissions"))

# Copy Plot in png-file
dev.copy(device = png, filename = 'plot6.png', width = 500, height = 400)
dev.off ()

