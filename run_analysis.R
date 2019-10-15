#loading dplyr package
library(dplyr)


if (!file.exists("Coursera_DS3_Final.zip")){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, "Coursera_DS3_Final.zip")
}  


if (!file.exists("UCI HAR Dataset")) { 
  unzip(Coursera_DS3_Final.zip) 
}

#Setting the working directory
setwd("getdata_projectfiles_UCI HAR Dataset")

#Reading all data frames of interest
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")


#Merging the training and the test sets to create one data set
subject_values <- rbind(subject_train, subject_test)
activity_values <- rbind(y_train, y_test)
feature_values <- rbind(X_train, X_test)


#Renaming the SubjectData columns
names(subject_values) <- "Subject"


#Renaming both activity_values and activity_labels respectively as well as acquiring the activity name factor
names(activity_values) <- "Act."
names(activity_labels) <- c("Act.", "Activity")
Activity <- left_join(activity_values, activity_labels, "Act.")[, 2]


#Renaming the feature_values columns
names(feature_values) <- features$V2


#Merging the training and the test sets to create one data set
data_merge <- cbind(subject_values, Activity, feature_values)


#Extracts only the measurements on the mean and standard deviation for each measurement
mean_std <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
colnames <- c("Subject", "Activity", as.character(mean_std))


#Keeping only the relevant data
data_merge <- subset(data_merge, select=colnames)


#Appropriately labels the data set with descriptive variable names and lists them
names(data_merge)<-gsub("^t","time",names(data_merge))
names(data_merge)<-gsub("^f","frequency",names(data_merge))
names(data_merge)<-gsub("Acc","Accelerometer",names(data_merge))
names(data_merge)<-gsub("Gyro","Gyroscope",names(data_merge))
names(data_merge)<-gsub("Mag","Magnitude",names(data_merge))
names(data_merge)<-gsub("BodyBody","Body",names(data_merge))
names(data_merge)


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
independent_set_2 <- data_merge %>% 
 		group_by(Subject, Activity) %>%
  			summarise_each(funs(mean))


#Creating the .txt file locally to my pc
write.table(independent_set_2, "tidy_data_2.txt", row.names = F, quote = F)



