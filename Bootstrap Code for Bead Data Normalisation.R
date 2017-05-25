
############
############
############
############
############
############


######                                                        
#     #  ####   ####  #####  ####  ##### #####    ##   #####  
#     # #    # #    #   #   #        #   #    #  #  #  #    # 
######  #    # #    #   #    ####    #   #    # #    # #    # 
#     # #    # #    #   #        #   #   #####  ###### #####  
#     # #    # #    #   #   #    #   #   #   #  #    # #      
######   ####   ####    #    ####    #   #    # #    # #      

#     #                                                       
##    #  ####     #####  #    #  ####  #####  #    #          
# #   # #    #    #    # ##   # #    # #    # ##  ##          
#  #  # #    #    #    # # #  # #    # #    # # ## #          
#   # # #    #    #####  #  # # #    # #####  #    #          
#    ## #    #    #   #  #   ## #    # #   #  #    #          
#     #  ####     #    # #    #  ####  #    # #    #          

set.seed(123)

library(readxl)

#Setup: the Excel file should have data in the first two sheets:
#Sheet in the first position is the NTC and SC1 data, 12 columns

 #####                                  #   
#     # #    # ###### ###### #####     ##   
#       #    # #      #        #      # #   
 #####  ###### #####  #####    #        #   
      # #    # #      #        #        #   
#     # #    # #      #        #        #   
 #####  #    # ###### ######   #      ##### 

 #####                                                  
#     #  ####  #    # ##### #####   ####  #       ####  
#       #    # ##   #   #   #    # #    # #      #      
#       #    # # #  #   #   #    # #    # #       ####  
#       #    # #  # #   #   #####  #    # #           # 
#     # #    # #   ##   #   #   #  #    # #      #    # 
 #####   ####  #    #   #   #    #  ####  ######  ####  


#Sheet 1 Columns A C E: 
#NTC rep 1, NTC rep 2, NTC rep 3, all with the same Tube (e.g., TM37)
#Sheet 1 Columns B D F: 
#NTC rep 1, NTC rep 2, NTC rep 3, all with the same Tube but different than A C E columns (e.g., TM48)
#NTC rep names appears on Row 1
#Tube name appears on Row 2
#Data starts on ROW 3 - missing values are fine.

#Sheet 1 Columns G I K: 
#SC1 rep 1, SC1 rep 2, SC1 rep 3, all with the same Tube (e.g., TM37)
#Sheet 1 Columns H J L: 
#SC1 rep 1, SC1 rep 2, SC1 rep 3, all with the same Tube but different than A C E columns (e.g., TM48)
#SC1 rep names appears on Row 1
#Tube name appears on Row 2
#Data starts on ROW 3 - missing values are fine.


 #####                                 #####  
#     # #    # ###### ###### #####    #     # 
#       #    # #      #        #            # 
 #####  ###### #####  #####    #       #####  
      # #    # #      #        #      #       
#     # #    # #      #        #      #       
 #####  #    # ###### ######   #      ####### 

######                                             
#     #   ##    ####  ##### ###### #####  #   ##   
#     #  #  #  #    #   #   #      #    # #  #  #  
######  #    # #        #   #####  #    # # #    # 
#     # ###### #        #   #      #####  # ###### 
#     # #    # #    #   #   #      #   #  # #    # 
######  #    #  ####    #   ###### #    # # #    # 

#Sheet in the second position is the bacteria for testing, 6 columns
#it is exactly ONE bacteria, 3 reps, 2 tubes


#Sheet 2 Columns A C E: 
#Bacteria rep 1, Bacteria rep 2, Bacteria rep 3, all with the same Tube (e.g., TM37)
#Sheet 2 Columns B D F: 
#Bacteria rep 1, Bacteria rep 2, Bacteria rep 3, all with the same Tube but different than A C E columns (e.g., TM48)
#Bacteria concentration or levels or whatever appears on Row 1
#Tube name appears on Row 2
#Data starts on ROW 3 - missing values are fine.


#this is the path to your data set.
#setwd("L:/Lab_Stats_Unit/2015_and_Onwards/QIMR/Immunology/Geoff_Hill_BMT/Kate Markey scaling flow beads")
setwd("C:/Users/liangF/Desktop/Sepsis/Megan")

#this is the list of means and SDs from Megan's beads
#feel free to rename this file but don't mess around with the file's formatting; you need to include the extension by the way.

filename.for.this.run<-'RCode Run Sheet.xlsx'

bootfromthis.control.data <- read_excel(filename.for.this.run,
                                        col_names = F, sheet=1, skip=2)
bootfromthis.experiment.data <- read_excel(filename.for.this.run,
                                           col_names = F, sheet=2, skip=2)

#this picks off the second rows of the two sheets, which ideally should be TUBE descriptions
#we may use these later 
bootfromthis.controls.tubes <- read_excel(filename.for.this.run,
                                           col_names = F, sheet=1, skip=1)[1,]
bootfromthis.experiment.tubes <- read_excel(filename.for.this.run,
                                             col_names = F, sheet=2, skip=1)[1,]

#this picks off the first rows of the two sheets, which ideally should be REP and Experiment descriptions
#we may use these later too
bootfromthis.controls.reps <- read_excel(filename.for.this.run,
                                         col_names = F, sheet=1, skip=0)[1,]
bootfromthis.experiment.reps <- read_excel(filename.for.this.run,
                                           col_names = F, sheet=2, skip=0)[1,]


#assemble names for these things
names.for.controls<-paste(bootfromthis.controls.reps,bootfromthis.controls.tubes,sep="_")
names.for.experiment<-paste(bootfromthis.experiment.reps,bootfromthis.experiment.tubes,sep="_")

#rename the data frames for convenience
names(bootfromthis.control.data)<-names.for.controls
names(bootfromthis.experiment.data)<-names.for.experiment


#Feel free to rename these columns to whatever your little heart desires
#you can add statistics for reporting too but they have to appear in the matrix near the bottom
names.for.results.matrix<-c("Ratiovec.of.Bacteria.Tube.1", "Ratiovec.of.Bacteria.Tube.2",
                            "Meanvec.of.NTC.Tube1", "Meanvec.of.NTC.Tube2",
                            "Meanvec.of.SC1.Tube1", "Meanvec.of.SC1.Tube2",
                            "Meanvec.of.Bacteria.Tube1", "Meanvec.of.Bacteria.Tube2")

#this sets the bootstrap reps. 10K should be fine.
bootstrap.samplesize<-10000

#container for results. do not touch this.
#fill data frame with 0s
matrix.of.results<-data.frame(matrix(0, ncol=length(names.for.results.matrix), nrow=bootstrap.samplesize))
names(matrix.of.results)<-names.for.results.matrix

#don't touch this either unless you know what you're doing
#this picks off the first vector of observations from the NTC (Col A) but drops all missing
#what you should get is a vector of non-missing obs that form the basis for this rep's bootstrap sample
#!is.na is how to remove missing; [,1] stuff is column 1 for that data frame or matrix
#note that this is 1 3 5, corresponding to A C E columns

# NTC.Tube.1.Rep1.sample.from.this<- unclass(bootfromthis.control.data[!is.na(bootfromthis.control.data[,1]),1])
NTC.Tube.1.Rep1.sample.from.this<- as.vector(unlist(unclass(bootfromthis.control.data[!is.na(bootfromthis.control.data[,1]),1])[1]))

NTC.Tube.1.Rep2.sample.from.this<- as.vector(unlist(unclass(bootfromthis.control.data[!is.na(bootfromthis.control.data[,3]),3])[1]))
NTC.Tube.1.Rep3.sample.from.this<- as.vector(unlist(unclass(bootfromthis.control.data[!is.na(bootfromthis.control.data[,5]),5])[1])) 
  
N.of.NTC.Tube.1<-c(length(NTC.Tube.1.Rep1.sample.from.this),
            length(NTC.Tube.1.Rep2.sample.from.this),
            length(NTC.Tube.1.Rep3.sample.from.this))

#same thing but note that this is 2 4 6, corresponding to B D F columns
NTC.Tube.2.Rep1.sample.from.this<- as.vector(unlist(unclass(bootfromthis.control.data[!is.na(bootfromthis.control.data[,2]),2])[1]))
NTC.Tube.2.Rep2.sample.from.this<- as.vector(unlist(unclass(bootfromthis.control.data[!is.na(bootfromthis.control.data[,4]),4])[1]))
NTC.Tube.2.Rep3.sample.from.this<- as.vector(unlist(unclass(bootfromthis.control.data[!is.na(bootfromthis.control.data[,6]),6])[1])) 
N.of.NTC.Tube.2<-c(length(NTC.Tube.2.Rep1.sample.from.this),
                   length(NTC.Tube.2.Rep2.sample.from.this),
                   length(NTC.Tube.2.Rep3.sample.from.this))

#repeat for SC1 except change column numbers (add 6 to each NTC column number)
SC1.Tube.1.Rep1.sample.from.this<- as.vector(unlist(unclass(bootfromthis.control.data[!is.na(bootfromthis.control.data[,7]),7])[1]))
SC1.Tube.1.Rep2.sample.from.this<- as.vector(unlist(unclass(bootfromthis.control.data[!is.na(bootfromthis.control.data[,9]),9])[1]))
SC1.Tube.1.Rep3.sample.from.this<- as.vector(unlist(unclass(bootfromthis.control.data[!is.na(bootfromthis.control.data[,11]),11])[1])) 
N.of.SC1.Tube.1<-c(length(SC1.Tube.1.Rep1.sample.from.this),
                   length(SC1.Tube.1.Rep2.sample.from.this),
                   length(SC1.Tube.1.Rep3.sample.from.this))

#same thing but note that this is 6+2 6+4 6+6, corresponding to B D F columns
SC1.Tube.2.Rep1.sample.from.this<- as.vector(unlist(unclass(bootfromthis.control.data[!is.na(bootfromthis.control.data[,8]),8])[1]))
SC1.Tube.2.Rep2.sample.from.this<- as.vector(unlist(unclass(bootfromthis.control.data[!is.na(bootfromthis.control.data[,10]),10])[1]))
SC1.Tube.2.Rep3.sample.from.this<- as.vector(unlist(unclass(bootfromthis.control.data[!is.na(bootfromthis.control.data[,12]),12])[1])) 
N.of.SC1.Tube.2<-c(length(SC1.Tube.2.Rep1.sample.from.this),
                   length(SC1.Tube.2.Rep2.sample.from.this),
                   length(SC1.Tube.2.Rep3.sample.from.this))


#this picks off the observations from the bacteria
#I'm going to call this Bac for shorthand instead of "K.Pneumo" or whatever
#format is the same as NTC stuff with respect to column numbers because it is on the second sheet
Bac.Tube.1.Rep1.sample.from.this<- as.vector(unlist(unclass(bootfromthis.experiment.data[!is.na(bootfromthis.experiment.data[,1]),1])[1]))
Bac.Tube.1.Rep2.sample.from.this<- as.vector(unlist(unclass(bootfromthis.experiment.data[!is.na(bootfromthis.experiment.data[,3]),3])[1]))
Bac.Tube.1.Rep3.sample.from.this<- as.vector(unlist(unclass(bootfromthis.experiment.data[!is.na(bootfromthis.experiment.data[,5]),5] )[1]))
N.of.Bac.Tube.1<-c(length(Bac.Tube.1.Rep1.sample.from.this),
                   length(Bac.Tube.1.Rep2.sample.from.this),
                   length(Bac.Tube.1.Rep3.sample.from.this))

#same thing but note that this is 2 4 6, corresponding to B D F columns
Bac.Tube.2.Rep1.sample.from.this<- as.vector(unlist(unclass(bootfromthis.experiment.data[!is.na(bootfromthis.experiment.data[,2]),2])[1]))
Bac.Tube.2.Rep2.sample.from.this<- as.vector(unlist(unclass(bootfromthis.experiment.data[!is.na(bootfromthis.experiment.data[,4]),4])[1]))
Bac.Tube.2.Rep3.sample.from.this<- as.vector(unlist(unclass(bootfromthis.experiment.data[!is.na(bootfromthis.experiment.data[,6]),6])[1])) 
N.of.Bac.Tube.2<-c(length(Bac.Tube.2.Rep1.sample.from.this),
                   length(Bac.Tube.2.Rep2.sample.from.this),
                   length(Bac.Tube.2.Rep3.sample.from.this))

#arguments here are the vectors of the stratified bootstrap samples
make.ratios<-function(NTC.boot.vector, SC1.boot.vector, Bac.boot.vector){


  #-----------------------------------------------------
  NTC.boot.vector <- as.vector(unlist(NTC.boot.vector))
  SC1.boot.vector <- as.vector(unlist(SC1.boot.vector))
  Bac.boot.vector <- as.vector(unlist(Bac.boot.vector))
  #-----------------------------------------------------


  #calc tube-wise means for the two controls bead sets, pooling data across rep
  NTC_mean_for_this_Tube<-mean(NTC.boot.vector,na.rm=TRUE)
  SC1_mean_for_this_Tube<-mean(SC1.boot.vector,na.rm=TRUE)
  #calc tube-wise mean for the bacterium, pooling data across rep
  Bac_mean_for_this_Tube<-mean(Bac.boot.vector,na.rm=TRUE)
  
  #calc max minus min; this is our denominator for the ratio
  max.minus.min<-SC1_mean_for_this_Tube-NTC_mean_for_this_Tube

  #estimate bootstrap ratio for this specific tube
  ratiovec_Bac_for_this_Tube<-(Bac_mean_for_this_Tube-NTC_mean_for_this_Tube)/max.minus.min
  
  #export results: RATIO then the means
  c(ratiovec_Bac_for_this_Tube, NTC_mean_for_this_Tube, SC1_mean_for_this_Tube, Bac_mean_for_this_Tube)
}

#this starts the bootstrap loop, 1 to the number of bootstraps you want to do
for (j in 1:bootstrap.samplesize)
{
  
  #browser()
  #this simulates all of the bead experiments for a single iteration of the bootstrap
  #sample from raw data with appropriate length per rep and per tube
  #this takes out the normal assumption using rnorm
  
  #this samples with replacement from each of the columns with the same number of obs as the 
  #number of obs that appear in the Excel file per rep and per tube.
  NTC.sampling.Tube1<- c(sample(NTC.Tube.1.Rep1.sample.from.this, size=N.of.NTC.Tube.1[1], replace = TRUE),
                     sample(NTC.Tube.1.Rep2.sample.from.this, size=N.of.NTC.Tube.1[2], replace = TRUE),
                     sample(NTC.Tube.1.Rep3.sample.from.this, size=N.of.NTC.Tube.1[3], replace = TRUE))
                     
  NTC.sampling.Tube2<- c(sample(NTC.Tube.2.Rep1.sample.from.this, size=N.of.NTC.Tube.2[1], replace = TRUE),
                     sample(NTC.Tube.2.Rep2.sample.from.this, size=N.of.NTC.Tube.2[2], replace = TRUE),
                     sample(NTC.Tube.2.Rep3.sample.from.this, size=N.of.NTC.Tube.2[3], replace = TRUE))
  

  SC1.sampling.Tube1<- c(sample(SC1.Tube.1.Rep1.sample.from.this, size=N.of.SC1.Tube.1[1], replace = TRUE),
                   sample(SC1.Tube.1.Rep2.sample.from.this, size=N.of.SC1.Tube.1[2], replace = TRUE),
                   sample(SC1.Tube.1.Rep3.sample.from.this, size=N.of.SC1.Tube.1[3], replace = TRUE))
                   
  SC1.sampling.Tube2<- c(sample(SC1.Tube.2.Rep1.sample.from.this, size=N.of.SC1.Tube.2[1], replace = TRUE),
                   sample(SC1.Tube.2.Rep2.sample.from.this, size=N.of.SC1.Tube.2[2], replace = TRUE),
                   sample(SC1.Tube.2.Rep3.sample.from.this, size=N.of.SC1.Tube.2[3], replace = TRUE))
  

  Bac.sampling.Tube1<- c(sample(Bac.Tube.1.Rep1.sample.from.this, size=N.of.Bac.Tube.1[1], replace = TRUE),
                   sample(Bac.Tube.1.Rep2.sample.from.this, size=N.of.Bac.Tube.1[2], replace = TRUE),
                   sample(Bac.Tube.1.Rep3.sample.from.this, size=N.of.Bac.Tube.1[3], replace = TRUE))
                   
  Bac.sampling.Tube2<- c(sample(Bac.Tube.2.Rep1.sample.from.this, size=N.of.Bac.Tube.2[1], replace = TRUE),
                   sample(Bac.Tube.2.Rep2.sample.from.this, size=N.of.Bac.Tube.2[2], replace = TRUE),
                   sample(Bac.Tube.2.Rep3.sample.from.this, size=N.of.Bac.Tube.2[3], replace = TRUE))
  

  #apply the make.ratios function directly above this for loop
  #need one of these per tube
  Tube.1.ratios.and.means<-make.ratios(NTC.sampling.Tube1, SC1.sampling.Tube1, Bac.sampling.Tube1)
  Tube.2.ratios.and.means<-make.ratios(NTC.sampling.Tube2, SC1.sampling.Tube2, Bac.sampling.Tube2)
  
  #build the results object  this is a column of length bootstrap.samplesize, one for each bootstrap
  #order is TUBE 1,2 (alternating): RATIO then MEAN NTC then MEAN SC1 then MEAN BAC
  matrix.of.results[j,]<-c(Tube.1.ratios.and.means[1], Tube.2.ratios.and.means[1],
                           Tube.1.ratios.and.means[2], Tube.2.ratios.and.means[2],
                           Tube.1.ratios.and.means[3], Tube.2.ratios.and.means[3],
                           Tube.1.ratios.and.means[4], Tube.2.ratios.and.means[4])
  
  #end outer loop to perform bootstrap
}




#quickly calc means and sd's (across bootstrap.samplesize obs)
means.column<-apply(matrix.of.results,2,mean)
#reasoning here is that the SD of the means is the SE, including the SD/SE of the pooled mean
se.column<-apply(matrix.of.results,2,sd)

#this summarizes the statistics of the RATIOS for the bacteria between the controls.
report.for.this.run.bac <- data.frame(TM37  =matrix(c(means.column[1],
                                                               se.column[1],
                                                      quantile(matrix.of.results[,1],probs=0.025),
                                                      quantile(matrix.of.results[,1],probs=0.975))),
                                      TM48  =matrix(c(means.column[2],
                                                               se.column[2],
                                                      quantile(matrix.of.results[,2],probs=0.025),
                                                      quantile(matrix.of.results[,2],probs=0.975))))
row.names(report.for.this.run.bac)<-c("Mean of Ratio", "SE of Ratio", 
                                  "Lower 95% Quantile", "Upper 95% Quantile")
                                  

#optional - put this into the console if you want all of the statistics for a given run
other.stats.for.this.run<-data.frame(Bead.Statistics=c("Mean Tube 1 NTC", "SE of Tube 1 NTC",
                                                       "Mean Tube 2 NTC", "SD of Tube 2 NTC",
                                                       "Mean Tube 1 SC1", "SE of Tube 1 SC1",
                                                       "Mean Tube 2 SC1", "SE of Tube 2 SC1",
                                                       "Mean Tube 1 Bac", "SE of Tube 1 Bac",
                                                       "Mean Tube 2 Bac", "SE of Tube 2 Bac"),
                                           Statistics=c(means.column[3],se.column[3],
                                                        means.column[4],se.column[4],
                                                        
                                                        means.column[5],se.column[5],
                                                        means.column[6],se.column[6],

                                                        means.column[7],se.column[7],
                                                        means.column[8],se.column[8]
                                           ))


#put the ratio stuff to the console
report.for.this.run.bac

#example output
#> report.for.this.run.bac
#Ratio.Statistics           TM37              TM48
#Mean of Ratio           0.221067752        0.221067752  
#SE of Ratio             0.005447144        0.005447144
#Lower 95% Quantile      0.210342764        0.210342764
#Upper 95% Quantile      0.231784621        0.231784621


#uncomment if you want means and SEs per Tube
#other.stats.for.this.run