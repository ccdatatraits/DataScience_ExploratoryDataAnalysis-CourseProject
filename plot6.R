## ==ANSWER: Baltimore City, Maryland region (fips == 24510): Stagnant
##           Los Angeles County, California regoin (fips == 06037): Increasing


## Reads the relevant data and creates PNG diagram for plot6

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
#NEI$fips = factor(NEI$fips)

# Filter data to Baltimore City, Maryland region (fips == 24510)
# and Los Angeles County, California regoin (fips == 06037)
NEI_filtered <- filter(NEI, fips == "24510" | fips == "06037")

# Select only the required variables for Balitmore City & Los Angeles County
selected_NEI <- select(NEI_filtered, fips, SCC, Emissions, year)
selected_SCC <- select(SCC, SCC, Short.Name)

# Merge data by SCC for both regions
merged_data <- merge(selected_NEI, selected_SCC, by = "SCC")

# Filter only those cases where Short.Name matches "motor" (ignore case)
filtered_data <- filter(merged_data, 
                        grepl("motor", Short.Name, ignore.case = TRUE))

# With filtered data for coal sources, plot the desired graph
g <- ggplot(filtered_B_data, aes(year, Emissions, group = 1))
g + geom_point() + facet_grid(. ~ fips) + geom_smooth(method = "lm") + 
    coord_cartesian(ylim = c(0, 20))

# Save to plot6.png using ggsave from ggplot2 package
ggsave(file="plot6.png")