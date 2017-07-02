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


main <- function() {
    features <- readFeatures()
    activityLabels <- readActivityLabels()

    testData <- readXDataByType("test", features)
    ydata <- readYDataByType("test", activityLabels)
    subjects <- readSubjectsByType("test")
    ydata <- cbind(ydata, subjects)
    testData <- cbind(testData, ydata)
    
    trainData <- readXDataByType("train", features)
    ydata <- readYDataByType("train", activityLabels)
    subjects <- readSubjectsByType("train")
    ydata <- cbind(ydata, subjects)
    trainData <- cbind(trainData, ydata)
    
    combinedData <- rbind(testData, trainData)
    write.table(combinedData, "combined_data.txt")
    combinedData
}