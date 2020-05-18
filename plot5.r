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