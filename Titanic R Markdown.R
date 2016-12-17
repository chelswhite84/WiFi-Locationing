#Titanic data
#set working directory and import data filesststr(train)
setwd("~/Desktop/Titanic DataSets")
set.seed(99)
test <- read.csv("~/Desktop/Titanic DataSets/Titanictest.csv")
train <- read.csv("~/Desktop/Titanic DataSets/Titanictrain.csv")
#View Survival Statistics + Add Survived Column to Test Set 
train$Survived
table(train$Survived)
prop.table(table(train$Survived))
test$Survived<-rep(0,418)
#Create Submission file for Kaggle 
submit<-data.frame(PassengerID=test$PassengerId, Survived = test$Survived)
write.csv(submit, file="theyallparish.csv", row.names=FALSE)

#Looking at Women/Children as survival predictor 
set.seed(99)
test <- read.csv("~/Desktop/Titanic DataSets/Titanictest.csv")
train <- read.csv("~/Desktop/Titanic DataSets/Titanictrain.csv")
summary(train$Sex)
prop.table(table(train$Sex, train$Survived),1)
#create Survived in Test and make Females Survive = 1
test$Survived<-0
test$Survived[test$Sex == 'female']<-1
submit<-data.frame(PassengerID=test$PassengerId, Survived = test$Survived)
write.csv(submit, file="womenlive.csv", row.names=FALSE)
#create Child row, 1 = anyone less than 18 
summary(train$Age)
train$Child<-0
train$Child[train$Age<18]<-1 
#proportions of children survived by Sex 
aggregate(Survived ~ Child + Sex, data=train, FUN=sum)
aggregate(Survived ~ Child + Sex, data=train, FUN=length)
aggregate(Survived ~ Child + Sex, data=train, FUN=function(x) {sum(x)/length(x)})
#found male children still more likely to not survive, move on to other factors 
# examine Class + put Fair into buckets 
train$Fare2<-"30+"
train$Fare2[train$Fare < 30 & train$Fare >= 20] <- '20-30'
train$Fare2[train$Fare < 20 & train$Fare >=10] <-'10-20'
train$Fare2[train$Fare < 10] <- '10'
aggregate(Survived ~ Fare2 + Pclass + Sex, data=train, FUN=function(x) {sum(x)/length(x)})
#found that women in 3rd class that paid $20+ for their ticket more likely to not survive 
test$Survived<-0
test$Survived[test$Sex == 'female']<-1
test$Survived[test$Sex =='female' & test$Pclass== 3 & test$Fare>=20]<-0
submit<-data.frame(PassengerID=test$PassengerId, Survived = test$Survived)
write.csv(submit, file="womenin3don'tlive.csv", row.names=FALSE)

#Decision Tree 
test <- read.csv("~/Desktop/Titanic DataSets/Titanictest.csv")
train <- read.csv("~/Desktop/Titanic DataSets/Titanictrain.csv")
library(rpart)
fit<-rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=train, method = 'class')
plot(fit)
text(fit)
library(rattle)
library(rpart.plot)
library(RColorBrewer)
fancyRpartPlot(fit)
Prediction<-predict(fit, test, type ='class')
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
write.csv(submit, file = "myfirstdtree.csv", row.names = FALSE)
#Open up the parameters of the tree - take off limits 
fit<-rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=train, method = 'class', control=rpart.control(minsplit=2, cp=0))
fancyRpartPlot(fit)


#Feature Selection 
test <- read.csv("~/Desktop/Titanic DataSets/Titanictest.csv")
train <- read.csv("~/Desktop/Titanic DataSets/Titanictrain.csv")
#Name 
train$Name[1]
#various titles in names like Master, Countess, Mr, Mistress -> extract these values 
test$Survived<-NA 
combi<-rbind(train, test) 
#This creates a new data set with all rows combined. Train 1st then Test 
combi$Name<-as.character(combi$Name)
#build formula to take out Title
combi$Name[1]
strsplit(combi$Name[1], split='[,.]')
strsplit(combi$Name[1], split='[,.]')[[1]]
strsplit(combi$Name[1], split='[,.]')[[1]][2]
#apply this formula to all names 
combi$Title<-sapply(combi$Name, FUN=function(x) {strsplit(x, split='[,.]') [[1]][2]})
#remove the space from the beginning of Title 
combi$Title<-sub(' ', '', combi$Title)
table(combi$Title)
#combining titles that go together (%in% checks if the value is part of the vector)
combi$Title[combi$Title %in% c('Mme', 'Mlle')] <- 'Mlle'
combi$Title[combi$Title %in% c('Capt', 'Sir', 'Don', 'Major')] <-'Sir'
combi$Title[combi$Title %in% c('Dona', 'Lady', 'Jonkheer', 'the Countess')] <-'Lady'
combi$Title<-factor(combi$Title)
#combine SibSp and Parch into new variable, FamilySize 
combi$FamilySize <- combi$SibSp + combi$Parch + 1
table(combi$FamilySize)
#pull out Surname (last name) 
combi$Surname<-sapply(combi$Name, FUN=function(x) {strsplit(x, split='[,.]') [[1]][1]})
#combine Family Size and Surname into FamilyID (need to make family size into string temporarily)
combi$FamilyID<-paste(as.character(combi$FamilySize), (combi$Surname), sep = "")
table(combi$FamilyID)
#any family with less than 2 is "Small"
combi$FamilyID[combi$FamilySize <=2] <-'Small'
#some less than or = to 2 families are still listed, so create a data frame to only show FamilyID 
famIDs <-data.frame(table(combi$FamilyID))
#change FamID data table to only have those identified as small
famIDs <-famIDs[famIDs$Freq<=2,]
#update combined data frame to call families in famID Small 
combi$FamilyID[combi$FamilyID %in% famIDs$Var1] <- 'Small'
combi$FamilyID<-as.factor(combi$FamilyID)
#break data back out into train and test set (comma at end means to take all the columns)
train<-combi[1:891,]
test<-combi[892:1309,]
#train model
library(rattle)
library(rpart.plot)
library(RColorBrewer)
fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID, data=train, method = "class")
fancyRpartPlot(fit)
Prediction<-predict(fit, test, type ='class')
submit <- data.frame(PassengerId = train$PassengerId, Survived = Prediction)
write.csv(submit, file = "featureselection.csv", row.names = FALSE)

#Random Forest 
#using data set from last feature selection 
#need to fill in missling age data - NAs - use decision tree. anova predicts continuous variable
summary(combi$Age)
Agefit<-rpart(Age ~ Pclass + Sex + SibSp + Parch + Fare + Embarked + Title + FamilySize, data = combi[!is.na(combi$Age),], method="anova")
combi$Age[is.na(combi$Age)] <- predict(Agefit, combi[is.na(combi$Age),])
summary(combi)
#Embarked and Fare are missing values 
which(combi$Embarked == '')
combi$Embarked[c(62,830)] = "S"
combi$Embarked<-factor(combi$Embarked)
summary(combi$Fare)
which(is.na(combi$Fare))
combi$Fare[1044]<-median(combi$Fare, na.rm = TRUE)
#too many variables in FamilyID (randomforest only likes 32 or less variables)
#change small to inclue 2 and 3 family size as well 
combi$FamilyID2<-combi$FamilyID 
combi$FamilyID2<-as.character(combi$FamilyID2) 
combi$FamilyID2[combi$FamilySize <=3] <- 'Small'
combi$FamilyID2<-as.factor(combi$FamilyID2)
table(combi$FamilyID2)
#test and train sets 
train<-combi[1:891,]
test<-combi[892:1309,]
library('randomForest')
set.seed(199)
fit<-randomForest(as.factor(Survived) ~ Pclass + Sex + Age + Fare + Embarked + FamilyID2 + SibSp + Parch + Title + FamilySize, data = train, importance = TRUE, ntree=2000)
varImpPlot(fit)
prediction<-predict(fit, test)
submit<-data.frame(PassengerID=test$PassengerId, Survived=prediction)
write.csv(submit, file = "firstforest.csv", row.names = FALSE)
install.packages('party')
library('party')
set.seed(199)
fit<-cforest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID, data=train, control=cforest_unbiased(ntree=2000, mtry=3))
Prediction<-predict(fit, test, OOB=TRUE, type = 'response')
submit<-data.frame(PassengerID=test$PassengerId, Survived=Prediction)
write.csv(submit, file = "secondforest.csv", row.names = FALSE)
