# Collaborative Data Analysis Project 
# Steps
# 1. Load and data cleaning

# Make an objet
URL <- "http://esa.un.org/unmigration/TIMSO2013/data/subsheets/UN_MigrantStockByOriginAndDestination_2013T10.xls"
#Create a temporary file to put the zip 
temp <- tempfile()
# Download the compressed 
download.file(URL, temp)
# 
OECDMigration2010 <-read.ftable(temp, "DIOC_2010_11_File_A_bis_REV.csv"))

# put in the code the URL. and then download. 

# WDI
install.packages('WDI')
library(WDI)

WDI_indi<- WDI(country = "all", indicator = c("IT.CEL.SETS.P2", "IT.NET.USER.P2"),
                   start = 1990, end = 2013, extra = FALSE, cache = NULL)
