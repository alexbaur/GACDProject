## Part 1
## Get all the data into readable form and assigned to objects

## Note: working directory is "./UCI HAR Dataset"
## Note: packages used are 'plyr', 'dplyr', and 'data.table'

## Read test objects
subject_test <- read.table("test/subject_test.txt", header = FALSE)
Y_test <- read.table("test/y_test.txt", header = FALSE)
X_test <- read.table("test/X_test.txt", header = FALSE)

## Read train objects
subject_train <- read.table("train/subject_train.txt", header = FALSE)
Y_train <- read.table("train/Y_train.txt", header = FALSE)
X_train <- read.table("train/X_train.txt", header = FALSE)

## Combine the test and training objects
subject <- rbind(subject_train, subject_test)
Y <- rbind(Y_train, Y_test)
X <- rbind(X_train, X_test)

## Give the data in the X data set column names
names <- read.table("features.txt")
colnames(X) <- transpose(names[2])

## Name the data columns and combine
colnames(Y) <- "Activity_type"
colnames(subject) <- "subject_number"
combined <- cbind(subject, Y, X)

## Part 2
## Extract the measurments for mean and standard deviation

## Need to be able to appropriately read the features from the metadata for the dataset
features <- read.table("features.txt", header = FALSE, stringsAsFactors = FALSE)

## Extracting the mean and standard deviation rows
fmeanstd <- features[grep("[Mm][Ee][Aa][Nn]|[Ss][Tt][Dd]", features$V2), ]

## Extract the corresponding rows from the "combined" data frame
combined_mean_std <- combined[, c(1, 2, fmeanstd$V1+2)]

## Part 3
## Use descriptive names to name data set variables

## From : http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#
## "Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist."

## Get activity labels
activity_labels <- read.table("activity_labels.txt", strip.white = TRUE)

## Correlate the data in the activity_labels object with Y_data in combined_mean_std
combined_mean_std$Activity_type <- activity_labels[combined_mean_std$Activity_type, 2]

## Part 4
## Descriptive data set variable names

## Get the column names for the mean and standard deviation attributes
names(combined_mean_std)

## Replace the abbreviations with the appropriate extended label using gsub
names(combined_mean_std)<-gsub("[Aa]cc", "Accelerometer", names(combined_mean_std))
names(combined_mean_std)<-gsub("angle", "Angle", names(combined_mean_std))
names(combined_mean_std)<-gsub("[Bb]ody[Bb]ody", "Body", names(combined_mean_std))
names(combined_mean_std)<-gsub("^f", "Frequency", names(combined_mean_std))
names(combined_mean_std)<-gsub("-freq()", "Frequency", names(combined_mean_std))
names(combined_mean_std)<-gsub("gravity", "Gravity", names(combined_mean_std))
names(combined_mean_std)<-gsub("Gyro", "Gyroscope", names(combined_mean_std))
names(combined_mean_std)<-gsub("[Mm]ag", "Magnitude", names(combined_mean_std))
names(combined_mean_std)<-gsub("-mean", "Mean", names(combined_mean_std))
names(combined_mean_std)<-gsub("-std", "StdDev", names(combined_mean_std))
names(combined_mean_std)<-gsub("^t", "Time", names(combined_mean_std))
names(combined_mean_std)<-gsub("tBody", "T-Body", names(combined_mean_std))

## Part 5
## Tidy data set and upload

## First aggregate and then write into a text file
tidy <- aggregate(. ~subject_number + Activity_type, combined_mean_std, mean)
tidy <- tidy[order(tidy$subject_number,tidy$Activity_type),]
write.table(tidy, file = "tidydata.txt", row.name=FALSE)
