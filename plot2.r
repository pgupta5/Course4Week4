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

jpeg('plot2.jpg')
#subset data for Baltimore
NEIBaltimore = subset(NEI, fips %in% c(24510))
barplot(tapply(NEIBaltimore$Emissions, NEIBaltimore$year, FUN=sum),
        main="Emissions per year in Baltimore City, Maryland ",
        xlab = 'Year',
        ylab = 'Emissions')
dev.off()
