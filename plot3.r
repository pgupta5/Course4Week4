library(ggplot2) 

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


jpeg('question3.jpg')
##NEIBaltimore = subset(NEI, fips %in% c(24510))
ggplot(NEIBaltimore,aes(factor(year),Emissions,fill=type)) +
        geom_histogram(stat="identity", width = .5) +
        labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
        labs(title="Emissions for each source type (1999-2008) in Baltimore City")
dev.off()