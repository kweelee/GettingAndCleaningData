#Coursera Getting and Cleaning Data Project
The purpose of this project is get the raw data, processed it and make it as tidy data

The Human Activity Recognition Using Smartphones information and data set can be found and downloaded at
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The R script run_analysis.R does the following. 
Step 1: Merges the training and the test sets to create one data set.
Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
Step 3: Uses descriptive activity names to name the activities in the data set
Step 4: Appropriately labels the data set with descriptive variable names. 
Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
for each activity and each subject.
Before Step 1, we need to first check if the dataset folder exist. Assume if dataset folder exist, all files exist. 
Should the assumption not to be made, additional check must peformed on each individual file before proceed. 
The function file.exists can be used. For example, if internet connection is available and the Samsung data has not 
been downloaded, the following code can be run. For reproducible purpose, the date the data file downloaded is 
recorded
--------------------------------------------------------------------------------------------------------
if (!file.exists("UCI HAR Dataset")) {
  fileUrl <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl,destfile = "./dataset.zip")
  dateDownloaded <-date()
  dateDownLoaded
  unzip("./dataset.zip")
}
--------------------------------------------------------------------------------------------------------
if internet connection is unavalble, the code
------------------------------------
## "stop ("data directory not found")" 
------------------------------------
will halt the script and exit.

There are 2948 rows(or observation on) X_test.txt,y_test.txt, and subjext_test.txt, and 561 variables. Combining the
subject and activity, we have a testdata of 2948 row and 563 columns.

We will performed the same procedure for the train data set and finaly merge the two data set to one big single
data set. This merge is actually a concatenation since we will not check for data duplication, ie we will assume
all observation are distinct(unique).

This project required to labels the data set with descriptive variable names.
features.txt contain the descriptive variable names. Lets just use it.

We will use "Subject" as column name for Subject. Subject is a numeric columns,with value range from 1 to 30, represent
the 30 individuals. We will use "Activity" as column name for the activity peformed by the individuals. Each person 
performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
wearing a smartphone (Samsung Galaxy S II) on the waist. The activity recorded(y_test.txt or y_train.txt) contain the
factor value(1 to 6) of the activity. To make it descriptive, we need to change the type of the columns to character.

To use descriptive activity names to name the activities in the data set, we will refer to the activity_labels.txt
Columns 1 is the factor, column 2 is the descriptive avtivity name
ActivityLabels <-read.csv("./UCI HAR Dataset/activity_labels.txt",sep = "",header=FALSE)
The activity is on factor(1 to 6), coerce it to character
allData$Activity <- as.character(allData$Activity)

Change all the factor value(1 to 6) according to the activity_labels activity name
for (i in ActivityLabels$V1)
  allData$Activity[allData$Activity == i] <- as.character(ActivityLabels[[2]][i])

We are only interest on the mean and standard deviation for each measurement. We can use grepl to search for
the "mean" and "std" for the required values. We will also need the subject and activity associated with the values.

extractedData <- allData[,grepl("Subject|Activity|mean|std",names(allData))]
numberOfColumns <-ncol(extractedData)
For a second independent tidy data set with the average of each variable for each activity and each subject, we can
use the aggregate function, and group it by subject and activity.

p <-aggregate(extractedData[,3:numberOfColumns],by=list(Subject = extractedData$Subject, Activity = extractedData$Activity),mean)
Finally, we export the tidydata to tidydata.txt

write.table(p, file = "tidydata.txt", sep = " ", row.name=FALSE, qmethod = "double")
