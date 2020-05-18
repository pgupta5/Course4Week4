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

jpeg('question1.jpg')

PM2.5Years = subset(NEI, year %in% c(1999,2002,2005,2008))

tapply(NEI$Emissions, NEI$year, FUN=sum)

barplot(tapply(NEI$Emissions, NEI$year, FUN=sum),main="Emissions per year",
        xlab = 'Year',
        ylab = 'Emissions')

dev.off()
