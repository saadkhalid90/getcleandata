Code Book
========================================================

### Variables (How to read)

The variables in the "project_summarized_data.txt" can be decoded or read by using the following code:

* t in the beginning of variable names stands for 'time'. All variables starting with t are time based variables.
* F in the beginning of variable names stands for 'frequency'. All variables starting with F are frequency based variables.
* Through filtering sensor readings have been divided into Body and Gravity signals. 'Body' or 'Gravity' in a variable identify if the acceleration signal is related to gravity or the body.
* Mag stands for magnitude and variables containing Mag are euclidean norm of the tri-axial signals(X,Y and Z axes).
* Acc refers to readings gotten from accelerometer and Gyro refers to readings obtained from gyroscope. 
* Jerk in variable names refers to Jerk signals.
* mean and std represent the arithmetic mean and standard deviation respectively. Angle in a variable refers to the angle between two vectors mentioned in variable name. 
* The capital X,Y or Z at the end of variable names indicate the dimension in the 3-D Cartesian coordinate system.

### Units
All the variables have been normalized and can have a value between -1 and 1.

### Transformations
Summary of all the important transformations is given below. These have also been explained in detail in the README.Rmd file.

1. First, the data was downloaded from UC Irvine website.
2. All the feature's data (train and test) was combined in the form of a matrix and later a data frame(10299 observations and 561 features).
3. The subject and activity data was read in and converted into factors. The activity factor levels which were numeric were replaced with descriptive levels.
4. The activity and subject factor were combined with the feature data frame explained in point 2.
5. Subsetting was done to isolate the data with features that are either means or standard deviation measurements (86 features subsetted).
6. Means of all the 'mean' and 'standard deviation' features was calculated (using the aggregate function) for each activity and subject level. These means were also written to a file called "project_summarized_data.txt".  
