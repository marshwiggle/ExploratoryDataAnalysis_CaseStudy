library(dplyr)
library(ggplot2)

if( !(file.exists("Source_Classification_Code.rds") & file.exists("summarySCC_PM25.rds")) ){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip")
  unzip("FNEI_data.zip")
}

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

combusted <- grepl("Combust", SCC$SCC.Level.One)
combusted_rows <- SCC[combusted,]
coal <- grepl("Coal", combusted_rows$SCC.Level.Three)
SCC_col <- combusted_rows[coal,]$SCC

rows <- filter(NEI, SCC %in%SCC_col)
byYear <- group_by(rows, year)
plotData<- summarise(byYear, Total.Emissions = sum(Emissions, na.rm=TRUE))


png(filename="plot4.png", width=480, height=480)
plot(plotData, type="b", xlab="Year", ylab="Total Emissions", col="red", lwd=3)
dev.off()