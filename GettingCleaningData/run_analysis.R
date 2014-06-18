# read the feature name and extract indices for features
# involving mean and std
# meanFreq are not use for mean
featureName = read.table("features.txt",sep="",header=F)
featureName[,2] = gsub("\\()","",featureName[,2])
featureName[,2] = gsub("-",".",featureName[,2])
ind = grep("mean|std",featureName[,2])
indExclude = grep("meanFreq",featureName[ind,2])
ind = ind[-indExclude]

# read the activity names
activityName = read.table("activity_labels.txt",header=F)

# read training set, corresponding activity and subject set
# from training set take only colums using the ind created earlier
trainSet=read.table("train/X_train.txt", sep="", header=F)
trainSet1 = trainSet[,ind]
colnames(trainSet1) = featureName[ind,2] #provide descriptive names
subTrain = read.table("train/subject_train.txt",header=F, col.name = "Subject")
actTrain = read.table("train/y_train.txt", header=F, col.names="Activity")
trainSet_ready = cbind(subTrain, actTrain, trainSet1)

# similarly, read test set, corresponding activity and subject set
# from test set take only colums using the ind created earlier
testSet=read.table("test/X_test.txt", sep="", header=F)
testSet1 = testSet[,ind]
colnames(testSet1) = featureName[ind,2]  #provide descriptive names
subTest = read.table("test/subject_test.txt",header=F, col.name = "Subject")
actTest = read.table("test/y_test.txt", header=F, col.names="Activity")
testSet_ready = cbind(subTest, actTest, testSet1)

# combine train and test set
finalSet = rbind(trainSet_ready,testSet_ready)

# create factor on Subject and Activity field
finalSet$Subject = as.factor(finalSet$Subject)
finalSet$Activity = as.factor(finalSet$Activity)
levels(finalSet$Activity) = levels(activityName[,2])

# separate out the final data by Subject and Activity and calculate mean
tidyData=aggregate(finalSet[,-c(1,2)], by=list(finalSet$Subject, finalSet$Activity), mean)

# re-name column 1 and 2 as Subject and Activity to give descriptive names
names(tidyData)[1] = "Subject"
names(tidyData)[2] = "Activity"

# save the tidyData into a file
write.table(tidyData,"finalData.txt")
