# Instructions

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the EPA National Emissions Inventory web site.

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

The data for this assignment are available from the course web site as a single zip file:
https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

The zip file contains two files:
PM2.5 Emissions Data (summarySCC_PM25.rds\color{red}{\verb|summarySCC_PM25.rds|}summarySCC_PM25.rds): This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year. 

    fips: A five-digit number (represented as a string) indicating the U.S. county
    SCC: The name of the source as indicated by a digit string (see source code classification table)
    Pollutant: A string indicating the pollutant
    Emissions: Amount of PM2.5 emitted, in tons
    type: The type of source (point, non-point, on-road, or non-road)
    year: The year of emissions recorded

Source Classification Code Table: This table provides a mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source “10100101” is known as “Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal”.

Loading the data, this may take a few seconds to complete.

```
# Download and unzip the dataset
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(fileURL, filename, method="curl")
}  

unzip(filename) 

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
```

# Question 1 (![code](/plot1.r))
Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

```
jpeg('question1.jpg')
PM2.5Years = subset(NEI, year %in% c(1999,2002,2005,2008))
tapply(NEI$Emissions, NEI$year, FUN=sum)
barplot(tapply(NEI$Emissions, NEI$year, FUN=sum),main="Emissions per year",
        xlab = 'Year',
        ylab = 'Emissions')

dev.off()
```
The total emissions have decreased in the United States from 1999 to 2008.

![Question 1 plot](/plot1.jpg)
    
## Question 2 (![code](/plot2.r))
Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

```
jpeg('question2.jpg')
NEIBaltimore = subset(NEI, fips %in% c(24510))
barplot(tapply(NEIBaltimore$Emissions, NEIBaltimore$year, FUN=sum),
        main="Emissions per year",
        xlab = 'Year',
        ylab = 'Emissions')
dev.off()
```
The total emissions have decreased in Baltimore City, Maryland from 1999 to 2008.

![Question 2 plot](/plot2.jpg)

## Question 3 (![code](/plot3.r))
Of the four types of sources indicated by the type(point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

```
library(ggplot2) 
jpeg('question3.jpg')
##NEIBaltimore = subset(NEI, fips %in% c(24510))
ggplot(NEIBaltimore,aes(factor(year),Emissions,fill=type)) +
        geom_histogram(stat="identity", width = .5) +
        labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
        labs(title="Emissions for each source type (1999-2008) in Baltimore City")
dev.off()
```
The nonroad and onroad type have shown a decrease in emission from 1999-2008 for Baltimore City.

![Question 3 plot](/plot3.jpg)

## Question 4 (![code](/plot4.r))
Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
   
```
jpeg('question4.jpg')
#Subset data for coal combustion 
SCCcoal <- SCC[grepl("coal", SCC$Short.Name, ignore.case = T),]
NEIcoal <- NEI[NEI$SCC %in% SCCcoal$SCC,]
ggplot(NEIcoal,aes(x = factor(year),y = Emissions/10^5)) +
        geom_bar(stat="identity") +
        labs(x="Year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
        labs(title=expression("Coal Combustion Source Emissions Across US from 1999-2008"))
dev.off()
```
The total emissions related to coal combustions have decreased from 1999 to 2008.

![Question 4 plot](/plot4.jpg)

## Question 5 (![code](/plot5.r)
How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

```
jpeg('question5.jpg')

#Subset data for Vehicles
SCCMV <- SCC[grepl("Vehicles", SCC$Short.Name, ignore.case = T),]

#Subset of the NEI data which corresponds to vehicles
NEIMV <- NEI[NEI$SCC %in% SCCMV$SCC,]

NEIMVBaltimore = subset(NEIMV, fips %in% c("24510"))

ggplot(NEIMVBaltimore,aes(x = factor(year),y = Emissions)) +
        geom_bar(stat="identity") +
        labs(x="Year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
        labs(title=expression("Motor Vehicle Source Emissions in Baltimore City from 1999-2008"))
dev.off()
```
The total emissions for motor vehicles have decreased in Baltimore City, Maryland from 1999 to 2008.

![Question 5 plot](/plot5.jpg)

## Question 6 (![code](/plot6.r))
Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

```
jpeg('question6.jpg')
#Subset data for Vehicles
SCCMV <- SCC[grepl("Vehicles", SCC$Short.Name, ignore.case = T),]
#Subset of the NEI data which corresponds to vehicles
NEIMV <- NEI[NEI$SCC %in% SCCMV$SCC,]
#Subset data for LA
NEIMVLA = subset(NEIMV, fips %in% c("06037"))
#Subset data for Baltimore City
NEIMVBaltimore = subset(NEIMV, fips %in% c("24510"))

NEIMVBaltimore$city <- "Baltimore City"
NEIMVLA$city <- "LA"

CombinedNEI <- rbind(NEIMVBaltimore,NEIMVLA)
ggplot(CombinedNEI, aes(x=factor(year), y=Emissions, fill=city)) +
        geom_bar(aes(fill=year),stat="identity") +
        facet_grid(.~city) +
        labs(x="Year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
        labs(title="Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008")

dev.off()
```
The total emissions have decreased in both cities from 1999 to 2008. The emissions in Baltimore have reduced to almost half whereas in LA, there is a decrease but not more than half the levels in 1999.

![Question 6 plot](/plot6.jpg)
