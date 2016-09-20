library(dplyr)
library(ggplot2)

if( !(file.exists("Source_Classification_Code.rds") & file.exists("summarySCC_PM25.rds")) ){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip")
  unzip("FNEI_data.zip")
}

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

motor_vehicles <- grepl("Motor Vehicle", SCC$SCC.Level.Three)
motor_vehicles_SCC <- SCC[motor_vehicles,]$SCC

rows_Baltimore <- filter(NEI, (SCC %in% motor_vehicles_SCC) & (fips == "24510"))
byYear_Baltimore <- group_by(rows_Baltimore, year)
plotData_Baltimore <- summarise(byYear_Baltimore, Total.Emissions = sum(Emissions, na.rm=TRUE))
#plotData_Baltimore$country <- "Baltimore"
rows_Los_Angeles <- filter(NEI, (SCC %in% motor_vehicles_SCC) & (fips == "06037"))
byYear_Los_Angeles <- group_by(rows_Los_Angeles, year)
plotData_Los_Angeles <-summarise(byYear_Los_Angeles, Total.Emissions = sum(Emissions, na.rm=TRUE))
#plotData_Los_Angeles$country <- "Los.Angeles"

#plotData <- rbind(plotData_Baltimore, plotData_Los_Angeles)

png(filename="plot6.png", width=480, height=480)
plot(plotData_Los_Angeles, type="b", xlab="Year", ylab="Baltimore vs. Los Angeles", col="blue", lwd=3, ylim=c(0,100))
points(plotData_Baltimore, type="b", col="red", lwd=3)
legend("topright", col=c("blue", "red"), pch=1, lwd=3, legend = c("Los Angeles", "Baltimore"))
legend
dev.off()