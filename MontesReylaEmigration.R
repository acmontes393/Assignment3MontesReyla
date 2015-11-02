# Collaborative Data Analysis Project 


# Installing and loading packages
install.packages('WDI')
install.packages('tidyr')
library(WDI)
library(tidyr)
library(rio)

#Setting directory
setwd('/Users/AnaCe/Dropbox/Hertie/CollaborativeDataAnalysis/R/Assignment3MontesReyla')

# 1. Load and data cleaning
# Migration UN Data: loop
tables <-c(2, 5, 8, 11)
for (i in tables)
  {
  Migration<- import("UN_MigrantStockByOriginAndDestination_2013T10.xls", format = "xls", sheet =i)
  emigration<- Migration[c(15,16),]
  emigration<- t(emigration)
  emigration<-as.data.frame(emigration)
  emigration<- emigration[c(10:241),]
  colnames(emigration) <- c("Country","Emigration")
  assign(paste0("emigration", i), emigration)
}
emigrationtotal <- cbind(emigration11, emigration8, emigration5, emigration2)
emigrationtotal <-emigrationtotal[,c(1,2, 4, 6,  8)]

# WDI
library(WDI)

WDI_indi<- WDI(country = "all", indicator = c("IT.CEL.SETS.P2", "IT.NET.USER.P2"),
                   start = 1990, end = 2013, extra = FALSE, cache = NULL)

