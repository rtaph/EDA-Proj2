## PLOT 2: A script to generate a bar plot of total emissions
## by year for Baltimore City, Maryland.
  
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
  # Maryland (fips == 24510) 
  dt.baltimore = subset(dt, fips == 24510)
  
  # Summarize data by year (skip if cached)
  if(!exists("t2", inherits = FALSE)){
    t2 = with(dt.baltimore, aggregate(Emissions, by = list(year), sum))
    names(t2) = c("Year","Total.Emissions")
  }
  
  # Make barplot and save as PNG
  png("plot2.png", width = 480, height = 480)
    barplot(t2[[2]], t2[[1]], col="steelblue", 
            main = "Plot 2: Emissions Trends (Baltimore City, Maryland)", 
            xlab="Year", ylab = "Total Emissions (tonnes of PM2.5)", 
            names = t2$Year)
  dev.off()
