#load libraries

library(glmnet)
library(ggplot2)
library(smooth)
library(caret)
library(tidyverse)
library(keras)
library(tensorflow)
library(matrixStats)
library(TSA)
library(Metrics)
library(TTR)
library(forecast)
library(shiny)
library(tibble)
library(dplyr)  #sub of plyr, streamlined way to manipulat tbl_df (goo function)
library(SmartEDA)  #good package to assess data (type 1 & 2)
library(RCurl)
library(RMySQL)
library(sqldf)
library(RSQLite)
library(httr)
library(data.table)
library(XML)
library(tidyr)
library(xlsx)
library(plyr)
library(lubridate) ##good to work with dates
library(tidyselect)

#download and unzip the file

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,
           destfile='HAR.zip',
           method="curl", # for OSX / Linux 
           mode="wb") # "wb" means "write binary," and is used for binary files
unzip(zipfile = "HAR.zip") # unpack the files into subdirectories 

#Load Test data

subject_test<-read.table(file='C:/Users/Kevin/Desktop/Data Analytics/JHU R/Course 3/Final Project/UCI HAR Dataset/test/subject_test.txt')

X_test<-read.table(file='C:/Users/Kevin/Desktop/Data Analytics/JHU R/Course 3/Final Project/UCI HAR Dataset/test/X_test.txt')

Y_test<-read.table(file='C:/Users/Kevin/Desktop/Data Analytics/JHU R/Course 3/Final Project/UCI HAR Dataset/test/Y_test.txt')

#Load Train Data

subject_train<-read.table(file='C:/Users/Kevin/Desktop/Data Analytics/JHU R/Course 3/Final Project/UCI HAR Dataset/train/subject_train.txt')

X_train<-read.table(file='C:/Users/Kevin/Desktop/Data Analytics/JHU R/Course 3/Final Project/UCI HAR Dataset/train/X_train.txt')

Y_train<-read.table(file='C:/Users/Kevin/Desktop/Data Analytics/JHU R/Course 3/Final Project/UCI HAR Dataset/train/Y_train.txt')


#Load Features and Activity_labels


features<-read.table(file='C:/Users/Kevin/Desktop/Data Analytics/JHU R/Course 3/Final Project/UCI HAR Dataset/features.txt')

activity_labels<-read.table(file='C:/Users/Kevin/Desktop/Data Analytics/JHU R/Course 3/Final Project/UCI HAR Dataset/activity_labels.txt')


#Combine the test data together

test_total<-cbind(subject_test,Y_test,X_test)

#Combine the train data together

train_total<-cbind(subject_train,Y_train,X_train)


#Combine test and train and name variables


total_data<-rbind(test_total,train_total)
features2<-select(features,V2)
colnames(total_data)[1]<-'subject'
colnames(total_data)[2]<-'activity'
features2 <- data.frame(lapply(features2, as.character), stringsAsFactors=FALSE)
colnames(total_data)[3:563]<-features2[,1]

##select of mean and standard deviation

#create unique variable names
valid_column_names <- make.names(names=names(total_data), unique=TRUE, allow_ = TRUE)
names(total_data) <- valid_column_names

#select subject & activity variable values
subject<-total_data %>% select('subject')
activity<-total_data %>% select('activity')

#select all variable names containing mean
total_data_mean<-select(total_data,contains('mean'))

#select all variable names containing standard deviation (std)
total_data_std<-select(total_data, contains('std'))

#combine subject, activity, mean variables, and std variables
mean_std_data<-cbind(subject,activity, total_data_mean,total_data_std)

#Use descriptive activity names to name the activities in the data set


for (i in 1: 10299){
        
                             
if (activity[i,1]=='1'){
        activity[i,1]='walking'
}
      else if (activity[i,1] == '2'){
        activity[i,1]='walking upstairs'
}  
else if (activity[i,1] == '3'){
        activity[i,1]='walking downstairs'
}
else if (activity[i,1] == '4'){
        activity[i,1]='sitting'
}        
else if (activity[i,1] == '5'){
        activity[i,1]='standing'
}
        
else if (activity[i,1] == '6'){
        activity[i,1]='laying'
}                
}

mean_std_data<-cbind(subject,activity, total_data_mean,total_data_std)

#Appropriately labels the data set with descriptive variable names.
## all lowercase when possible
##descriptive
##unique
##contains no underscores/dots/space


#change to lower case 
names(mean_std_data)<-tolower(names(mean_std_data))

#remove dots from variables
names(mean_std_data)<-gsub("\\.", "", names(mean_std_data))

#check for unique names-should be 88 unique names
nbr_unique<-length(unique(names(mean_std_data)))
nbr_unique  #check-yes 88 uniques names

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


mean_std_data<-tbl_df(mean_std_data)
mean_std_data_group<-mean_std_data %>% group_by(activity, subject) %>% 
        summarize_all('mean')
tidy_data_step_5_out<-mean_std_data_group
