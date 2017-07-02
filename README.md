# Data Cleaning Course Project

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
* Read in the integer-labeled activities `./test/y_test.txt` and apply `activity_labels.txt` to it as a factor.
* Read in the test subjects `./test/subject_test.txt`.
* `cbind()` the activities, subjects, and `./test/X_test.txt` into `testData`.
* Do the previous 4 steps for the `train` data as well, storing in `trainData`.
* `rbind()` `testData` and `trainData` into `combinedData`.

The result is a data frame with 10299 observations and 564 variables:
the 561 from `features.txt`, plus 3 more: `activityId`, `activityLabel`, and `subjectId`.

