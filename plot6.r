filename <- "exdata_data_NEI_data.zip"

# Download and unzip the dataset
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(fileURL, filename, method="curl")
}  

unzip(filename) 

## Reading the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

jpeg('plot6.jpg')
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
