#REGRESSION MODELS
Now that RELATIVEPOSITION has been predicted, the next step is to predict SPACEID. Looking at the data, SPACEID has 78-96 different variables depending on building number, so regression will show much better results than classification, since these models typically perform well with a much smaller number of differing variables. 

A lot of the pre-processing steps detailed above will need to happen again. The biggest thing to remember is to update the original test file with the new predicted values for FLOORPOSITION, since these values will be used to predict SPACEID. Without going through all the steps again at length, the train and test sets should be uploaded, do not combine the two data sets into one, since FLOORPOSITION is already on the test set, but not included in the training data. Unnecessary columns can be removed (keep FLOORPOSITION and SPACEID), and this time FLOORPOSITION and SPACEID need to be converted to numerical values instead of factor, as was done in the classification process. The data needs to again be separated by building, and then remove BUILDINIGID from the test and train sets. The attributes left in the data set now includes 520 WAP readings as well as FLOORPOSITION and SPACEID. 

First, I took a sample of 1000, as I did with the classification models, to see if my chosen regression models, Random Forest, Cubist, and Blackboost had an acceptable performance on the data and that there were no errors. Once this was complete, I took the full training set and started running models. Using Building 1 as an example, I have outlined the R code for the chosen regression models below. 
```
> FITB1RF<-train(FLOORPOSITION~., data=B1trainSet, method = “rf”, trControl = fitControl) 
> FITB1CUB<-train(FLOORPOSITION~., data= B1trainSet, method = “cubist”, trControl = fitControl) 
> FITB1BOOST<-train(FLOORPOSITION~., data= B1trainSet, method = “blackboost”, trControl = fitControl) 
```
Since this is a regression problem, instead of an accuracy rate, the model performance can be compared using r-squared values. Again, I'll pull the postResample results. As shown in the table below, the Cubist model performed the best across all buildings, so will be used to predict SPACEID on the set aside test set. 

![Regression Model Results] (https://github.com/chelswhite84/WiFi-Locationing/blob/master/image/RSquaredRegression.png)

![Regression Model Chart] (https://github.com/chelswhite84/WiFi-Locationing/blob/master/image/RegressionChart.png)

The final step is to use our chosen model, the Cubist fit in this case, and predict SPACEID on the test data. 
```
> B1Predict<-predict(FITB1CUB, newdata=B1test, interval='confidence')
> write.csv(B1Predict, file="B1Prediction.csv")
```
The predicted values can now be used to fill in the missing SPACEID data on the test set. I did this step using Excel, and the data file can be found here (link to data file). 

Continue to [Final Thoughts] (https://github.com/chelswhite84/WiFi-Locationing/blob/master/steps/FinalThoughts.md)

Back to [Classification Models] (https://github.com/chelswhite84/WiFi-Locationing/blob/master/steps/Classification.md)
