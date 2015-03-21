library(dplyr)
# read the data from files
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt")
Xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
Xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
features <- read.table("UCI HAR Dataset/features.txt")
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")

# Step 1: Merges the training and the test sets to create one data set
subject <- rbind(subjecttest, subjecttrain)
X <- rbind(Xtest, Xtrain)
y <- rbind(ytest, ytrain)
mergedData <- cbind(subject, y, X)

# Step 2: Extracts only the measurements on the mean and standard deviation for each measurement
extractInd <- sort(c(grep("mean()", features[,2], fixed = TRUE), grep("std()", features[,2], fixed = TRUE)))
extractData <- mergedData[, c(1, 2, extractInd+2)]

# Step 3: Uses descriptive activity names to name the activities in the data set
activitiesData <- split(extractData, extractData[, 2])
describe <- function(df) {df[, 2] <- as.character(activitylabels[df[1, 2], 2]); df}
describedData <- activitiesData %>% lapply(describe) %>% unsplit(extractData[, 2])
# extractData[extractData[, 2] == 1, 2] <- as.character(activitylabels[1, 2])
# extractData[extractData[, 2] == 2, 2] <- as.character(activitylabels[2, 2])
# extractData[extractData[, 2] == 3, 2] <- as.character(activitylabels[3, 2])
# extractData[extractData[, 2] == 4, 2] <- as.character(activitylabels[4, 2])
# extractData[extractData[, 2] == 5, 2] <- as.character(activitylabels[5, 2])
# extractData[extractData[, 2] == 6, 2] <- as.character(activitylabels[6, 2])

# Step 4: Appropriately labels the data set with descriptive variable names
names(describedData) <- c("ID", "Activity", as.character(features[extractInd, 2]))

# Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidyData <- describedData %>% group_by(ID, Activity) %>% summarise_each(funs(mean))

# write the tidy data to file
write.table(tidyData, "tidydata.txt", row.names = FALSE)
