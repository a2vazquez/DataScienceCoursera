# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable 
#  for each activity and each subject.

# Load activities data and add variable names for the columns
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",col.names = c("id_act", "act"))

# Load labels data for the train and test data columns
labels <- read.table("./UCI HAR Dataset/features.txt")

# Load training data and add variable name for columns
trainLectures <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = labels[,2])

#subset data to extract the values associated with means and std
trainLectures <- trainLectures[, grep("mean|Mean|std",names(trainLectures),value=TRUE)]

# Subject associated with each of the training rows and add variable name for the column
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt",col.names = "id_sub")

# Activity codes for each of the training rows and add variable name for the column
trainActivities<- read.table("./UCI HAR Dataset/train/y_train.txt",col.names = "id_act")

# make a single data frame all training data 
subjectActivitiesTrainLectures <- cbind(trainSubjects,trainActivities,trainLectures)


# Repeat the steps above for test data
testLectures <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = labels[,2])
testLectures <- testLectures[, grep("mean|Mean|std",names(testLectures),value=TRUE)]
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt",col.names = "id_sub")
testActivities<- read.table("./UCI HAR Dataset/test/y_test.txt",col.names = "id_act")
subjectActivitiesTestLectures <- cbind(testSubjects,testActivities,testLectures)


# Merge test and train data 
totalLectures <- rbind(subjectActivitiesTrainLectures, subjectActivitiesTestLectures)

# labeled factor for the activities using activities data
totalLectures$id_act <- factor(totalLectures$id_act,
                              levels = activities$id_act,
                              labels = activities$act)

# Mean of each of the measures for each activity and each subject.

library(plyr)
mean_sub_act <- ddply(totalLectures, .(id_sub,id_act), numcolwise(mean))
#rename the columns to reflect the mean of each value in the dataset
names(mean_sub_act)<- c("id_sub", "activity", paste("Mean(",names(mean_sub_act)[3:88],")",sep = ""))
# create the text file of the data
write.table(mean_sub_act,file="mean_sub_act.txt",sep="\t", row.names=FALSE)

