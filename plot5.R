## PLOT 5: A script to generate a plot of total yearly
## emissions from motor vehicle in Baltimore city.

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
  
  # Subset data to include only categories of motor vehicles
  if(!exists("dt.mv", inherits = FALSE)){
    dt.mv = subset(dt.baltimore, grepl("On-Road", dt.baltimore$EI.Sector, 
                                      ignore.case = TRUE))
    dt.mv = subset(dt.mv, !grepl("Non-Road", dt.mv$EI.Sector, ignore.case = TRUE))
  }
  
  # Summarize data by year (skip if cached)
  if(!exists("t5", inherits = FALSE)){
    t5 = with(dt.mv, aggregate(Emissions, by = list(year), sum))
    names(t5) = c("Year","Total.Emissions")
  }
  
  # Make barplot and save as PNG
  png("plot5.png", width = 480, height = 480)
  barplot(t5[[2]], t5[[1]], col="steelblue", 
          main = "Plot 5: Emissions - Motor Vehicles (Baltimore City)", 
          xlab="Year", ylab = "Total Emissions (tonnes of PM2.5)", 
          names = t5$Year)
  dev.off()
