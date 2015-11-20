# Getting and Cleaning Data Project

##Alex Baur
##11/19/15

##run_analysis.R

The code begins by reading all test objects and train objects (X, Y, subject).

subject_train <- read.table("train/subject_train.txt", header = FALSE)

Y_train <- read.table("train/Y_train.txt", header = FALSE)

X_train <- read.table("train/X_train.txt", header = FALSE)

subject_train <- read.table("train/subject_train.txt", header = FALSE)

Y_train <- read.table("train/Y_train.txt", header = FALSE)

X_train <- read.table("train/X_train.txt", header = FALSE)

It then combines the like variables through rbind in the base package.

subject <- rbind(subject_train, subject_test)

Y <- rbind(Y_train, Y_test)

X <- rbind(X_train, X_test)

Now we are presented a problem though, X has no labeling for all of the values taken during the experiment. We have a file in our
directory that contains that information however: "features.txt". We read it in and notice that it is a list that is oriented vertically which will not allow us to apply it to X. Thus the transpose function is used to orient and assign the column names.

names <- read.table("features.txt")

colnames(X) <- transpose(names[2])

We are now ready to combine all 3 data sets together.

colnames(Y) <- "Activity_type"

colnames(subject) <- "subject_number"

combined <- cbind(subject, Y, X)

We are then required to extract the variables that only relate to standard deviation or the mean. This is accomplished through the use
of meta characters from the "features.txt" file again.

fmeanstd <- features[grep("[Mm][Ee][Aa][Nn]|[Ss][Tt][Dd]", features$V2), ]

The combined data frame is then filtered with the mean and std variables for a more concise data set.

combined_mean_std <- combined[, c(1, 2, fmeanstd$V1+2)]

The activity labels must then be assigned to the Aactivity_type column so that it is more easily recognized.

activity_labels <- read.table("activity_labels.txt", strip.white = TRUE)

combined_mean_std$Activity_type <- activity_labels[combined_mean_std$Activity_type, 2]

The variables measured from the device are messy and need to be cleaned up. Abbreviations were expanded upon and non-alpha characters were sorted out except at the end or where deemed necessary.

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

Finally, we take the data and aggregate it based on the mean of the data and write it to a file.

tidy <- aggregate(. ~subject_number + Activity_type, combined_mean_std, mean)

tidy <- tidy[order(tidy$subject_number,tidy$Activity_type),]

write.table(tidy, file = "tidydata.txt", row.name=FALSE)
