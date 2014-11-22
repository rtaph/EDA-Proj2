# Reproducible Research: Peer Assessment 2
## Data Processing
We begin by loading libraries and setting a few global parameters:

```r
  library(knitr)
  opts_chunk$set(echo=TRUE, cache=TRUE)
  setwd("~/datasciencecoursera/RepResProj2/")
```

We first download and unzip the data (if necessary):

```r
  #Download file if it does not exist
  if (!file.exists("exdata-data-NEI_data.zip")) {
      message("Downloading data...")
      fileURL <- "http://goo.gl/FWZqTP"
      zipfile = "exdata-data-NEI_data.zip"
      download.file(fileURL, destfile=zipfile, method="curl")
      unzip(zipfile)
  }
```

We then read the data into R

```r
  # Load the csv files and assign it to a variable
  NEI   = readRDS("summarySCC_PM25.rds")
  SCC   = readRDS("Source_Classification_Code.rds")
```

The data contains

```r
  str(NEI)
```

```
## 'data.frame':	6497651 obs. of  6 variables:
##  $ fips     : chr  "09001" "09001" "09001" "09001" ...
##  $ SCC      : chr  "10100401" "10100404" "10100501" "10200401" ...
##  $ Pollutant: chr  "PM25-PRI" "PM25-PRI" "PM25-PRI" "PM25-PRI" ...
##  $ Emissions: num  15.714 234.178 0.128 2.036 0.388 ...
##  $ type     : chr  "POINT" "POINT" "POINT" "POINT" ...
##  $ year     : int  1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 ...
```

## PLOT 1

### The Question
Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total $\sf{PM_{2.5}}$ emission from all sources for each of the years 1999, 2002, 2005, and 2008.

### The Analysis

```r
  hist(NEI$year)
```

![](./plot1_files/figure-html/unnamed-chunk-2-1.png) 


```r
  ## Plot historgram and save PNG
  names(NEI)
```

```
## [1] "fips"      "SCC"       "Pollutant" "Emissions" "type"      "year"
```


```r
  ## Plot historgram and save PNG
  png("plot1.png", width = 480, height = 480)
  #plot
  dev.off()
```

```
## pdf 
##   2
```

## System Info

```r
sessionInfo()
```

```
## R version 3.1.1 (2014-07-10)
## Platform: x86_64-apple-darwin10.8.0 (64-bit)
## 
## locale:
## [1] en_CA.UTF-8/en_CA.UTF-8/en_CA.UTF-8/C/en_CA.UTF-8/en_CA.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] knitr_1.7
## 
## loaded via a namespace (and not attached):
## [1] codetools_0.2-9 digest_0.6.4    evaluate_0.5.5  formatR_1.0    
## [5] htmltools_0.2.6 rmarkdown_0.3.3 stringr_0.6.2   tools_3.1.1    
## [9] yaml_2.1.13
```
