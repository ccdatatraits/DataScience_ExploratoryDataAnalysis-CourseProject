## ==ANSWER: Not really dropping for ON-ROAD
##           Very gradually dropping for NON-ROAD
##           Dropping for POINT
##           Dropping at a much higher rate for NONPOINT


## Reads the relevant data and creates PNG diagram for plot3

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

# Install "ggplot2" package if required.
# This will be needed to group and summarize data
ggplot2Package <- "ggplot2"
if (!ggplot2Package %in% installed.packages()[,"Package"])
    install.packages(ggplot2Package)

# Load "ggplot2" package needed to plot ggplot2 style graphs
library(ggplot2)

# With filtered data for Baltimore City, plot the desired graph
g <- ggplot(NEI_BaltimoreCity, aes(year, Emissions, group = 1))
g + geom_point() + facet_grid(. ~ type) + geom_smooth(method = "lm") + 
    coord_cartesian(ylim = c(0, 500))

# Save to plot3.png using ggsave from ggplot2 package
ggsave(file="plot3.png")