Practical Machine Learning : Course Project
========================================================


In this course project, a prediction model is generated to classify the manner of dumbel biceps curl (5 classes : Class A to Class E) by using sensor data accumulated from arm sensors, forearm sensors, belt sensors and dumbel sensors. The training data is collected from "pml-training.csv" file. A classification model is generated using the "random forest" machine learning algorithm. The model is applied to the test data set "pml-testing.csv" to determine the classification required in the Course Project: Submission part.

The caret package is used for the machine learning algorithm. The first step is to load the caret package.


```r
library(caret)
```

The training data is read from the file and is separated into training class and testing class. The training class is used for training purposes, whereas testing class was used for cross-validation puposes.


```r
dat = read.csv("pml-training.csv",header=T)
inTrain = createDataPartition(y=dat$classe, p=0.7, list=F)
training = dat[inTrain,]
testing = dat[-inTrain,]
```

To understand the nature of the dataset, some exploratory analysis was performed.


```r
dim(training)
```

```r
str(training)
```

It is observed that the dataset is not clean. A lot of the variables contain 'NA' values and not all of the variables are important for training purposes. Further reading from the "Human Activity Recognition" reveals that, the investigators took measurement of Euler angles roll, pitch and yaw, as well as the raw accelerometer, gyroscope and magnetometer readings. At this step, I also looked into the testing dataset, and found something interesting:


```r
testdat = read.csv("pml-testing.csv",header=T)
head(testdat,1)
```
From testdat, I observed that out of 160 variables, only 60 variables contains actual data. The data for the rest of the fields were not available. As a result of this, I decided to use the variables containing data to be used for training purposes. The following command was used to extract out the releavant variables.


```r
var_pos = which(!is.na(testdat[1,]))
var_pos_1 = var_pos[-c(1:7)] # the first 7 variables were also discarded
train1 = training[,var_pos_1] # new training set
testing1 = testing[,var_pos_1] # new test set
actualTest = testdat[,var_pos_1] # new actual test set
```

Since 52 variables will take a long time to run, I decided to use principle component analysis to reduce the number of variables. From the "Human Activity Recognition", I found that they used 17 variables for their data training. So, I figured, 20 variables would be good enough. After, pre-processing, I used random forest for my training


```r
preProc = preProcess(train1[,-c(53)],method="pca",pcaComp=20)
trainPC = predict(preProc,train1[-c(53)])
modelFit1 = train(train1$classe~.,method="rf",data=trainPC)
```

Out of sample error
========================================================


```r
modelFit1
```


```r
Random Forest 

13737 samples
   19 predictors
    5 classes: 'A', 'B', 'C', 'D', 'E' 

No pre-processing
Resampling: Bootstrapped (25 reps) 

Summary of sample sizes: 13737, 13737, 13737, 13737, 13737, 13737, ... 

Resampling results across tuning parameters:

  mtry  Accuracy  Kappa  Accuracy SD  Kappa SD
  2     0.963     0.953  0.00353      0.00446 
  11    0.954     0.941  0.00398      0.00502 
  20    0.936     0.919  0.00642      0.0081  

Accuracy was used to select the optimal model using  the largest value.
The final value used for the model was mtry = 2. 
```

It can be seen that the model is suppose to provide an accuracy of 96.3% with a Kappa value of 0.953. The final model is as follows:


```r
modelFit1$finalModel
```

```r
Call:
 randomForest(x = x, y = y, mtry = param$mtry) 
               Type of random forest: classification
                     Number of trees: 500
No. of variables tried at each split: 2

        OOB estimate of  error rate: 2.37%

Confusion matrix:
     A    B    C    D    E class.error
A 3872   10   14    9    1 0.008704557
B   45 2576   32    1    4 0.030850263
C    5   34 2335   20    2 0.025459098
D    1    4   99 2141    7 0.049289520
E    0    9   19    9 2488 0.014653465
```

We then use this model to predict the 30% of the data left for prediction purpose.


```r
testPC = predict(preProc, testing1[-c(53)])
res = predict(modelFit1, testPC)
confusionMatrix(testing1$classe, res)
```


```r
Confusion Matrix and Statistics

          Reference
Prediction    A    B    C    D    E
         A 1658    6    5    5    0
         B   17 1095   23    2    2         
         C    2   13 1002    9    0         
         D    1    3   42  916    2         
         E    0    4   11    6 1061

Overall Statistics
                                          
               Accuracy : 0.974           
                 95% CI : (0.9696, 0.9779)
    No Information Rate : 0.2851          
    P-Value [Acc > NIR] : < 2.2e-16       
                                          
                  Kappa : 0.9671          
 Mcnemar's Test P-Value : NA              

Statistics by Class:
                     Class: A Class: B Class: C Class: D Class: E
Sensitivity            0.9881   0.9768   0.9252   0.9765   0.9962
Specificity            0.9962   0.9908   0.9950   0.9903   0.9956
Pos Pred Value         0.9904   0.9614   0.9766   0.9502   0.9806
Neg Pred Value         0.9953   0.9945   0.9833   0.9955   0.9992
Prevalence             0.2851   0.1905   0.1840   0.1594   0.1810
Detection Rate         0.2817   0.1861   0.1703   0.1556   0.1803
Detection Prevalence   0.2845   0.1935   0.1743   0.1638   0.1839
Balanced Accuracy      0.9921   0.9838   0.9601   0.9834   0.9959
```

As can be seen from the above, the model provide an accuracy of 97.4% on the testing data set. In addition, sensitivity, specificity and Kappa can also be found from the above table.

After training and testing, the model was used for the acutal testing data set


```r
testPC_a = predict(preProc, actualTest[-c(1,54)])
res_a = predict(modelFit1, testPC_a)
```
