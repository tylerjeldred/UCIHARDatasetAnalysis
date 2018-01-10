# UCIHARDatasetAnalysis

## Project Description
Our analysis uses a single R script, `run_analysis.R`, to download, analyze, and output a report on the UCI Human Activity Recognition Using Smartphones Data Set. You can find out more about the data set [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and download a copy of the data [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

Our analysis outputs the data file `UCI_HAR_Dataset_Summary_Subject_Activity_Averages.txt` which 1) is the merged result from the training and the test sets, 2) contains only data from the mean and standard deviation for each measurement, 3) has descriptive activity names to name the activities in the data set, 4) has descriptive variable names, and 5) shows the averages for each of these values for each activity of each subject. To accomplish this our script takes the following steps:
1.  Install and use all necessary libraries: utils, data.table, dplyr, stringr
2.  Download and unzip the UCI HAR Dataset if it has not already been downloaded and unzipped.
3.  Read in the `features.txt` file, using only those that describe a mean or standard deviation, mutate the feature names into more readable and descriptive field names, and prime the data for use as our data set's fields.
4.  Read in the `activity_labels.txt` file.
5.  Read in the `subject_train.txt` file.
6.  Read in the `y_train.txt` file and join it with the `activity_labels.txt` data to produce the activity labels for the training data.
7.  Read in the `X_train.txt` file and add the subjects and activities from steps 5 and 6 to it to produce the training data with subjects and activity labels.
8.  Read in the `subject_test.txt` file.
9.  Read in the `y_test.txt` file and join it with the `activity_labels.txt` data to produce the activity labels for the testing data.
10. Read in the `X_test.txt` file and add the subjects and activities from steps 8 and 9 to it to produce the testing data with subjects and activity labels.
11. Combine the training data and the testing data from steps 7 and 10 and set the field names from the features in step 3.
12. Create a new data set from the data from step 11 that is the averages values for each activity for each subject.
13. Output the data set from step 12 to the file `UCI_HAR_Dataset_Summary_Subject_Activity_Averages.txt`.

