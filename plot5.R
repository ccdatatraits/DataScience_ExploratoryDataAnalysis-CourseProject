## ==ANSWER: Increasing significantly from 1999-2002
##           Dropping slightly from 2002-2005
##           Dropping significantly from 2005-2008


## Reads the relevant data and creates PNG diagram for plot5

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

# Install "ggplot2" package if required.
# This will be needed to group and summarize data
ggplot2Package <- "ggplot2"
if (!ggplot2Package %in% installed.packages()[,"Package"])
    install.packages(ggplot2Package)

# Load "ggplot2" package needed to plot ggplot2 style graphs
library(ggplot2)

# Make SCC factor from NEI dataset so it can be merged to SCC
NEI$SCC = factor(NEI$SCC)

# Filter data to only Baltimore City, Maryland region (fips == 24510)
NEI_BaltimoreCity <- filter(NEI, fips == "24510")

# Select only the required variables
selected_NEI <- select(NEI_BaltimoreCity, SCC, Emissions, year)
selected_SCC <- select(SCC, SCC, Short.Name)

# Merge data by SCC
merged_data <- merge(selected_NEI, selected_SCC, by = "SCC")

# Filter only those cases where Short.Name matches "motor" (ignore case)
filtered_data <- filter(merged_data, 
                        grepl("motor", Short.Name, ignore.case = TRUE))

# Summarize filtered_data by year and sum the total emissions
yearSummary <- summarize(group_by(filtered_data, year), 
                         total_emissions = sum(Emissions))

# With filtered data for coal sources, plot the desired graph
qplot(year, total_emissions, data = yearSummary, geom = c("point", "smooth"))

# Save to plot5.png using ggsave from ggplot2 package
ggsave(file="plot5.png")