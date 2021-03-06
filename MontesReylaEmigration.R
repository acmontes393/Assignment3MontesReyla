########################################################################################
########################## Collaborative Data Analysis Assigement 3 ####################
########################################################################################

# 0. Clearing the workspace
rm(list = ls())

# 1. Installing and loading packages

#install.packages('WDI')
#install.packages('tidyr')
#install.packages('rio')
#install.packages('countrycode')
#install.packages("RJOSONIO")  
#install.packages ("ggplot2")
#install.packages("rworldmap")
#install.packages("sp")
#install.packages("joinCountryData2Map")
install.packages("plm")
install.packages("Formula")
install.packages("pglm")


library("ggmap")
library("maptools")
library("countrycode")
library("RJSONIO")
library("WDI")
library("tidyr")
library("rio")
library("ggplot2")
library("rworldmap")
library("sp")
library('rworldmap')
library('Formula')
library('plm')
library('pglm')

#2. Setting directory
setwd('/Users/AnaCe/Desktop/Assignment3MontesReyla')
#setwd('/Users/ayrarowenareyla/Desktop/The Hertie School of Governance/Collaborative Social Sciences/Assignment3MontesReyla/Assignment3MontesReyla')

########################################################################################
################################# LOADING AND CLEANING DATA ############################
########################################################################################

# 4. Loading Migration UN Data

### loop that loads into R each table in the file and extracts the relevant information for this assigment

tables <-c(2, 5, 8, 11)
for (i in tables)   {
  Migration<- import("UN_MigrantStockByOriginAndDestination_2013T10.xls", 
                     format = "xls", sheet =i)
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

# 5. Loading data from the Worldbank database
wbdata <- c ("IT.CEL.SETS.P2", "IT.NET.USER.P2", "NY.GDP.PCAP.PP.CD","SP.POP.TOTL","SI.POV.DDAY","SL.UEM.TOTL.ZS","VC.IHR.PSRC.P5"
,"CC.EST","GE.EST","PV.EST","RQ.EST","RL.EST","VA.EST","SP.DYN.TFRT.IN")

WDI_indi<- WDI(country = "all", indicator = wbdata,
                   start = 1990, end = 2013, extra = FALSE, cache = NULL)
# 6. Creating an unique identifier for both data frames
emigrationtotal$iso2c <- countrycode (emigrationtotal$Country, origin = 'country.name', 
                                      destination = 'iso2c', warn = TRUE)

WDI_indi$iso2c <- countrycode (WDI_indi$country, origin = 'country.name', 
                               destination = 'iso2c', warn = TRUE)

# Deleting agregates in the WDI indicators
WDI_indi <- WDI_indi[!is.na(WDI_indi$iso2c),]

# 7. Merging "WDI Indicators " and "UN Migration stocks"
Merged <- merge(emigrationtotal, WDI_indi, by = c('iso2c','year'))
summary(Merged)

# 8. Cleaning the data
Merged <- plyr::rename(Merged, c("IT.CEL.SETS.P2" = "CellphoneUsers"))
Merged <- plyr::rename(Merged, c("IT.NET.USER.P2" = "InternetUsers"))
Merged <- plyr::rename(Merged, c("NY.GDP.PCAP.PP.CD" = "GDPPerCapita"))
Merged <- plyr::rename(Merged, c("SP.POP.TOTL" = "TotalPopulation"))
Merged <- plyr::rename(Merged, c("SI.POV.DDAY" = "Poverty"))
Merged <- plyr::rename(Merged, c("SL.UEM.TOTL.ZS" = "UnemploymentRate"))
Merged <- plyr::rename(Merged, c("VC.IHR.PSRC.P5" = "IntentionalHomocides"))
Merged <- plyr::rename(Merged, c("CC.EST" = "Corruption"))
Merged <- plyr::rename(Merged, c("GE.EST" = "GovernmentEffectiveness"))
Merged <- plyr::rename(Merged, c("PV.EST" = "PoliticalStability"))
Merged <- plyr::rename(Merged, c("RQ.EST" = "RegulatoryQuality"))
Merged <- plyr::rename(Merged, c("RL.EST" = "RuleOfLaw"))
Merged <- plyr::rename(Merged, c("VA.EST" = " VoiceAndAccountability"))
Merged <- plyr::rename(Merged, c("SP.DYN.TFRT.IN" = "FertilityRate"))

# Counting missing information in the Independent Variables

variables <-c("CellphoneUsers", "InternetUsers", "GDPPerCapita", "TotalPopulation", "Poverty",
              "UnemploymentRate", "IntentionalHomocides", "Corruption", "FertilityRate", 
              "GovernmentEffectivness", "PoliticalStability", "RegulatoryStability", 
              "RegulatoryQuality", "RuleOfLaw", "VoiceAndAccountability")

NAs<- sum(is.na(Merged$CellphoneUsers))/nrow(Merged)
NAs$InternetUsers<- sum(is.na(Merged$InternetUsers))/nrow(Merged)
NAs$GDPPerCapita<- sum(is.na(Merged$GDPPerCapita))/nrow(Merged)
NAs$TotalPopulation<- sum(is.na(Merged$TotalPopulation))/nrow(Merged)
NAs$Poverty<- sum(is.na(Merged$Poverty))/nrow(Merged)
NAs$UnemploymentRate<- sum(is.na(Merged$UnemploymentRate))/nrow(Merged)
NAs$Corruption<- sum(is.na(Merged$Corruption))/nrow(Merged)
NAs$IntentionalHomocides<- sum(is.na(Merged$IntentionalHomocides))/nrow(Merged)
NAs$GovernmentEffectivness<- sum(is.na(Merged$GovernmentEffectivness))/nrow(Merged)
NAs$PoliticalStability<- sum(is.na(Merged$PoliticalStability))/nrow(Merged)
NAs$RegulatoryStability<- sum(is.na(Merged$RegulatoryStability))/nrow(Merged)
NAs$VoiceAndAccountability<- sum(is.na(Merged$VoiceAndAccountability))/nrow(Merged)
NAs$FertilityRate<- sum(is.na(Merged$FertilityRate))/nrow(Merged)

# After looking at the number of missing variables in the Merged data frame.
# Also, we are dropping independent variables with more than 15% of the total observations NA 
Merged <- Merged[, !(colnames(Merged)) %in% c("Poverty", "IntentionalHomocides","PoliticalStability","Corruption", "UnemploymentRate")]


# Dropping missing values
Merged <- Merged[!is.na(Merged$InternetUsers),]
Merged <- Merged[!is.na(Merged$CellphoneUsers),]
Merged <- Merged[!is.na(Merged$GDPPerCapita),]
Merged <- Merged[!is.na(Merged$FertilityRate),]


# Check Variables structure
str(Merged)
summary(Merged)
table (Merged$year)

# Code variables as numeric
Merged$year <- as.numeric(Merged$year)
Merged$emigration <- as.numeric(Merged$emigration)

# Removing extra country name coloumn
Merged <-subset.data.frame(Merged, select = -Country)

# 9. Generating variables
Merged$emigration2 = Merged$emigration/1000
Merged$emigrationpercap = Merged$emigration/Merged$TotalPopulation


# sub dataframes by year
merged90 <-subset(Merged, year==1990)
merged00 <-subset(Merged, year==2000)
merged10 <-subset(Merged, year==2010)
merged13 <-subset(Merged, year==2013)


# Creating a .csv file with the final version of the data
write.csv(Merged, file="MontesandReyla")

###############################################################################################
############################### DESCRIPTIVE STATISTICS ##############################
####################################################################################

##Set data as panel data
Merged <- plm.data(Merged, index=c("iso2c", "year"))

# Mapping global emigration
# 1990
sPDF <- joinCountryData2Map( merged90
                             ,joinCode = "ISO2"
                             ,nameJoinColumn = "iso2c")
mapDevice(Map1)
mapCountryData(sPDF, nameColumnToPlot='emigrationpercap', mapTitle= 'Number of emigrants per capita 1990',
               colourPalette = c("darkorange", "coral2","gold","aquamarine1", "cyan3", "blue","magenta"),
               borderCol='black')
# 2000
sPDFII <- joinCountryData2Map( merged00
                             ,joinCode = "ISO2"
                             ,nameJoinColumn = "iso2c")
mapDevice(Map2)
mapCountryData(sPDFII, nameColumnToPlot='emigrationpercap', mapTitle= 'Number of emigrants per capita 2000',
               colourPalette = c("darkorange", "coral2","gold","aquamarine1", "cyan3", "blue","magenta"),
               borderCol='black')
# 2010
sPDFIII <- joinCountryData2Map( merged10
                                ,joinCode = "ISO2"
                                ,nameJoinColumn = "iso2c")
mapDevice(Map3)
mapCountryData(sPDFIII, nameColumnToPlot='emigrationpercap', mapTitle= 'Number of emigrants per capita 2010',
               colourPalette = c("darkorange", "coral2","gold","aquamarine1", "cyan3", "blue","magenta"),
               borderCol='black')
# 2013
sPDFIV <- joinCountryData2Map( merged13
                               ,joinCode = "ISO2"
                               ,nameJoinColumn = "iso2c")
mapDevice(Map4)
mapCountryData(sPDFIV, nameColumnToPlot='emigrationpercap', mapTitle= 'Number of emigrants per capita 2013',
               colourPalette = c("darkorange", "coral2","gold","aquamarine1", "cyan3", "blue","magenta"),
               borderCol='black')


## Historgram
hist(Merged$emigration2, xlab = "Tousands of emigrants", main = "Histogram", xlim=range(0:14170))
hist(Merged$CellphoneUsers, xlab = "CellUsers", main = "Histogram")


## Summary
summary(Merged$emigration2, na.rm = TRUE)
summary(Merged$CellphoneUsers, na.rm = TRUE)
summary(Merged$InternetUsers, na.rm = TRUE)
summary(Merged$GDPPerCapita, na.rm = TRUE)
summary(Merged$TotalPopulation, na.rm = TRUE)
summary(Merged$FertilityRate, na.rm = TRUE)
summary(Merged$GovernmentEffectivness, na.rm = TRUE)
summary(Merged$RegulatoryStability, na.rm = TRUE)
summary(Merged$RegulatoryQuality, na.rm = TRUE)
summary(Merged$RuleOfLaw, na.rm = TRUE)
summary(Merged$VoiceAndAccountability, na.rm = TRUE)

#Range
range(Merged$emigration)

#Interquantile Range
IQR(Merged$emigration)

# Boxplots
boxplot(Merged$emigration2, main = 'Emigration')
boxplot(Merged$CellphoneUsers, main = 'Cellphone Users')

#Variance
var(Merged$emigration2)
var(Merged$CellphoneUsers)
var(Merged$InternetUsers)

#Standar Deviation
sd(Merged$emigration2)
sd(Merged$CellphoneUsers)
sd(Merged$InternetUsers)

#Standar Error function
sd_error <- function(x) {
  sd(x)/sqrt(length(x))
}

sd_error(Merged$)

# Joint Distribution
plot(emigration ~ InternetUsers, data = merged13, 
     xlab = "E", las = 1,
     ylab = "C",
     main = "Emigration data and fitted curve")

plot(emigrationpercap ~ GDPPerCapita, data = merged13, 
     xlab = "E", las = 1,
     ylab = "C",
     main = "Emigration data and fitted curve")

plot(emigrationpercap ~ GDPPerCapita, data = merged13, 
     xlab = "E", las = 1,
     ylab = "C",
     main = "Emigration data and fitted curve")

plot(emigration ~ year, data = Merged, 
     xlab = "E", las = 1,
     ylab = "C",
     main = "Emigration data and fitted curve")


# Correlation
cor.test(Merged$emigrationpercap, Merged$InternetUsers)
cor.test(Merged$emigration, Merged$InternetUsers)

cor.test(Merged$emigrationpercap, Merged$CellphoneUsers)
cor.test(Merged$InternetUsers, Merged$CellphoneUsers, na.rm = TRUE)


cor.test(merged90$emigrationpercap, merged90$InternetUsers)
cor.test(merged10$emigrationpercap, merged10$InternetUsers)
cor.test(merged13$emigrationpercap, merged13$InternetUsers)

####################################################################################
#################################### PANEL MODEL ###################################
####################################################################################

M1 <- glm(emigration ~ CellphoneUsers + TotalPopulation + GDPPerCapita + year + RegulatoryQuality + RuleOfLaw + FertilityRate, data = Merged, family = 'poisson')
summary(M1)

M2 <- glm(emigration ~ InternetUsers + TotalPopulation, data = Merged, family = 'poisson')
summary(M2)

####################################################################################

