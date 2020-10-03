library(dplyr)
library(reshape2)

features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("no", "features"))
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("labels", "activity"))


## Reading in data with features data into tess and training sets
##Condition 3/5 of assignment: Uses descriptive activity names to name the activities in the data set
train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$features)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "labels")
y_train_label <- left_join(y_train, activities, by = "labels")

tidy_train <- cbind(train, y_train_label, x_train)
tidy_train <- select(tidy_train, -labels)

test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$features)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "labels") 
y_test_label <- left_join(y_test, activities, by = "labels")

## Condition 1/5 in assignment: Merges the training and the test sets to create one data set.

tidy_test <- cbind(test, y_test_label, x_test)
tidy_test <- select(tidy_test, -labels)

##Condition 2/5 of assignment: Extracts only the measurements on the mean and standard deviation for each measurement.

#Select the columns where the column names match either of the two strings ".mean" and ".std"
tidy_test_1 <- select(tidy_test, subject:activity, matches(".mean|.std"))

#However, this still leaves us with some column regarding mean frequency and about angle.  Hence the columns need to be removed. 
tidy_test_1 <- select(tidy_test_1,-matches("meanFreq|angle"))

##Condition 3/5 of assignment: done at the start when loading data

## Condition 4/5 of assignment: Appropriately labels the data set with descriptive variable names
# lower all capital
tolower(names(tidy_test_1))

names(tidy_test_1)<-gsub("Acc", "Accelerometer", names(tidy_test_1))
names(tidy_test_1)<-gsub("Gyro", "Gyroscope", names(tidy_test_1))
names(tidy_test_1)<-gsub("BodyBody", "Body", names(tidy_test_1))
names(tidy_test_1)<-gsub("Mag", "Magnitude", names(tidy_test_1))
names(tidy_test_1)<-gsub("^t", "Time", names(tidy_test_1))
names(tidy_test_1)<-gsub("^f", "Frequency", names(tidy_test_1))
names(tidy_test_1)<-gsub("tBody", "TimeBody", names(tidy_test_1))
names(tidy_test_1)<-gsub("-mean()", "Mean", names(tidy_test_1))
names(tidy_test_1)<-gsub("-std()", "STD", names(tidy_test_1))
names(tidy_test_1)<-gsub("-freq()", "Frequency", names(tidy_test_1))
names(tidy_test_1)<-gsub("gravity", "Gravity", names(tidy_test_1))

## Condition 5/5 of assignment: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidymelted <- melt(tidy_test_1, id = c('subject', 'activity'))
meltedmean <- dcast(tidymelted, subject + activity ~ variable, mean)

#A txt file that contains the file processed tidy data 

write.table(meltedmean, file=file.path("tidy.txt"), row.names = FALSE, quote = FALSE)
