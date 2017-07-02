# run_analysis.R
library(dplyr)

# Set your raw data directory here
BASE_DATA_DIR <- "UCI HAR Dataset/"

# Convenience function for creating paths based on BASE_DATA_DIR.
# Takes ... arguments and pastes them together starting with BASE_DATA_DIR
mydir <- function(...) {
    paste(BASE_DATA_DIR, ..., sep = "")
}

# Read y_test and y_train data files and apply activity labels as a factor.
# Arguments: file_type can be "test" or "train" and activityLabels is a
# data frame.
# Returns a data frame of the result.
readYDataByType <- function(file_type, activityLabels) {
    if ((file_type != "test") & (file_type != "train")) {
        stop("invalid file_type")
    }
    filename <- mydir(file_type, "/y_", file_type, ".txt")
    ydata <- read.table(filename,
                        col.names = c("activityId"),
                        strip.white = TRUE)
    ydata$activityLabel <- cut(ydata$activityId,
                               length(activityLabels$activityLabel),
                               labels = activityLabels$activityLabel)
    ydata
}

# Read X_test and X_train data files into a data frame and uses the 
# data frame field features$name as columns.
# Arguments: file_type can be "test" or "train" and features is a
# data frame.
# Returns a data frame of the result.
readXDataByType <- function(file_type, features) {
    if ((file_type != "test") & (file_type != "train")) {
        stop("invalid file_type")
    }
    filename <- mydir(file_type, "/X_", file_type, ".txt")
    read.table(filename, col.names = features$name, strip.white = TRUE)
}

# Reads activity_labels.txt and returns a data frame.
readActivityLabels <- function() {
    read.table(mydir("activity_labels.txt"),
               col.names = c("activityId", "activityLabel"))
}

# Reads subject_test and subject_train and returns a data frame.
# Arguments: file_type can be "test" or "train"
readSubjectsByType <- function(file_type) {
    if ((file_type != "test") & (file_type != "train")) {
        stop("invalid file_type")
    }
    filename <- mydir(file_type, "/subject_", file_type, ".txt")
    read.table(filename, col.names = c("subjectId"), strip.white = TRUE)
}

# Reads features.txt and returns a data frame.
readFeatures <- function() {
    read.table(mydir("features.txt"), col.names = c("id", "name"))
}

# Clean the columns.  Takes a data frame as a parameter, returns a data
# frame that only includes columns referencing "mean" or "std", case
# insensitive.
cleanColumns <- function(my_data) {
    cols <- names(my_data)
    my_data[,cols[grepl("(mean|std)", cols, ignore.case = TRUE)]]
}

# Takes combinedData as an argument and returns a table
# containing the mean for each variable for every subject and activity.
tidy <- function(my_data) {
    my_data$subject.activity <- paste(my_data$subjectId,
                                      my_data$activityId,
                                      sep = ".")
    my_data$subject.activity <- factor(my_data$subject.activity)
    df <- data.frame(subject.activity=unique(my_data$subject.activity))
    new_names <- c("subject.activity")
    for (col in 1:(length(names(my_data))-4)) {
        new_col <- paste(names(my_data)[col], "mean", sep = ".")
        new_names <- c(new_names, new_col)
        new_means <- tapply(my_data[,col],
                            my_data$subject.activity,
                            FUN = mean,
                            simplify = T)
        df <- cbind(df, new_means)
    }
    colnames(df) <- new_names
    df
}

# returns a data frame of the combined, cleaned data
getCombinedData <- function() {
    features <- readFeatures()
    activityLabels <- readActivityLabels()

    testData <- readXDataByType("test", features)
    testData <- cleanColumns(testData)
    ydata <- readYDataByType("test", activityLabels)
    subjects <- readSubjectsByType("test")
    ydata <- cbind(ydata, subjects)
    testData <- cbind(testData, ydata)
    
    trainData <- readXDataByType("train", features)
    trainData <- cleanColumns(trainData)
    ydata <- readYDataByType("train", activityLabels)
    subjects <- readSubjectsByType("train")
    ydata <- cbind(ydata, subjects)
    trainData <- cbind(trainData, ydata)
    
    combinedData <- rbind(testData, trainData)
    combinedData
}

# assemble the combined data.  tidy it.  write them to files.
main <- function() {
    combinedData <- getCombinedData()
    tidyData <- tidy(combinedData)
    write.table(tidyData, "tidy_data.txt", row.names = FALSE)
}