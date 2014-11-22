## PLOT 3: A script to generate a plot of total yearly
## emissions by type for Baltimore City.
  
  # Set the working directory
  setwd("~/datasciencecoursera/EDA-Proj2/")
  
  # Download and unzip the data (if necessary):
  if(!file.exists("exdata-data-NEI_data.zip")) {
    message("Downloading data...")
    fileURL <- "http://goo.gl/FWZqTP"
    zipfile = "exdata-data-NEI_data.zip"
    download.file(fileURL, destfile=zipfile, method="curl")
    unzip(zipfile)
  }
  
  # Read and merge the source files into a single table. A data.table
  # object is used instead of a dataframe to maximize memory efficiency,
  # and redundant tables are removed. An if statement checks if the
  # object is already in cache.
  if(!exists("dt", inherits = FALSE)){
    if(!require(data.table)){install.packages("data.table")}
    NEI <- data.table(readRDS("summarySCC_PM25.rds"), key = "SCC") 
    SCC <- data.table(readRDS("Source_Classification_Code.rds"), key = "SCC")
    dt  <- SCC[NEI,]
    rm(NEI,SCC)
  }
  
  # Subset data to include only data from Baltimore City, 
  # Maryland (fips == 24510). Skip if cached.
  if(!exists("dt.baltimore", inherits = FALSE)){
    dt.baltimore = subset(dt, fips == 24510)
  }
  
  # Summarize data by year and type (skip if cached)
  if(!exists("t3", inherits = FALSE)){
    t3 = with(dt.baltimore, aggregate(Emissions, by = list(year, type), sum))
    names(t3) = c("Year","Type","Total.Emissions")
  }
  
  # Make lineplot and save as PNG
  if(!require(ggplot2)){install.packages("ggplot2")}
  p3 = ggplot(t3, aes(x = Year, y = Total.Emissions, color = Type))
  p3 + geom_line(size=1) + geom_point(size=3) + 
    ylab("Total Emissions (tonnes of PM2.5)") + xlab("Year") + 
    ggtitle("Plot 3: Emissions by Type (Baltimore City, Maryland)")
  ggsave(file="plot3.png", width = 6, height = 4, dpi = 100)