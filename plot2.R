## ==ANSWER: No, total emissions for Baltimore City, Maryland have NOT 
##           gradually decreased from 1998 to 2008==


## Reads the relevant data and creates PNG diagram for plot2

# Check that the zipfile exists or not
zipfile <- "exdata_data_NEI_data.zip"
# If zipfile doesn't exist, fetch the data from URL provided
if (!file.exists(zipfile)) {
    sprintf("Fetching Data: %s\n", zipfile)
    zipfile_url <- paste("https://d396qusza40orc.cloudfront.net/", 
                         "exdata%2Fdata%2FNEI_data.zip", sep = "")
    download.file(zipfile_url, zipfile, method = "curl")
    dateDownloaded <- date()
    dateDownloaded
} else print("Data already exist")

# Check that zip file has been unzipped or not by looking for the first file
pmEmissionDataFile <- "summarySCC_PM25.rds"
sourceClassCodeDataFile <- "Source_Classification_Code.rds"
# If file doesn't exist, then unzip data
if (!file.exists(pmEmissionDataFile)) {
    print("Unzipping Data")
    unzip(zipfile)
} else print("Data already unzipped")
## Read unzipped data into R objects
NEI <- readRDS(pmEmissionDataFile)
SCC <- readRDS(sourceClassCodeDataFile)

# Install "dplyr" package if required.
# This will be needed to group and summarize data
dplyrPackage <- "dplyr"
if (!dplyrPackage %in% installed.packages()[,"Package"])
    install.packages(dplyrPackage)

# Load "dplyr" package needed to group data to summarize
library(dplyr)

# Filter data to only Baltimore City, Maryland region (fips == 24510)
NEI_BaltimoreCity <- filter(NEI, fips == "24510")
# Summarize grouped data by year and sum the total emissions for Baltimore City
yearSummary <- summarize(group_by(NEI_BaltimoreCity, year), 
                         total_emissions = sum(Emissions))

# With the summarized data (yearSummary) plot the desired graph
# pch is set to NA_integer_ so that no symbol is shown
with(yearSummary, {
    plot(year, total_emissions, 
         xlab = "year", ylab = "Total Emissions", 
         pch = 15)
    # Now using the lines function we draw the connected lines in the graph
    lines(year, total_emissions)
})

## Copy my plot to a PNG file, by default the height and width is 480 pixels
dev.copy(png, file = "plot2.png")
## Don't forget to close the PNG device!
dev.off()