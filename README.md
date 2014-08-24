README
========================================================

This document will explain the working of the script "run_analysis.R" to produce the required data set for the project of the 'Getting and Cleaning Data' MOOC at Coursera 

## Download Data and set directory
First of all, the entire data set was download from the UC Irvine website through the 
provided link. Then the directory for the R session was set by the following line:


```r
setwd("C:/Users/hp/Documents/cleanData/UCI HAR Dataset")
```

You can also embed plots, for example:
## Reading in data
The data of the all the features (variables calculated by the smart phone sensor measurements), subject information (id's of persons who were involved in the study) and activity labels (factors labeling 6 different activities that the subjects are performing) is read in by the following code:  


```r
subject_test <- readLines("./test/subject_test.txt")
subject_train <- readLines("./train/subject_train.txt")
act_test <- readLines("./test/y_test.txt")
act_train <- readLines("./train/y_train.txt")

train <- readLines("./train/X_train.txt")
test <- readLines("./test/X_test.txt")
```

Please note that 'train' and 'test' represent training and test data sets

## Seperating feature readings from long character strings
The train and test objects contain long character strings that contain numeric readings of all 561 features(separated by a space or two) . The following code separates the numeric readings to produce separated numeric feature readings in a large numeric vector (test_fnl and train_fnl)


```r
split_train<-unlist(strsplit(train," "))
split_test<-unlist(strsplit(test," "))
train_fnl<-split_train[which(nchar(split_train)!=0)]
test_fnl<-split_test[which(nchar(split_test)!=0)]
```

## Conversion of long vectors to matrices/ Combining train and test data matrices
The long numeric train and test vectors were converted into matrices of 561 columns (total number of features) and then combined to create entire_matrix which was finally also converted into a data frame 


```r
features<-readLines("features.txt")
train_fnl <- as.numeric(train_fnl)
test_fnl <-as.numeric(test_fnl)
train_matrix<-matrix(train_fnl, nrow=(length(train_fnl)/561),ncol=561, byrow=TRUE)
test_matrix<-matrix(test_fnl, nrow=(length(test_fnl)/561),ncol=561, byrow=TRUE)
entire_matrix<-rbind(train_matrix,test_matrix)

feature_table<-data.frame(entire_matrix)
```

## Subsetting mean and standard deviation features
Following the previous step, the mean and standard deviation features were subsetted by the following code. 86 out of 561 features are selected.  


```r
index<-c(grep("[Mm]ean",features),grep("[Ss]td",features))
feature_table<-feature_table[,index]
features<-features[index]
```

## Combining activity and subject data
The activity and the subject data were then converted into factors. The activity factors were replaced by their descriptions and the train. Finally the activity and subject data (train and test combined) were put together with the data frame of the features(feature_table). The data was put together in the object final_data


```r
names(feature_table)<-gsub("^[0-9]+ ","",features)

activity<-c(act_train,act_test)
activity<-as.factor(activity)


activity_labels<-readLines("activity_labels.txt")
levels(activity)<-gsub("^[0-9] ","",activity_labels)

subject<-c(subject_train,subject_test)
subject<-as.factor(as.numeric(subject))
levels(subject)<-as.numeric(as.character(levels(subject)))

final_data<-cbind(subject,activity,feature_table)
```

## Making feature names readable
The following script lines then made the variable names of the features more readable and in accordance with the variable conventions in R. More details on this are given in the code book.


```r
new_features<-gsub("-","_",names(feature_table))
new_features<-gsub("\\()_","",new_features)
new_features<-gsub(",","",new_features)
new_features<-gsub("\\()","",new_features)
new_features<-gsub("\\(",".",new_features)
new_features<-gsub(")","",new_features)
```

## Summarizing data
Finally the means for all the variables for each subject and activity level were calculated to get the summ_data object. summ_data has 180 rows (activity levels * subject levels=6*30) and 88 columns(86 features and the subject and activity column).


```r
summ_data <- aggregate(final_data[,3:ncol(final_data)], by=list(subject,activity), FUN=mean)
names(summ_data)[1:2]<-c("subject","activity")
names(summ_data)[3:ncol(summ_data)]<-new_features
```

## Writing summ_data to a .csv file
The last step involved writing the summ_data object obtained in the last step to a text file called "project_summarized_data.txt".
