# Collaborative Data Analysis Project 


# Installing packages
install.packages('xlsx')
install.packages('WDI')

#Setting directory
setwd('/Users/AnaCe/Dropbox/Hertie/CollaborativeDataAnalysis/R/Assignment3MontesReyla')


# 1. Load and data cleaning
# Make an objet
URL <- "http://esa.un.org/unmigration/TIMSO2013/data/subsheets/UN_MigrantStockByOriginAndDestination_2013T10.xls"
#Create a temporary file to put the zip 
temp <- tempfile()
# Download the compressed 
download.file(URL, Migration90.xls)
# 
Migration90 = read.table( "UN_MigrantStockByOriginAndDestination_2013T10.xls")

# another way

require(xlsx)
library(rio)
full <- read.xlsx(temp, sheetIndex = 2)

full <- import("UN_MigrantStockByOriginAndDestination_2013T10.xls", format = "xls", sheet = 2)

full <- readxl::read_excel(temp, sheet = 2)

full <- import(temp, sheet = 2, format = "xls")

# WDI
library(WDI)

WDI_indi<- WDI(country = "all", indicator = c("IT.CEL.SETS.P2", "IT.NET.USER.P2"),
                   start = 1990, end = 2013, extra = FALSE, cache = NULL)

