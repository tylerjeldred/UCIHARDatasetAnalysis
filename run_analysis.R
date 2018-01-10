require("utils")
require("data.table")
require("dplyr")
require("stringr")

library(utils)
library(data.table)
library(dplyr)
library(stringr)

setNames <- function(data, newNames){
  names(data) <- newNames
  data
}

if(!dir.exists("UCI HAR Dataset")){
  download.file(
    "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
    "HAR.zip",
    mode = "wb"
  )
  
  unzip("HAR.zip")
}

features <- 
  fread(file.path("UCI HAR Dataset", "features.txt")) %>%
  rename(FeatureId = V1, FeatureName = V2) %>%
  mutate(ColumnName = paste0("V",FeatureId)) %>%
  filter(grepl("mean|std", FeatureName)) %>%
  mutate(FeatureName = str_replace_all(
    FeatureName, 
    "([\\(\\)])*", 
    ""
  )) %>%
  mutate(FeatureName = str_replace_all(
    FeatureName, 
    "-", 
    ""
  )) %>%
  mutate(FeatureName = sub(
    "(t)([a-zA-Z]*)Magmean", 
    "\\2.Magnitude.MeanOverTime", 
    FeatureName
  )) %>%
  mutate(FeatureName = sub(
    "(t)([a-zA-Z]*)Magstd", 
    "\\2.Magnitude.StandardDeviationOverTime", 
    FeatureName
  )) %>%
  mutate(FeatureName = sub(
    "(t)([a-zA-Z]*)mean(X|Y|Z)", 
    "\\2.\\3AxisSignal.MeanOverTime", 
    FeatureName
  )) %>%
  mutate(FeatureName = sub(
    "(t)([a-zA-Z]*)std(X|Y|Z)", 
    "\\2.\\3AxisSignal.StandardDeviationOverTime", 
    FeatureName
  )) %>%
  mutate(FeatureName = sub(
    "(f)([a-zA-Z]*)MagmeanFreq", 
    "\\2.Magnitude.Fourier.MeanFrequency", 
    FeatureName
  )) %>%
  mutate(FeatureName = sub(
    "(f)([a-zA-Z]*)Magmean", 
    "\\2.Magnitude.Fourier.MeanOverTime", 
    FeatureName
  )) %>%
  mutate(FeatureName = sub(
    "(f)([a-zA-Z]*)Magstd", 
    "\\2.Magnitude.Fourier.StandardDeviationOverTime", 
    FeatureName
  )) %>%
  mutate(FeatureName = sub(
    "(f)([a-zA-Z]*)meanFreq(X|Y|Z)", 
    "\\2.\\3AxisSignal.Fourier.MeanFrequency", 
    FeatureName
  )) %>%
  mutate(FeatureName = sub(
    "(f)([a-zA-Z]*)mean(X|Y|Z)", 
    "\\2.\\3AxisSignal.Fourier.MeanOverTime", 
    FeatureName
  )) %>%
  mutate(FeatureName = sub(
    "(f)([a-zA-Z]*)std(X|Y|Z)", 
    "\\2.\\3AxisSignal.Fourier.StandardDeviationOverTime", 
    FeatureName
  )) %>%
  mutate(FeatureName = sub(
    "(Body|Gravity)(Acc)([a-zA-Z\\.]*)", 
    "Accelerometer.\\1\\3", 
    FeatureName
  )) %>%
  mutate(FeatureName = sub(
    "(Body|Gravity)(Gyro)([a-zA-Z\\.]*)", 
    "Gyroscope.\\1\\3", 
    FeatureName
  )) %>%
  mutate(FeatureName = sub(
    "([a-zA-Z\\.]*)(Jerk)(.[XYZ]AxisSignal|.Magnitude)([a-zA-Z\\.]*)", 
    "\\1\\3.\\2\\4", 
    FeatureName
  )) %>%
  mutate(FeatureName = sub(
    "Body(Accelerometer|Gyroscope)([a-zA-Z\\.]*)(Magnitude|Magnitude.Jerk)([a-zA-Z\\.]*)", 
    "\\1\\2\\3.Body\\4", 
    FeatureName
  ))

activityLabels <- 
  fread(file.path("UCI HAR Dataset", "activity_labels.txt")) %>%
  rename(ActivityId = V1, ActivityName = V2)


subjectsTrain <- 
  fread(file.path("UCI HAR Dataset", "train", "subject_train.txt")) %>%
  rename(Subject = V1)

activitiesTrain <- 
  fread(file.path("UCI HAR Dataset", "train", "y_train.txt")) %>%
  rename(ActivityId = V1) %>%
  left_join(activityLabels, "ActivityId")

dataTrain <- 
  fread(file.path("UCI HAR Dataset", "train", "X_train.txt")) %>%
  mutate(Subject = subjectsTrain$Subject) %>%
  mutate(ActivityName = activitiesTrain$ActivityName)


subjectsTest <- 
  fread(file.path("UCI HAR Dataset", "test", "subject_test.txt")) %>%
  rename(Subject = V1)

activitiesTest <- 
  fread(file.path("UCI HAR Dataset", "test", "y_test.txt")) %>%
  rename(ActivityId = V1) %>%
  left_join(activityLabels, "ActivityId")

dataTest <- 
  fread(file.path("UCI HAR Dataset", "test", "X_test.txt")) %>%
  mutate(Subject = subjectsTest$Subject) %>%
  mutate(ActivityName = activitiesTest$ActivityName)


dataSet <- 
  rbind(dataTrain, dataTest) %>%
  select(c(features$ColumnName, "Subject", "ActivityName")) %>%
  do(setNames(., c(features$FeatureName, "Subject", "ActivityName")))


dataSet_Summary <-
  dataSet %>%
  group_by(Subject, ActivityName) %>% 
  summarise_all(funs(mean))


write.table(
  dataSet_Summary, 
  "UCI_HAR_Dataset_Summary_Subject_Activity_Averages.txt"
)

