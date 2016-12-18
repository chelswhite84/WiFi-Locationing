#PRE-PROCESSING
The UJIndoorLoc data is broken into a training set and a test set, both of which were loaded into R Studio for further examination. 

```
> train <-read.csv("~/Desktop/Data Analyst/trainingData.csv")
> test <-read.csv("~/Desktop/Data Analyst/validationData.csv")
```

I combined both data sets into one for pre-processing, so that any action performed on the training data will also performed on the test data. 

```
> combi<-rbind(train, test)
```

Looking at the attributes, there are 529 WAP readings, LATITUDE, LONGITUDE, BUILDINGID, FLOOR, SPACEID, RELATIVEPOSITION, USERID, PHONEID and TIMESTAMP. I can see that some feature selection is going to be needed. Since the last 3 attributes, USERID, PHONEID, and TIMESTAMP are unique user values that will not be helpful in determining a new user’s location, so they can be removed from the dataset. 

```
> combi$USERID<-NULL
> combi$PHONEID<-NULL
> combi$TIMESTAMP<-NULL
```

Additionally, when thinking about latitude and longitude, these readings cannot account for floor and are not accurate indoors since they rely on GPS. Therefore, these values were also removed from the dataset. 

```
> combi$LATITUDE<-NULL
> combi$LONGITUDE<-NULL
```

Next, I needed to determine what values do identify a user’s location and focused on the following variables: BUILDINGID and FLOOR followed by SPACEID to determine where on the floor the user is and finally RELATIVEPOSITION to know if the person is inside or outside the specified room or office. Reviewing the original test set confirms that SPACEID and RELATIVEPOSITION are the values to be predicted on since both these attributes have a value of 0 set, which traditionally indicates the predictive variable. 

There are a few ways to approach this problem including just classification, just regression, or a mix of both. These methods include combining BUILDINGID, FLOOR, SPACEID, and RELATIVEPOSITION into one unique variable, combining 3 of these variables to predict SPACEID, or 1st predicting RELATIVEPOSITION and using that new value to predict SPACEID. After reviewing the data, and trying a few options in Rattle, I determined a mix of both classification and regression should result in the most accurate user location. I will first use classification to determine RELATIVEPOSITION, and then regression models will be used to determine SPACEID. 

So, let’s start with predicting RELATIVRPOSITION using classification. In order to reduce the number of attributes that impact which RELATIVEPOSITION is predicted, I combined FLOOR and RELATIVEPSOITION into a unique variable called FLOORPOSITION. This results in 7-9 unique variables, which is ideal for classification problems.  

Equation used: FLOOR *4 + FLOOR + RELATIVEPOSITION

![FLOORPOSITION Chart](https://github.com/chelswhite84/WiFi-Locationing/blob/master/image/FLOORPOSITIONChart.png)
 
```
> combi$FLOORPOSITION<-NA
> combi$FLOORPOSITION<-((combi$FLOOR*4) + combi$FLOOR + combi$RELATIVEPOSITION) 
```

To reduce the number of unnecessary attributes I removed FLOOR and RELATIVEPOSITION. Additionally, I removed SPACEID since this is also an attribute that needs to be predicted upon, but that is being saved for part two of the model prediction process. 

```
> combi$FLOOR<-NULL
> combi$RELATIVEPOSITION<-NULL
> combi$SPACEID <-NULL
```

The attribute FLOORPOSITION also needs to be converted into a factor since this is a classification problem. 

```
> combi$FLOORPOSITION<-as.factor(combi$FLOORPOSITION)
```

The data is now ready to be broken out into the original, but altered train and test sets. 

```
> train <-combi[1:19937,]
> test <- combi[19938:21048,]
```

The data is currently left with the 520 WAP measurements, BUILDINGID, and the new attribute FLOORPOSITION. To further reduce the number of attributes, I separated the data by building number (0,1,2), which results in 3 different train data sets and 3 different test data sets. 
```
> B0train<-train[train$BUILDINGID == 0,]
> B1train<-train[train$BUILDINGID == 1,]
> B2train<-train[train$BUILDINGID == 2,]
> B0test<-test[test$BUILDINGID == 0,]
> B1test<-test[test$BUILDINGID == 1,]
> B2test<-test[test$BUILDINGID == 2,]
```

The attribute BUILDINGID can now be removed, since each test set represents a building and this value is no longer needed in the data since it is redundant. 

```
> B0train$BUILDINGID<-NULL
> B1train$BUILDINGID<-NULL
> B2train$BUILDINGID<-NULL
> B0test$BUILDINGID<-NULL
> B1test$BUILDINGID<-NULL
> B2test$BUILDINGID<-NULL
```

The data is now ready for model building!!! The attributes left in the train and test data has been reduced to 520 WAP readings and FLOORPOSITION, which is ideal for model building since you want to limit the data to the fewest number of actionable attributes. This usually results in the best model since what is being predicted upon, and what effects that prediction is clear. 

Continue to [Classification Models] (https://github.com/chelswhite84/WiFi-Locationing/blob/master/steps/Classification.md)

Back to [About the Data] (https://github.com/chelswhite84/WiFi-Locationing/blob/master/steps/AboutTheData.md)

