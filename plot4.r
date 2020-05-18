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

jpeg('question4.jpg')
#Subset data for coal combustion 
SCCcoal <- SCC[grepl("coal", SCC$Short.Name, ignore.case = T),]
NEIcoal <- NEI[NEI$SCC %in% SCCcoal$SCC,]
ggplot(NEIcoal,aes(x = factor(year),y = Emissions/10^5)) +
        geom_bar(stat="identity") +
        labs(x="Year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
        labs(title=expression("Coal Combustion Source Emissions Across US from 1999-2008"))
dev.off()