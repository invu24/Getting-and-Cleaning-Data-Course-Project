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

1.
#Merging the training and the test sets to create one data set
test_values <- cbind(y_test, subject_test, X_test)
train_values <- cbind(y_train, subject_train, X_train)
data_merge <- rbind(train_values, test_values)

#Labeling the first two columns "subject" and "activity" respectively 
colnames(data_merge) <- c("subject", features[, 2], "activity")

2.
#Extracting only the mean and the standard deviation from the data
mean_std <- grepl("subject|activity|mean|std", colnames(data_merge))

#Keeping only the relevant data 
data_merge_final <- data_merge[, mean_std]

3.
#Uses descriptive activity names to name the activities in the data set
colnames(data_merge_final) <- "label"
data_merge_final$activity <- factor(data_merge_final$label, labels = as.character(activity_labels[,2]))
activity <- data_merge_final$activity

4. 
#Appropriately labels the data set with descriptive variable names
#See previous steps and notice descriptive variable names

5.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
independent_set_2 <- data_merge_final %>% 
 		group_by(subject, activity) %>%
  			summarise_each(funs(mean))

write.table(independent_set_2, "tidy_data_2.txt", row.names = F, quote = F)
