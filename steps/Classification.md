#CLASSIFICATION MODELS 
To confirm that the classification models I have chosen, M5Prime, Random Forest, and Support Vector Machines will run correctly with my data I want to first create a sample size of 1000 random observations. I’m only going to do this for one building since all the data is set up the same, and what works on one building will work on the other two. 
```
> SAMPLEB0<-B0train[sample(1:nrow(B0train), 1000, replace =FALSE_),]
```

I then need to break this sample data into a train set and a test set, so I will first set the parameters for the train and test set size. 

```
> trainSize<-round(nrow(SAMPLEB0) * 0.7) 
> testSize<-round(nrow(SAMPLEB0)-trainSize) 
```

Then to ensure the train and test sets are randomly sampled a training indice will be created. 

```
> training_indices<-sample(seq_len(nrow(SAMPLEB0)), size = trainSize) 
```

And finally create the train and test sets. 

```
> SAMPLEB0train<-SAMPLEB0[training_indices, ]
> SAMPLEB0test<-SAMPLEB0[-training_indices, ]
```

A fitControl also needs to be set, and in this instance I will be using the 10-fold cross validation method. 10 fold cross-validation is a technique used to separate data into separate training and test sets and to accuarately predict how well the model prediction performed. 
```
> fitControl<-traincontrol(method="repeatedcv", number=10, repeats=10)
```

Finally, I can start running models on the sample train and test set for Building 0. I will be using the caret package to run these classification models. 
```
> FITB0M5P<-train(FLOORPOSITION~., data=SAMPLEB0train, method = “C5.0”, trControl = fitControl) 
> FITB0RF<-train(FLOORPOSITION~., data=SAMPLEB0train, method = “rf”, trControl = fitControl) 
> FITB0SVM<-train(FLOORPOSITION~., data=SAMPLEB0train, method = “svmPoly”, trControl = fitControl) 
```

And then use these trained models to predict on the set aside test set. 

```
> testPred0M5P<-predict(FITB0M5P, SAMPLEB0test) 
> testPred0RF<-predict(FITB0RF, SAMPLEB0test) 
> testPred0SVM<-predict(FITB0SVM, SAMPLEB0test) 
```

And then see how well the models performed by comparing the predicted values for FLOORPOSITION to the actual values in the test set, i.e. accuracy. 

```
> postResample(testPred0M5P, SAMPLEB0test$FLOORPOSITION) 
> postResample(testPred0RF, SAMPLEB0test$FLOORPOSITION) 
> postResample(testPred0SVM, SAMPLEB0test$FLOORPOSITION)
```

Then further examine the results by creating a confusion matrix. 
```
> confusionMatrix(testPred0M5P, SAMPLEB0test$FLOORPOSITION) 
> confusionMatrix(testPred0RF, SAMPLEB0test$FLOORPOSITION) 
> confusionMatrix(testPred0SVM, SAMPLEB0test$FLOORPOSITION) 
```
I can see that each model is running with no errors, completing in a timely manner, and with a relatively high accuracy rate (above 80%), so I know I can continue running these models on the full train and test sets. Using Building 1 as an example, I have detailed the code below. The steps will be the same for each building (0 & 2) 

Create the parameters for the train and test sets. 
```
> trainSize<-round(nrow(B1train) * 0.7) 
> testSize<-round(nrow(B1train) – trainSize) 
```
Create a training_indice for our full Building 1 data sets. 
```
> training_indices<-sample(seq_len(nrow(B1train)), size = trainSize) 
```
And finally create the train and test sets. 
```
> B1trainSet<-B1train[training_indices, ]
> B1testSet<-B1train[-training_indices, ]
```
A fit control is already set up, so no need to create that again. So now we can start running models. 
```
> FITB1M5P<-train(FLOORPOSITION~., data=B1trainSet, method = “C5.0”, trControl = fitControl) 
> FITB1RF<-train(FLOORPOSITION~., data= B1trainSet, method = “rf”, trControl = fitControl) 
> FITB1SVM<-train(FLOORPOSITION~., data= B1trainSet, method = “svmPoly”, trControl = fitControl) 
```
Once the models finished, I ran a confusionMatrix analysis. The accuracy results of each model per building are shown below: 

![ClassificationModelResults](https://github.com/chelswhite84/WiFi-Locationing/blob/master/image/ClassificationResults.png)


As seen above, Random Forest performed the best, which makes sense for an ensemble method. Ensemble methods combine multiple models into one unique mix, and usually results in more accuracy since the data is manipulated in a variety of ways. I then trained these well performing random forest models on the test sets to predict FLOORPOSITION. 
```
> B1Predict<-predict(FITB1RF, newdata=B1test, interval='confidence')
> write.csv(B1Predict, file="B1Prediction.csv")
```
The predicted values can now be used to fill in the missing data on the test set. In order to perfom the match up correctly, I broke my test data set into buildings since the results have been broken into seperate buildings. I matched up the new FLOORPOSITION values using Excel, and created a new column that can now be converted to the correct RELATIVEPOSITION based on the chart shown in [Pre-Processing] (https://github.com/chelswhite84/WiFi-Locationing/blob/master/steps/PreProcessing.md).

The updated Test file can be viewed in Google Drive [HERE] (https://docs.google.com/spreadsheets/d/1kZnxni9d_nop15feyvbiutFA-UE4dEv81iO-xPYIMUM/edit#gid=2019684365)

Continue to [Regression Models] (https://github.com/chelswhite84/WiFi-Locationing/blob/master/steps/Regression.md)

Back to [Pre-Processing] (https://github.com/chelswhite84/WiFi-Locationing/blob/master/steps/PreProcessing.md)

