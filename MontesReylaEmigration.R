# Collaborative Data Analysis Project 

# Installing and loading packages
install.packages('WDI')
install.packages('tidyr')
install.packages('rio')

library(WDI)
library(tidyr)
library(rio)

#Setting directory
#setwd('/Users/AnaCe/Dropbox/Hertie/CollaborativeDataAnalysis/R/Assignment3MontesReyla')

setwd('/Users/ayrarowenareyla/Desktop/The Hertie School of Governance/Collaborative Social Sciences/Assignment3MontesReyla')


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
emigrationtotal <- gather(emigrationtotal, year, emigration, 2:5)
emigrationtotal$year <- as.character(emigrationtotal$year)
emigrationtotal$year[emigrationtotal$year=="Emigration"] <- "2013"
emigrationtotal$year[emigrationtotal$year=="Emigration.1"] <- "2010"
emigrationtotal$year[emigrationtotal$year=="Emigration.2"] <- "2000"
emigrationtotal$year[emigrationtotal$year=="Emigration.3"] <- "1990"
ls()
rm(list = c("emigration","emigration11", "emigration2", "emigration5", "emigration8", 
            "i", "tables"))


# 2. Loading the default data for the years 2000-2012 from the Worldbank database
wbdata <- c ("IT.CEL.SETS.P2", "IT.NET.USER.P2", "NY.GDP.PCAP.PP.CD","SP.POP.TOTL","SI.POV.DDAY","SL.UEM.TOTL.ZS","VC.IHR.PSRC.P5"
,"CC.EST","GE.EST","PV.EST","RQ.EST","RL.EST","VA.EST","SP.DYN.TFRT.IN","")

# WDI

WDI_indi<- WDI(country = "all", indicator = wbdata,
                   start = 1990, end = 2013, extra = FALSE, cache = NULL)



# MAPS
library(sp)
getClass("Spatial")
library(spatstat)
library(spdep)
library(RColorBrewer)
library(classInt)



