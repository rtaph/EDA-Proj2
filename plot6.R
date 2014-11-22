## PLOT 6: A script to generate a comparative plot of motor
## vehicle emissions in Baltimore City and LA county.

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
  
  # Subset data to include only motor vehicle data from Baltimore City
  # or LA County. Skip if cached.
  if(!exists("dt.mv2", inherits = FALSE)){
    dt.mv2 = subset(dt, fips %in% c("24510", "06037"))
    dt.mv2 = subset(dt.mv2, grepl("On-Road", dt.mv2$EI.Sector, 
                                  ignore.case = TRUE))
    dt.mv2 = subset(dt.mv2, !grepl("Non-Road", dt.mv2$EI.Sector, 
                                   ignore.case = TRUE))
  }
  
  # Summarize data by year and county (skip if cached)
  if(!exists("t6", inherits = FALSE)){
    t6 = with(dt.mv2, aggregate(Emissions, by = list(year,fips), sum))
    names(t6) = c("Year","County","Total.Emissions")
    t6$County = gsub("24510","Baltimore City",t6$County)
    t6$County = gsub("06037","LA County",t6$County)
    t6$County = as.factor(t6$County)
    t6$Year = as.factor(t6$Year)
  }
  
  # Make barplot and save as PNG
  if(!require(ggplot2)){install.packages("ggplot2")}
  ggplot(t6, aes(Year,Total.Emissions)) + 
    geom_bar(aes(fill = County),position = "dodge", stat="identity") +
    ggtitle("Plot 6: Comparative Motor Vehicle Emissions")
  ggsave(file="plot6.png", width = 6, height = 4, dpi = 100)
