#Coursera Getting and Cleaning Data Project
#Human Activity Recognition Using Smartphones Data Set
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#Data for the project:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#This R script does the following. 
#Step 1: Merges the training and the test sets to create one data set.
#Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
#Step 3: Uses descriptive activity names to name the activities in the data set
#Step 4: Appropriately labels the data set with descriptive variable names. 
#Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# First check if the dataset folder exist. Assume if dataset folder exist, all files exist.
# Should the assumption not to be made, additional check must peformed on each individual file before proceed.
# The following code if comment/uncomment correctly, the data can be retrieved from internet.
if (!file.exists("UCI HAR Dataset")){
    
    #comment the below to allow automatic download of data file 
    stop ("data directory not found")
    
    #uncomment the below to allow automatic download of data file
    #fileUrl <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    #download.file(fileUrl,destfile = "./dataset.zip")
    #dateDownloaded <-date()
    #dateDownLoaded
    #unzip("./dataset.zip")
}

#Refer to the dataset README.txt for details/as code book.
#This script will performed analysis on the data set
#The test data set is read to testDataX, testDataY and testDatasubject
testDataX <-read.csv("./UCI HAR Dataset/test/X_test.txt",sep = "",header = FALSE)
testDataY <-read.csv("./UCI HAR Dataset/test/Y_test.txt",sep = "",header = FALSE)
testDatasubject <-read.csv("./UCI HAR Dataset/test/subject_test.txt",sep = "",header = FALSE)

#combined the test dataset
#The columns of testData will be Subject, Activity, dataValue ...
testData <-cbind(testDatasubject,testDataY,testDataX)

#The train data set is read to trainDataX, trainDataY and trainDatasubject
trainDataX <-read.csv("./UCI HAR Dataset/train/X_train.txt",sep = "",header = FALSE)
trainDataY <-read.csv("./UCI HAR Dataset/train/Y_train.txt",sep = "",header = FALSE)
trainDatasubject <-read.csv("./UCI HAR Dataset/train/subject_train.txt",sep = "",header = FALSE)

#combined the train dataset
trainData <-cbind(trainDatasubject,trainDataY,trainDataX)

#Merges the training and the test sets to create one data set.
allData <- rbind(testData,trainData)


#Labels the data set with descriptive variable names.
#features.txt contain the descriptive variable names. Lets just use it
dataColNames <- read.csv("./UCI HAR Dataset/features.txt",sep = "",header=FALSE)
#the description name is on column 2
myColNames <- dataColNames[2]
#transpose to make it single row
myColNames <-t(myColNames)
#Since we append the subject and activity columns before all the data, we need to append the correct column names
myColNames <- c("Subject","Activity",myColNames)
colnames(allData) <-myColNames

#Uses descriptive activity names to name the activities in the data set
#activity_labels.txt contain the descriptive activitiy name
#Columns 1 is the factor, column 2 is the descriptive avtivity name
ActivityLabels <-read.csv("./UCI HAR Dataset/activity_labels.txt",sep = "",header=FALSE)
#The activity is on factor(1 to 6), coerce it to character
allData$Activity <- as.character(allData$Activity)

# Change all the factor value(1 to 6) according to the activity_labels activity name
for (i in ActivityLabels$V1)
allData$Activity[allData$Activity == i] <- as.character(ActivityLabels[[2]][i])

#Extracts only the measurements on the mean and standard deviation for each measurement
extractedData <- allData[,grepl("Subject|Activity|mean|std",names(allData))]

#independent tidy data set with the average of each variable for each activity and each subject.
p <-aggregate(extractedData[,3:81],by=list(Subject = extractedData$Subject, Activity = extractedData$Activity),mean)
#export the tidydata to tidydata.txt
write.table(p, file = "tidydata.txt", sep = " ", row.name=FALSE, qmethod = "double")
