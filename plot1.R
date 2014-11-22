## PLOT 1: A script to generate a bar plot of total emissions
## by year.
  
  ## Set the working directory
  setwd("~/datasciencecoursera/EDA-Proj2/")
  
  ## Download and unzip the data (if necessary):
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
  
  ## Summarize data by year (skip if cached)
  if(!exists("t1", inherits = FALSE)){
    t1 = with(dt, aggregate(Emissions, by = list(year), sum))
    names(t1) = c("Year","Total.Emissions")
  }
  
  ## Make barplot and save as PNG
  png("plot1.png", width = 480, height = 480)
    barplot(t1[[2]], t1[[1]], col="steelblue", 
            main = "Plot 1: Emissions Trends", 
            xlab="Year", ylab = "Total Emissions (tonnes of PM2.5)", 
            names = t1$Year)
  dev.off()
