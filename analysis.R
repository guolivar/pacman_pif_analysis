#   This script takes the cleaned PACMAN output for
#   the four units deployed at a PIF researcher's home,
#   as generated by pre_process.m and calculates the
#   time series used for analysis.
#   It also generates relevant plots
#
# 	This function is in the public domain. Gustavo Olivares.

library('openair')
library('ggplot2')
library('zoom')
data_path="~/data/PACMAN/PIF/House_1_Amor/"
## Load and prepare data
## Lounge ####
pacman.lounge <- read.delim(paste0(data_path,"201307_Lounge.txt"))
pacman.lounge$date<-ISOdatetime(year=pacman.lounge$Year,
                              month=pacman.lounge$Month,
                              day=pacman.lounge$Day,
                              hour=pacman.lounge$Hour,
                              min=pacman.lounge$Minute,
                              sec=pacman.lounge$Second,
                              tz="NZST")
## Clean CO time series
pacman.lounge$CO_mV[pacman.lounge$COvalid==0]=NaN
## Simple interpolation to match the other data and remove gaps
pacman.lounge$CO_mV=na.approx(pacman.lounge$CO_mV,na.rm = FALSE)
## Invert CO2 data and add a baseline to make the data positive
pacman.lounge$CO2_mV=3000-pacman.lounge$CO2_mV
## Remove irrelevant data fields
pacman.lounge$Date_octave<-NULL
pacman.lounge$Count<-NULL
pacman.lounge$Year<-NULL
pacman.lounge$Month<-NULL
pacman.lounge$Day<-NULL
pacman.lounge$Hour<-NULL
pacman.lounge$Minute<-NULL
pacman.lounge$Second<-NULL
pacman.lounge$COstatus<-NULL
pacman.lounge$COvalid<-NULL
## Rename fields to prepare for merging data
names(pacman.lounge)=c('D_lounge',
                       'T_ext_lounge',
                       'T_int_lounge',
                       'Dust_lounge',
                       'CO2_lounge',
                       'CO_lounge',
                       'Mov_lounge',
                       'date')
## Calculate 1 minute averages for the time series
pacman.lounge.1min=timeAverage(selectByDate(pacman.lounge,
                                            start='2013-07-10',
                                            end='2013-07-17'),
                               avg.time = "1 min",
                               statistic = "mean")
## Heater ####
pacman.heater <- read.delim(paste0(data_path,"201307_Heater.txt"))
pacman.heater$date<-ISOdatetime(year=pacman.heater$Year,
                                month=pacman.heater$Month,
                                day=pacman.heater$Day,
                                hour=pacman.heater$Hour,
                                min=pacman.heater$Minute,
                                sec=pacman.heater$Second,
                                tz="NZST")
## Clean CO time series
pacman.heater$CO_mV[pacman.heater$COvalid==0]=NaN
## Simple interpolation to match the other data and remove gaps
pacman.heater$CO_mV=na.approx(pacman.heater$CO_mV,na.rm = FALSE)
## Invert CO2 data and add a baseline to make the data positive
pacman.heater$CO2_mV=3000-pacman.heater$CO2_mV
## Remove irrelevant data fields
pacman.heater$Date_octave<-NULL
pacman.heater$Count<-NULL
pacman.heater$Year<-NULL
pacman.heater$Month<-NULL
pacman.heater$Day<-NULL
pacman.heater$Hour<-NULL
pacman.heater$Minute<-NULL
pacman.heater$Second<-NULL
pacman.heater$COstatus<-NULL
pacman.heater$COvalid<-NULL
## Rename fields to prepare for merging data
names(pacman.heater)=c('D_heater',
                       'T_ext_heater',
                       'T_int_heater',
                       'Dust_heater',
                       'CO2_heater',
                       'CO_heater',
                       'Mov_heater',
                       'date')
## Calculate 1 minute averages for the time series
pacman.heater.1min=timeAverage(selectByDate(pacman.heater,
                                            start='2013-07-10',
                                            end='2013-07-17'),
                               avg.time = "1 min",
                               statistic = "mean")
## Kitchen ####
pacman.kitchen <- read.delim(paste0(data_path,"201307_Kitchen.txt"))
pacman.kitchen$date<-ISOdatetime(year=pacman.kitchen$Year,
                                month=pacman.kitchen$Month,
                                day=pacman.kitchen$Day,
                                hour=pacman.kitchen$Hour,
                                min=pacman.kitchen$Minute,
                                sec=pacman.kitchen$Second,
                                tz="NZST")
## Clean CO time series
pacman.kitchen$CO_mV[pacman.kitchen$COvalid==0]=NaN
## Simple interpolation to match the other data and remove gaps
pacman.kitchen$CO_mV=na.approx(pacman.kitchen$CO_mV,na.rm = FALSE)
## Invert CO2 data and add a baseline to make the data positive
pacman.kitchen$CO2_mV=3000-pacman.kitchen$CO2_mV
## Remove irrelevant data fields
pacman.kitchen$Date_octave<-NULL
pacman.kitchen$Count<-NULL
pacman.kitchen$Year<-NULL
pacman.kitchen$Month<-NULL
pacman.kitchen$Day<-NULL
pacman.kitchen$Hour<-NULL
pacman.kitchen$Minute<-NULL
pacman.kitchen$Second<-NULL
pacman.kitchen$COstatus<-NULL
pacman.kitchen$COvalid<-NULL
## Rename fields to prepare for merging data
names(pacman.kitchen)=c('D_kitchen',
                       'T_ext_kitchen',
                       'T_int_kitchen',
                       'Dust_kitchen',
                       'CO2_kitchen',
                       'CO_kitchen',
                       'Mov_kitchen',
                       'date')
## Calculate 1 minute averages for the time series
pacman.kitchen.1min=timeAverage(selectByDate(pacman.kitchen,
                                             start='2013-07-10',
                                             end='2013-07-17'),
                                avg.time = "1 min",
                                statistic = "mean")
## Bedroom ####
pacman.bedroom <- read.delim(paste0(data_path,"201307_Bedroom.txt"))
pacman.bedroom$date<-ISOdatetime(year=pacman.bedroom$Year,
                                 month=pacman.bedroom$Month,
                                 day=pacman.bedroom$Day,
                                 hour=pacman.bedroom$Hour,
                                 min=pacman.bedroom$Minute,
                                 sec=pacman.bedroom$Second,
                                 tz="NZST")
## Clean CO time series
pacman.bedroom$CO_mV[pacman.bedroom$COvalid==0]=NaN
## Simple interpolation to match the other data and remove gaps
pacman.bedroom$CO_mV=na.approx(pacman.bedroom$CO_mV,na.rm = FALSE)
## Invert CO2 data and add a baseline to make the data positive
pacman.bedroom$CO2_mV=3000-pacman.bedroom$CO2_mV
## Remove irrelevant data fields
pacman.bedroom$Date_octave<-NULL
pacman.bedroom$Count<-NULL
pacman.bedroom$Year<-NULL
pacman.bedroom$Month<-NULL
pacman.bedroom$Day<-NULL
pacman.bedroom$Hour<-NULL
pacman.bedroom$Minute<-NULL
pacman.bedroom$Second<-NULL
pacman.bedroom$COstatus<-NULL
pacman.bedroom$COvalid<-NULL
## Rename fields to prepare for merging data
names(pacman.bedroom)=c('D_bedroom',
                        'T_ext_bedroom',
                        'T_int_bedroom',
                        'Dust_bedroom',
                        'CO2_bedroom',
                        'CO_bedroom',
                        'Mov_bedroom',
                        'date')
## Calculate 1 minute averages for the time series
pacman.bedroom.1min=timeAverage(selectByDate(pacman.bedroom,
                                             start='2013-07-10',
                                             end='2013-07-17'),
                                avg.time = "1 min",
                                statistic = "mean")
## Merge the datasets by date ####
pre_pacman1=merge(pacman.lounge.1min,pacman.heater.1min,by = 'date')
pre_pacman2=merge(pre_pacman1,pacman.kitchen.1min,by='date')
pacman.data=merge(pre_pacman2,pacman.bedroom.1min,by='date')
## Time correction -- Kitchen unit has the master clock ####
## Lounge
lag_test=ccf(pacman.data$T_int_kitchen,
             pacman.data$T_int_lounge,
             type = 'correlation',
             lag.max = 500,
             na.action = na.pass,
             plot=FALSE)
lounge_lag=lag_test$lag[which.max(lag_test$acf)]
pacman.lounge.1min$date=pacman.lounge.1min$date+lounge_lag*60
## Heater
lag_test=ccf(pacman.data$T_int_kitchen,
             pacman.data$T_int_heater,
             type = 'correlation',
             lag.max = 500,
             na.action = na.pass,
             plot=FALSE)
heater_lag=lag_test$lag[which.max(lag_test$acf)]
pacman.heater.1min$date=pacman.heater.1min$date+heater_lag*60
## Bedroom
lag_test=ccf(pacman.data$T_int_kitchen,
             pacman.data$T_int_bedroom,
             type = 'correlation',
             lag.max = 500,
             na.action = na.pass,
             plot=FALSE)
bedroom_lag=lag_test$lag[which.max(lag_test$acf)]
pacman.bedroom.1min$date=pacman.bedroom.1min$date+bedroom_lag*60

## Re-merge the data now synchronised
pre_pacman1=merge(pacman.lounge.1min,pacman.heater.1min,by = 'date')
pre_pacman2=merge(pre_pacman1,pacman.kitchen.1min,by='date')
pacman.data=merge(pre_pacman2,pacman.bedroom.1min,by='date')
## Temperature correction for the dust signal ####
## First obtain linear fit of dust vs. temperature for the units
## Kitchen
T_fit.kitchen=lm(data = pacman.data,Dust_kitchen~T_int_kitchen)
## Lounge
T_fit.lounge=lm(data = pacman.data,Dust_lounge~T_int_lounge)
## Heater
T_fit.heater=lm(data = pacman.data,Dust_heater~T_int_heater)
## Bedroom
T_fit.bedroom=lm(data = pacman.data,Dust_bedroom~T_int_bedroom)
## Then remove the temperature component from the dust signal
pacman.data$Dust_kitchen.corrected=pacman.data$Dust_kitchen -
  (T_fit.kitchen$coefficients[1]+
     T_fit.kitchen$coefficients[2]*pacman.data$T_int_kitchen)

pacman.data$Dust_lounge.corrected=pacman.data$Dust_lounge -
  (T_fit.lounge$coefficients[1]+
     T_fit.lounge$coefficients[2]*pacman.data$T_int_lounge)

pacman.data$Dust_heater.corrected=pacman.data$Dust_heater -
  (T_fit.heater$coefficients[1]+
     T_fit.heater$coefficients[2]*pacman.data$T_int_heater)

pacman.data$Dust_bedroom.corrected=pacman.data$Dust_bedroom -
  (T_fit.bedroom$coefficients[1]+
     T_fit.bedroom$coefficients[2]*pacman.data$T_int_bedroom)

## Start plotting ####
## Plot the time series of adjusted Dust data ####
timePlot(pacman.data,
         pollutant = c('Dust_kitchen.corrected',
                       'Dust_lounge.corrected',
                       'Dust_heater.corrected'),
         ylab='Temperature adjusted dust signal [mV]',
         name.pol = c('Kitchen','Lounge','Heater'))
## Plot the data for the 16th of July ####
data_16_july=selectByDate(pacman.data,
                          start='2013-07-16',
                          end='2013-07-16')
timePlot(data_16_july,
         pollutant = c('CO_kitchen','Dust_kitchen.corrected'),
         main = 'Kitchen\n2013-07-16',
         ylab='Raw sensor readings [mV]',
         name.pol = c('CO','Dust'),
         group = TRUE)

## Plot the data for the 12th of July ####
data_12_july=selectByDate(pacman.data,
                          start='2013-07-12',
                          end='2013-07-12')
timePlot(data_12_july,pollutant = c('CO2_kitchen','CO2_bedroom','Mov_kitchen','Mov_bedroom'),ylab='')
