## PROBLEMS WITH DOWNLOAD AND UNZIP FROM R

library(plyr)
library(dplyr)
library(stringr)
library(matrixStats)

## LOAD DATA SOLUTION (NOT ELEGANT BUT WORKS)
##Downloaded and unzipped file from web into computer’s file system.
##
## To run you must have a subdirectory to your working directory called data/UCI HAR Dataset
## The UCI HAR Dataset directory must have two subdirectories: train and test
## dfiles, testfiles and trainfiles below contain the necessary filenames for 
##    UCI HAR Dataset, test and train respectively
## label files
##path <- "./data/UCI HAR Dataset/"
## Put all data in working directory
path <- "./"
dfiles <- c("activity_labels.txt","features.txt")  ## files with variable labels
labelf <- paste(path,dfiles,sep="")
act_file <- read.table(labelf[1],sep=" ",header=FALSE,stringsAsFactor = FALSE)[,2]
var_labels <- read.table(labelf[2],sep=" ",header=FALSE,stringsAsFactor = FALSE)[,2]
## REMOVE PROBLEMATIC CHARACTERS IN COLUMN NAMES
var_labels <- gsub("[[:punct:]]","",var_labels)  

## test files
##testpath <- "./data/UCI HAR Dataset/test/"  ## testing data path
testpath <- "./"  ## testing data path assumed to be working directory
testf <- c("subject_test.txt", "X_test.txt", "y_test.txt")
testfiles <- paste(testpath,testf,sep="")
list_of_testd <- lapply(testfiles,read.table)

## train files
##trainpath <- "./data/UCI HAR Dataset/train/"  ## training data path\
trainpath <- "./"  ## training data path assumed to be working directory
trainf <- c("subject_train.txt", "X_train.txt", "y_train.txt")
trainfiles <- paste(trainpath,trainf,sep="")
list_of_traind <- lapply(trainfiles,read.table)

## 1. MERGE TRAIN AND TEST DATA
## use cbind on data frames containing data, subject and activity for both test and train
tdf1 <- data.frame(list_of_testd[1])  ## create data frames of subject (test)
tdf2 <- data.frame(list_of_testd[2])  ## create data frame of measurements (test)
tdf3 <- data.frame(list_of_testd[3])  ## create data frame of activities (test)
testdata <- cbind(tdf1,tdf3,tdf2)     ## test data
tdf1 <- data.frame(list_of_traind[1]) ## create data frames of subject (train)
tdf2 <- data.frame(list_of_traind[2]) ## create data frame of measurements (test)
tdf3 <- data.frame(list_of_traind[3]) ## create data frame of activities (test)
traindata <- cbind(tdf1,tdf3,tdf2)  ## train data
## use rbind to merge train and test sets
## it was overkill to get all the data but I misunderstood at first and do not want to redo
alldata <- rbind(traindata,testdata)  ## train and test merged
##
## 4. ADD LABELS TO DATA
allvar <- c("VolunteerID", "Activity", var_labels)
colnames(alldata) <- allvar   ## data frame with variables labeled

## 2. EXTRACT DATA REPRESENTING MEANS AND STANDARD DEVIATIONS
## create vector of TRUE to indices to keep (checked that mean and std only appears at start)
mnums <- grep("mean",allvar,ignore.case=TRUE)  ## selects variables with mean
snums <- grep("std",allvar,ignore.case=TRUE)   ## selects variables with std
cnums <- append(mnums,snums)
cnums <- sort(cnums)
cnums <- append(c(1,2),cnums) ## Add in subject and activity
statdata <- alldata[,cnums]  ## statdata contains mean and standard deviation measurements

## 5. CREATE SECOND DATA SET CONTAINING AVERAGE FOR EACH SUBJECT AND ACTIVITY
## Used for loop to get mean by VolunteerID and Activity
## (I failed to find a way to use group by or a more elegant process)
statsavg <- data.frame()  ## statavg built in for loop using rbind
## Use colMeans to get means (averages) - changed activity too early
for (j in 1:30) {
    for (i in 1:6) {
   	temp <- statdata[statdata$VolunteerID == j & statdata$Activity == i,]
   	tm <- colMeans(temp)
   	tmdf <- data.frame(t(tm))  ## tmdf has averages for subject j, activity i
   	statsavg <- rbind(statsavg,tmdf)  ## data for subject j, activity i added to statsavg
    }
}
## 3. CHANGE ACTIVITY FROM INTEGER TO DESCRIPTIVE TEXT (used mutuate) ## wait until after averages computed
statsavg <- mutate(statsavg,Activity=act_file[Activity])

## Change names of variables to include Av_ to denote average
avg_labels <- colnames(statsavg)
avg_labels <- c(avg_labels[1], avg_labels[2], paste("Av_",avg_labels[3:length(avg_labels)],sep=""))
colnames(statsavg) <- avg_labels

## save data frame with averages to working directory
write.table(statsavg,file="./data/DCAvg.txt", row.name = FALSE)












