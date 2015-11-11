########################################################################################
########################## Collaborative Data Analysis Assigement 3 ####################
########################################################################################

# Clearing the workspace
rm(list = ls())


# Installing and loading packages
install.packages('WDI')
install.packages('tidyr')
install.packages('rio')
install.packages('countrycode')
install.packages("RJOSONIO")  
install.packages ("ggplot2")
install.packages("rworldmap")
install.packages("sp")
install.packages("rworldmap")

library("ggmap")
library("maptools")
library("countrycode")
library("WDI")
library("tidyr")
library("rio")
library("RJSONIO")
library("ggplot2")
library("rworldmap")
library("sp")


#2. Setting directory
#setwd('/Users/AnaCe/Desktop/Assignment3MontesReyla')
setwd('/Users/ayrarowenareyla/Desktop/The Hertie School of Governance/Collaborative Social Sciences/Assignment3MontesReyla/Assignment3MontesReyla')

####################################################################################
############################# LOADING AND CLEANING DATA ############################
####################################################################################

# 1.Loading Migration UN Data

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

# 2.Loading data from the Worldbank database
wbdata <- c ("IT.CEL.SETS.P2", "IT.NET.USER.P2", "NY.GDP.PCAP.PP.CD","SP.POP.TOTL","SI.POV.DDAY","SL.UEM.TOTL.ZS","VC.IHR.PSRC.P5"
,"CC.EST","GE.EST","PV.EST","RQ.EST","RL.EST","VA.EST","SP.DYN.TFRT.IN")

WDI_indi<- WDI(country = "all", indicator = wbdata,
                   start = 1990, end = 2013, extra = FALSE, cache = NULL)

# 3.Creating an unique identifier for both data frames
emigrationtotal$iso2c <- countrycode (emigrationtotal$Country, origin = 'country.name', 
                                      destination = 'iso2c', warn = TRUE)

WDI_indi$iso2c <- countrycode (WDI_indi$country, origin = 'country.name', 
                               destination = 'iso2c', warn = TRUE)

# 4. Merging "WDI Indicators " and "UN Migration stocks"
Merged <- merge(emigrationtotal, WDI_indi, by = c('iso2c','year'))
summary(Merged)

# 5. Renaming all the variables with simple names
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

# 6. Counting NAs in the Independent Variables

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

# Check Variables structure
str(Merged)

# Code variables as numeric
Merged$year <- as.numeric(Merged$year)
Merged$emigration <- as.numeric(Merged$emigration)

# Generating variables
Merged$emigrationpercap = Merged$emigration/Merged$TotalPopulation*1000
Merged$lnemigrationpercap =log(Merged$emigrationpercap)
Merged$emigration2 = Merged$emigration/1000



####################################################################################
############################## DESCRIPTIVE STATISTICS ##############################
####################################################################################

# Maps

data("worldMapEnv")
map("world", fill=TRUE, col="pink", bg="lightblue", ylim=c(-60, 90), mar=c(0,0,0,0))
sPDF <- joinCountryData2Map( Merged$emigration
                             ,joinCode = "iso2c"
                             ,nameJoinColumn = "iso2c")

## Historgram
hist(Merged$emigrationpercap, xlab = "Number of emigrants per 1000 people", main = "Histogram")
hist(Merged$emigration2, xlab = "Tousands of emigrants", main = "Histogram")

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
range(Loblolly$height)
range(Loblolly$age)

#Interquantile Range
IQR(Loblolly$height)
IQR(Loblolly$age)

# Boxplots
boxplot(Loblolly$height, main = 'Loblolly Tree height')
boxplot(Loblolly$age, main = 'Loblolly Tree age')

#Variance
var(Loblolly$height)
var(Loblolly$age)

#Standar Deviation
sd(Loblolly$height)
sd(Loblolly$age)

#Standar Error function
sd_error <- function(x) {
  sd(x)/sqrt(length(x))
}

sd_error(Loblolly$height)
sd_error(Loblolly$age)

# Joint Distribution
plot(emigration2 ~ CellphoneUsers, data = Merged, 
     xlab = "E", las = 1,
     ylab = "C",
     main = "Emigration data and fitted curve")
# Correlation
cor.test(Loblolly$height, Loblolly$age)

#Summarise with loess
library (ggplot2)
ggplot2::ggplot(Loblolly, aes(age, height)) + geom_point() + geom_smooth() + theme_bw()

####################################################################################
#################################### PANEL MODEL ###################################
####################################################################################


