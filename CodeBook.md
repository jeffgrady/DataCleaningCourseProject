# Code Book, Notes on Data Cleaning Course Project

This is my R code for cleaning and aggregating the data for the
Data Cleaning course project.

First, let me explain my interpretation of the data set and the
assignment, and I'll try to walk you through what I did.

## Organization of the Raw Data Set

Let's start with the data that is common to both the `test` and
`train` parts of the data.

We have `activity_labels.txt`, which identifies the actions the
subject was performing while wearing the smart phone:

```
$ cat activity_labels.txt
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING
```

Next, we have `features.txt`, which basically contains the column
names for `./train/X_train.txt` and `./test/X_test.txt`.

```
$ head features.txt
1 tBodyAcc-mean()-X
2 tBodyAcc-mean()-Y
3 tBodyAcc-mean()-Z
4 tBodyAcc-std()-X
5 tBodyAcc-std()-Y
6 tBodyAcc-std()-Z
7 tBodyAcc-mad()-X
8 tBodyAcc-mad()-Y
9 tBodyAcc-mad()-Z
10 tBodyAcc-max()-X
...
```

Every row in `./train/X_train.txt` and `./test/X_test.txt` contain
observations for a particular subject.  Subjects are stored in
`./train/subject_train.txt` and `./test/subject_test.txt`
respectively, stored as integers:

```
$ head -n 5 ./train/subject_train.txt
1
1
1
1
1
```

Then, `./train/y_train.txt` and `./test/y_test.txt` contain the
labeled activity by integer, as we saw in `activity_labels.txt`:

```
$ head -n 3 ./train/y_train.txt
5
5
5
```


## How The Data Was Cleaned And Combined

Let me try to explain, in pseudo-code, what my R code does to
combine the raw data I described above into a data frame:

* Read all the features and activity labels that are common to `test` and `train`.
* Read in `./test/X_test.txt` as a data frame using `features.txt` as columns.
* Remove all columns that aren't a mean or standard deviation, as per the assignment requirements.
* Read in the integer-labeled activities `./test/y_test.txt` and apply `activity_labels.txt` to it as a factor.
* Read in the test subjects `./test/subject_test.txt`.
* `cbind()` the activities, subjects, and `./test/X_test.txt` into `testData`.
* Do the previous 5 steps for the `train` data as well, storing in `trainData`.
* `rbind()` `testData` and `trainData` into `combinedData`.

We added columns `activityId`, `activityLabel`, and `subjectId` in the process.

## Final Results

The combined data set is stored in `combined_data.txt`.  It was
written by R's `write.table()`.

Here are the columns:

```
$ for col in `head -n 1 combined_data.txt`; do echo $col ; done | sed -e 's/"//g'
tBodyAcc.mean...X
tBodyAcc.mean...Y
tBodyAcc.mean...Z
tBodyAcc.std...X
tBodyAcc.std...Y
tBodyAcc.std...Z
tGravityAcc.mean...X
tGravityAcc.mean...Y
tGravityAcc.mean...Z
tGravityAcc.std...X
tGravityAcc.std...Y
tGravityAcc.std...Z
tBodyAccJerk.mean...X
tBodyAccJerk.mean...Y
tBodyAccJerk.mean...Z
tBodyAccJerk.std...X
tBodyAccJerk.std...Y
tBodyAccJerk.std...Z
tBodyGyro.mean...X
tBodyGyro.mean...Y
tBodyGyro.mean...Z
tBodyGyro.std...X
tBodyGyro.std...Y
tBodyGyro.std...Z
tBodyGyroJerk.mean...X
tBodyGyroJerk.mean...Y
tBodyGyroJerk.mean...Z
tBodyGyroJerk.std...X
tBodyGyroJerk.std...Y
tBodyGyroJerk.std...Z
tBodyAccMag.mean..
tBodyAccMag.std..
tGravityAccMag.mean..
tGravityAccMag.std..
tBodyAccJerkMag.mean..
tBodyAccJerkMag.std..
tBodyGyroMag.mean..
tBodyGyroMag.std..
tBodyGyroJerkMag.mean..
tBodyGyroJerkMag.std..
fBodyAcc.mean...X
fBodyAcc.mean...Y
fBodyAcc.mean...Z
fBodyAcc.std...X
fBodyAcc.std...Y
fBodyAcc.std...Z
fBodyAcc.meanFreq...X
fBodyAcc.meanFreq...Y
fBodyAcc.meanFreq...Z
fBodyAccJerk.mean...X
fBodyAccJerk.mean...Y
fBodyAccJerk.mean...Z
fBodyAccJerk.std...X
fBodyAccJerk.std...Y
fBodyAccJerk.std...Z
fBodyAccJerk.meanFreq...X
fBodyAccJerk.meanFreq...Y
fBodyAccJerk.meanFreq...Z
fBodyGyro.mean...X
fBodyGyro.mean...Y
fBodyGyro.mean...Z
fBodyGyro.std...X
fBodyGyro.std...Y
fBodyGyro.std...Z
fBodyGyro.meanFreq...X
fBodyGyro.meanFreq...Y
fBodyGyro.meanFreq...Z
fBodyAccMag.mean..
fBodyAccMag.std..
fBodyAccMag.meanFreq..
fBodyBodyAccJerkMag.mean..
fBodyBodyAccJerkMag.std..
fBodyBodyAccJerkMag.meanFreq..
fBodyBodyGyroMag.mean..
fBodyBodyGyroMag.std..
fBodyBodyGyroMag.meanFreq..
fBodyBodyGyroJerkMag.mean..
fBodyBodyGyroJerkMag.std..
fBodyBodyGyroJerkMag.meanFreq..
angle.tBodyAccMean.gravity.
angle.tBodyAccJerkMean..gravityMean.
angle.tBodyGyroMean.gravityMean.
angle.tBodyGyroJerkMean.gravityMean.
angle.X.gravityMean.
angle.Y.gravityMean.
angle.Z.gravityMean.
activityId
activityLabel
subjectId
```

`activityId` and `activityLabel` came from `activity_labels.txt`,
`subjectId` from the respective `subject_${TYPE}.txt`.
