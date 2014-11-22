## PLOT 4: A script to generate a plot of total yearly
## emissions for coal related sources.

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
  
  # Subset data to include only data with keyword "coal"
  if(!exists("dt.coal", inherits = FALSE)){
    dt.coal = subset(dt, grepl("Coal", dt$SCC.Level.Three, ignore.case = TRUE) |
                         grepl("Coal", dt$SCC.Level.Four, ignore.case = TRUE) )
  }
  
  # Summarize data by year and type (skip if cached)
  if(!exists("t4", inherits = FALSE)){
    t4 = with(dt.coal, aggregate(Emissions, by = list(year), sum))
    names(t4) = c("Year","Total.Emissions")
  }
  
  # Make barplot and save as PNG
  png("plot4.png", width = 480, height = 480)
  barplot(t4[[2]], t4[[1]], col="steelblue", 
          main = "Plot 4: Emissions Trends - Coal Related Sources", 
          xlab="Year", ylab = "Total Emissions (tonnes of PM2.5)", 
          names = t4$Year)
  dev.off()
