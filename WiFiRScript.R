set.seed(199)
library(caret)
train <-read.csv("~/Desktop/Data Analyst/trainingData.csv")
test <-read.csv("~/Desktop/Data Analyst/validationData.csv")
combi<-rbind(train, test)
combi$USERID<-NULL
combi$PHONEID<-NULL
combi$TIMESTAMP<-NULL
combi$LATITUDE<-NULL
combi$LONGITUDE<-NULL
combi$FLOORPOSITION<-c(NA)
combi$FLOORPOSITION<-(combi$RELATIVEPOSITION*3+combi$FLOOR+combi$RELATIVEPOSITION) 
combi$FLOOR<-NULL
combi$RELATIVEPOSITION<-NULL
combi$SPACEID <-NULL
combi$FLOORPOSITION<-as.character(combi$FLOORPOSITION)
train <-combi[1:19937,]
test <- combi[19938:21048,]
B0train<-train[train$BUILDINGID == 0,]
B1train<-train[train$BUILDINGID == 1,]
B2train<-train[train$BUILDINGID == 2,]
B0test<-test[test$BUILDINGID == 0,]
B1test<-test[test$BUILDINGID == 1,]
B2test<-test[test$BUILDINGID == 2,]
B0train$BUILDINGID<-NULL
B1train$BUILDINGID<-NULL
B2train$BUILDINGID<-NULL
B0test$BUILDINGID<-NULL
B1test$BUILDINGID<-NULL
B2test$BUILDINGID<-NULL

SAMPLEB0<-B0train[sample(1:nrow(B0train),1000, replace = FALSE),]
trainSize<-round(nrow(SAMPLEB0) * 0.7)
testSize<-round(nrow(SAMPLEB0) - trainSize) 
training_indices<-sample(seq_len(nrow(SAMPLEB0)), size = trainSize) 
SAMPLEB0train<-SAMPLEB0[training_indices, ]
SAMPLEB0test<-SAMPLEB0[-training_indices, ]
fitControl<-trainControl(method="repeatedcv", number=10, repeats=10)
FITB0M5P<-train(FLOORPOSITION~., data=SAMPLEB0train, method="C5.0", trControl = fitControl) 
FITB0RF<-train(FLOORPOSITION~., data=SAMPLEB0train, method="rf", trControl = fitControl) 
FITB0SVM<-train(FLOORPOSITION~., data=SAMPLEB0train, method="svmPoly", trControl = fitControl) 
testPred0M5P<-predict(FITB0M5P, SAMPLEB0test) 
testPred0RF<-predict(FITB0RF, SAMPLEB0test) 
testPred0SVM<-predict(FITB0SVM, SAMPLEB0test) 
confusionMatrix(testPred0M5P, SAMPLEB0test$FLOORPOSITION) 
confusionMatrix(testPred0RF, SAMPLEB0test$FLOORPOSITION) 
confusionMatrix(testPred0SVM, SAMPLEB0test$FLOORPOSITION)

trainSize<-round(nrow(B0train) * 0.7)
testSize<-round(nrow(B0test) - trainSize) 
training_indices<-sample(seq_len(nrow(B0train)), size = trainSize) 
B0trainSet<-B0train[training_indices, ]
B0testSet<-B0train[-training_indices, ]
fitControl<-trainControl(method="repeatedcv", number=10, repeats=10)
FITB0M5P<-train(FLOORPOSITION~., data=B0trainSet, method="C5.0", trControl = fitControl) 
FITB0RF<-train(FLOORPOSITION~., data=B0trainSet, method="rf", trControl = fitControl) 
FITB0SVM<-train(FLOORPOSITION~., data=B0trainSet, method="svmPoly", trControl = fitControl) 
testPred0M5P<-predict(FITB0M5P, B0testSet) 
testPred0RF<-predict(FITB0RF, B0testSet) 
testPred0SVM<-predict(FITB0SVM, B0testSet) 
confusionMatrix(testPred0M5P, B0testSet$FLOORPOSITION) 
confusionMatrix(testPred0RF, B0testSet$FLOORPOSITION) 
confusionMatrix(testPred0SVM, B0testSet$FLOORPOSITION)

trainSize<-round(nrow(B1train) * 0.7)
testSize<-round(nrow(B1test) - trainSize) 
training_indices<-sample(seq_len(nrow(B1train)), size = trainSize) 
B1trainSet<-B1train[training_indices, ]
B1testSet<-B1train[-training_indices, ]
fitControl<-trainControl(method="repeatedcv", number=10, repeats=10)
FITB1M5P<-train(FLOORPOSITION~., data=B1trainSet, method="C5.0", trControl = fitControl) 
FITB1RF<-train(FLOORPOSITION~., data=B1trainSet, method="rf", trControl = fitControl) 
FITB1SVM<-train(FLOORPOSITION~., data=B1trainSet, method="svmPoly", trControl = fitControl) 
testPred1M5P<-predict(FITB1M5P, B1testSet) 
testPred1RF<-predict(FITB1RF, B1testSet) 
testPred1SVM<-predict(FITB1SVM, B1testSet) 
confusionMatrix(testPred1M5P, B1testSet$FLOORPOSITION) 
confusionMatrix(testPred1RF, B1testSet$FLOORPOSITION) 
confusionMatrix(testPred1SVM, B1testSet$FLOORPOSITION)

trainSize<-round(nrow(B2train) * 0.7)
testSize<-round(nrow(B2test) - trainSize) 
training_indices<-sample(seq_len(nrow(B2train)), size = trainSize) 
B2trainSet<-B2train[training_indices, ]
B2testSet<-B2train[-training_indices, ]
fitControl<-trainControl(method="repeatedcv", number=10, repeats=10)
FITB2M5P<-train(FLOORPOSITION~., data=B2trainSet, method="C5.0", trControl = fitControl) 
FITB2RF<-train(FLOORPOSITION~., data=B2trainSet, method="rf", trControl = fitControl) 
FITB2SVM<-train(FLOORPOSITION~., data=B2trainSet, method="svmPoly", trControl = fitControl) 
testPred2M5P<-predict(FITB2M5P, B2testSet) 
testPred2RF<-predict(FITB2RF, B2testSet) 
testPred2SVM<-predict(FITB2SVM, B2testSet) 
confusionMatrix(testPred2M5P, B2testSet$FLOORPOSITION) 
confusionMatrix(testPred2RF, B2testSet$FLOORPOSITION) 
confusionMatrix(testPred0SVM, B0testSet$FLOORPOSITION)

B0Predict<-predict(FITB0RF, newdata=B0test, interval='confidence')
write.csv(B0Predict, file="B0Prediction12_24.csv")
B1Predict<-predict(FITB1RF, newdata=B1test, interval='confidence')
write.csv(B1Predict, file="B1Prediction12_24.csv")
B2Predict<-predict(FITB2RF, newdata=B2test, interval='confidence')
write.csv(B2Predict, file="B2Prediction12_24.csv")

set.seed(199)
library(caret)
train <-read.csv("~/Desktop/Data Analyst/trainingData.csv")
test <-read.csv("~/Desktop/Data Analyst/validationData.csv")
train$USERID<-NULL
test$USERID<-NULL
train$PHONEID<-NULL
test$PHONEID<-NULL
train$TIMESTAMP<-NULL
test$TIMESTAMP<-NULL
train$LATITUDE<-NULL
test$LATITUDE<-NULL
train$LONGITUDE<-NULL
test$LONGITUDE<-NULL
train$FLOORPOSITION<-c(NA)
train$FLOORPOSITION<-(train$RELATIVEPOSITION*3+train$FLOOR+train$RELATIVEPOSITION) 
train$FLOOR<-NULL
test$FLOOR<-NULL
train$RELATIVEPOSITION<-NULL
test$RELATIVEPOSITION<-NULL
B0train<-train[train$BUILDINGID == 0,]
B1train<-train[train$BUILDINGID == 1,]
B2train<-train[train$BUILDINGID == 2,]
B0test<-test[test$BUILDINGID == 0,]
B1test<-test[test$BUILDINGID == 1,]
B2test<-test[test$BUILDINGID == 2,]
B0train$BUILDINGID<-NULL
B1train$BUILDINGID<-NULL
B2train$BUILDINGID<-NULL
B0test$BUILDINGID<-NULL
B1test$BUILDINGID<-NULL
B2test$BUILDINGID<-NULL
B0train$FLOORPOSITION<-as.numeric(B0train$FLOORPOSITION)
B0test$FLOORPOSITION<-as.numeric(B0test$FLOORPOSITION)
B0train$SPACEID<-as.numeric(B0train$SPACEID)
B0test$SPACEID<-as.numeric(B0test$SPACEID)
B1train$FLOORPOSITION<-as.numeric(B1train$FLOORPOSITION)
B1test$FLOORPOSITION<-as.numeric(B1test$FLOORPOSITION)
B1train$SPACEID<-as.numeric(B1train$SPACEID)
B1test$SPACEID<-as.numeric(B1test$SPACEID)
B2train$FLOORPOSITION<-as.numeric(B2train$FLOORPOSITION)
B2test$FLOORPOSITION<-as.numeric(B2test$FLOORPOSITION)
B2train$SPACEID<-as.numeric(B2train$SPACEID)
B2test$SPACEID<-as.numeric(B2test$SPACEID)


SAMPLEB0<-B0train[sample(1:nrow(B0train),1000, replace = FALSE),]
trainSize<-round(nrow(SAMPLEB0) * 0.7)
testSize<-round(nrow(SAMPLEB0) - trainSize) 
training_indices<-sample(seq_len(nrow(SAMPLEB0)), size = trainSize) 
SAMPLEB0train<-SAMPLEB0[training_indices, ]
SAMPLEB0test<-SAMPLEB0[-training_indices, ]
fitControl<-trainControl(method="repeatedcv", number=10, repeats=10)
FITB0RF<-train(SPACEID~., data=SAMPLEB0train, method="rf", trControl = fitControl) 
FITB0CUB<-train(SPACEID~., data=SAMPLEB0train, method="cubist", trControl = fitControl) 
FITB0BOOST<-train(SPACEID~., data=SAMPLEB0train, method="blackboost", trControl = fitControl) 
testPred0RF<-predict(FITB0RF, SAMPLEB0test) 
testPred0CUB<-predict(FITB0CUB, SAMPLEB0test) 
testPred0BOOST<-predict(FITB0BOOST, SAMPLEB0test) 
postResample(testPred0RF, SAMPLEB0test$SPACEID) 
postResample(testPred0CUB, SAMPLEB0test$SPACEID) 
postResample(testPred0BOOST, SAMPLEB0test$SPACEID)

trainSize<-round(nrow(B0train) * 0.7)
testSize<-round(nrow(B0test) - trainSize) 
training_indices<-sample(seq_len(nrow(B0train)), size = trainSize) 
B0trainSet<-B0train[training_indices, ]
B0testSet<-B0train[-training_indices, ]
fitControl<-trainControl(method="repeatedcv", number=10, repeats=10)
FITB0RF<-train(SPACEID~., data=B0trainSet, method="rf", trControl = fitControl) 
FITB0CUB<-train(SPACEID~., data=B0trainSet, method="cubist", trControl = fitControl) 
FITB0BOOST<-train(SPACEID~., data=B0trainSet, method="blackboost", trControl = fitControl) 
testPred0RF<-predict(FITB0MRF, B0testSet) 
testPred0CUB<-predict(FITB0CUB, B0testSet) 
testPred0BOOST<-predict(FITB0BOOST, B0testSet) 
postResample(testPred0RF, B0testSet$SPACEID) 
postResample(testPred0CUB, B0testSet$SPACEID) 
postResample(testPred0BOOST, B0testSet$SPACEID)


trainSize<-round(nrow(B1train) * 0.7)
testSize<-round(nrow(B1test) - trainSize) 
training_indices<-sample(seq_len(nrow(B1train)), size = trainSize) 
B1trainSet<-B1train[training_indices, ]
B1testSet<-B1train[-training_indices, ]
fitControl<-trainControl(method="repeatedcv", number=10, repeats=10)
FITB1RF<-train(SPACEID~., data=B1trainSet, method="rf", trControl = fitControl) 
FITB1CUB<-train(SPACEID~., data=B1trainSet, method="cubist", trControl = fitControl) 
FITB1BOOST<-train(SPACEID~., data=B1trainSet, method="blackboost", trControl = fitControl) 
testPred1RF<-predict(FITB1RF, B1testSet) 
testPred1CUB<-predict(FITB1CUB, B1testSet) 
testPred1BOOST<-predict(FITB1BOOST, B1testSet) 
postResample(testPred1RF, B1testSet$SPACEID) 
postResample(testPred1CUB, B1testSet$SPACEID) 
postResample(testPred1BOOST, B1testSet$SPACEID)

trainSize<-round(nrow(B2train) * 0.7)
testSize<-round(nrow(B2test) - trainSize) 
training_indices<-sample(seq_len(nrow(B2train)), size = trainSize) 
B2trainSet<-B2train[training_indices, ]
B2testSet<-B2train[-training_indices, ]
fitControl<-trainControl(method="repeatedcv", number=10, repeats=10)
FITB2RF<-train(SPACEID~., data=B2trainSet, method="rf", trControl = fitControl) 
FITB2CUB<-train(SPACEID~., data=B2trainSet, method="cubist", trControl = fitControl) 
FITB2BOOST<-train(SPACEID~., data=B2trainSet, method="blackboost", trControl = fitControl) 
testPred2RF<-predict(FITB2MRF, B2testSet) 
testPred2CUB<-predict(FITB2CUB, B2testSet) 
testPred2BOOST<-predict(FITB2BOOST, B2testSet) 
postResample(testPred2RF, B2testSet$SPACEID) 
postResample(testPred2CUB, B2testSet$SPACEID) 
postResample(testPred2BOOST, B2testSet$SPACEID)

B0Predict<-predict(FITB0CUB, newdata=B0test, interval='confidence')
write.csv(B0Predict, file="B0SIPrediction.csv")
B1Predict<-predict(FITB1CUB, newdata=B1test, interval='confidence')
write.csv(B1Predict, file="B1SIPrediction.csv")
B2Predict<-predict(FITB2CUB, newdata=B2test, interval='confidence')
write.csv(B2Predict, file="B2SIPrediction.csv")




