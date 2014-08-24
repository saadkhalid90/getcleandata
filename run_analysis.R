setwd("C:/Users/hp/Documents/cleanData/UCI HAR Dataset")

## reading data
subject_test <- readLines("./test/subject_test.txt")
subject_train <- readLines("./train/subject_train.txt")
act_test <- readLines("./test/y_test.txt")
act_train <- readLines("./train/y_train.txt")

train <- readLines("./train/X_train.txt")
test <- readLines("./test/X_test.txt")

## seperating values
split_train<-unlist(strsplit(train," "))
split_test<-unlist(strsplit(test," "))
train_fnl<-split_train[which(nchar(split_train)!=0)]
test_fnl<-split_test[which(nchar(split_test)!=0)]

features<-readLines("features.txt")

## converting into numeric and into matrices
train_fnl <- as.numeric(train_fnl)
test_fnl <-as.numeric(test_fnl)
train_matrix<-matrix(train_fnl, nrow=(length(train_fnl)/561),ncol=561, byrow=TRUE)
test_matrix<-matrix(test_fnl, nrow=(length(test_fnl)/561),ncol=561, byrow=TRUE)
entire_matrix<-rbind(train_matrix,test_matrix)

feature_table<-data.frame(entire_matrix)

## subsetting mean and std features
index<-c(grep("[Mm]ean",features),grep("[Ss]td",features))
feature_table<-feature_table[,index]
features<-features[index]

## removing numbers from start of feature names
names(feature_table)<-gsub("^[0-9]+ ","",features)

## factorizing activity and subject, combining it to feature data
activity<-c(act_train,act_test)
activity<-as.factor(activity)

activity_labels<-readLines("activity_labels.txt")
levels(activity)<-gsub("^[0-9] ","",activity_labels)

subject<-c(subject_train,subject_test)
subject<-as.factor(as.numeric(subject))
levels(subject)<-as.numeric(as.character(levels(subject)))

final_data<-cbind(subject,activity,feature_table)

## fixing variable names
new_features<-gsub("-","_",names(feature_table))
new_features<-gsub("\\()_","",new_features)
new_features<-gsub(",","",new_features)
new_features<-gsub("\\()","",new_features)
new_features<-gsub("\\(",".",new_features)
new_features<-gsub(")","",new_features)

## summarizing data / calculating means
summ_data <- aggregate(final_data[,3:ncol(final_data)], by=list(subject,activity), FUN=mean)
names(summ_data)[1:2]<-c("subject","activity")
names(summ_data)[3:ncol(summ_data)]<-new_features

## writing data
write.table(summ_data, "project_summarized_data.txt",row.names=FALSE,sep=",")
