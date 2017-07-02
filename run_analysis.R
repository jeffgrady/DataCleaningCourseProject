# run_analysis.R
library(dplyr)

# FIXME:  parameterize paths

BASE_DATA_DIR <- "UCI HAR Dataset/"

mydir <- function(...) {
    paste(BASE_DATA_DIR, ..., sep = "")
}

trim <- function(my_line) {
    gsub("(^\\s+)|(\\s+$)", "", my_line)
}

splitNumericByWhitespace <- function(my_line) {
    as.numeric(unlist(strsplit(my_line, "\\s+", perl = TRUE)))
}

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

readXDataByType <- function(file_type, features) {
    if ((file_type != "test") & (file_type != "train")) {
        stop("invalid file_type")
    }
    filename <- mydir(file_type, "/X_", file_type, ".txt")
    df <- read.table(filename,
                     col.names = features$name,
                     strip.white = TRUE)
    df
}

readActivityLabels <- function() {
    activityLabels <- read.table(mydir("activity_labels.txt"),
                                 col.names = c("activityId", "activityLabel"))
    activityLabels
}

readFeatures <- function() {
    features <- read.table(mydir("features.txt"),
                          col.names = c("featureId", "featureLabel"))
    features
}

readSubjectsByType <- function(file_type) {
    if ((file_type != "test") & (file_type != "train")) {
        stop("invalid file_type")
    }
    filename <- mydir(file_type, "/subject_", file_type, ".txt")
    subjects <- read.table(filename,
                           col.names = c("subjectId"),
                           strip.white = TRUE)
    subjects
}

readFeatures <- function() {
    featureData <- read.table(mydir("features.txt"),
                              col.names = c("id", "name"))
    featureData
}

readFiles <- function(file_type) {
    if ((file_type != "test") & (file_type != "train")) {
        stop("invalid file_type")
    }
    df_list <- list()
    dirname <- mydir(file_type, "/Inertial Signals/")
    print(dirname)
    for (filename in list.files(dirname)) {
        print(paste("reading: ", filename))
        # var_name <- gsub(paste("_", file_type, ".txt", sep=""),
        #                  "",
        #                  filename)
        var_name <- gsub(".txt", "", filename)
        print(paste("var name is:", var_name))
        file_data <- file(paste(dirname, "/", filename, sep=""), "r")
        var_data <- list()
        i <- 0
        for (my_line in readLines(file_data)) {
            my_line <- trim(my_line)
            vec <- splitNumericByWhitespace(my_line)
            # FIXME:  optimize this
            # var_data <- c(var_data, vec)
            var_data[[i]] <- vec
            i <- i + 1
        }
        close(file_data)
        df_list[[var_name]] <- var_data
    }
    data.frame(df_list)
}

# FIXME:  oh, so are the computed values provided to test to see if we
#         read the data in correctly?  Possible.  Could try it.

main <- function() {
    features <- readFeatures()
    activityLabels <- readActivityLabels()

    testData <- readXDataByType("test", features)
    subjects <- readSubjectsByType("test")
    ydata <- readYDataByType("test", activityLabels)
    ydata <- cbind(ydata, subjects)
    testData <- cbind(testData, ydata)
    
    trainData <- readXDataByType("train", features)
    subjects <- readSubjectsByType("train")
    ydata <- readYDataByType("train", activityLabels)
    ydata <- cbind(ydata, subjects)
    trainData <- cbind(trainData, ydata)
    
    combinedData <- rbind(testData, trainData)
}