## ----include=FALSE-------------------------------------------------------------------------------------------------------------
wine <- read.csv("dataset/winequality-red_train.csv")
wine <- wine[2:13]
N<-dim(wine)[1]
wine_validation <- read.csv("dataset/winequality-red_validation.csv")
wine_validation <- wine_validation[2:13]
N_V<-dim(wine_validation)[1]


## ----echo=FALSE, message=FALSE, warning=FALSE----------------------------------------------------------------------------------
library("devtools")
library("papeR")
summarize(wine, type = "numeric")


## ----echo=FALSE, message=FALSE, warning=FALSE----------------------------------------------------------------------------------
library(gridExtra)
library(ggplot2)
draw_hist <- function(variable, name)
{
  plot <- ggplot(data = wine, aes(x = variable)) + 
           geom_histogram(aes(y=..density..), color = 'black', fill = '#099DD9',bins=10) +
           xlab(deparse(substitute(name))) + geom_density(alpha=.3, colour = 'red') 
  return(plot)
}
grid.arrange(draw_hist(wine$fixed.acidity, FixedAcidity),
             draw_hist(wine$volatile.acidity, VolatileAcidity),
             draw_hist(wine$citric.acid, CitricAcid),
             draw_hist(wine$residual.sugar, ResidualSugar),
             draw_hist(wine$chlorides, Chlorides),
             draw_hist(wine$free.sulfur.dioxide, FreeSulfurDioxide),
             draw_hist(wine$total.sulfur.dioxide, TotalSulfurDioxide),
             draw_hist(wine$density, Density),
             draw_hist(wine$pH, pH),
             draw_hist(wine$sulphates, Sulphates),
             draw_hist(wine$alcohol, Alcohol),
             ncol = 3)



## ----include=FALSE-------------------------------------------------------------------------------------------------------------
wine$high.quality <- factor (as.integer(wine$quality>6))
wine_validation$high.quality <- factor (as.integer(wine_validation$quality>6))


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
draw_box <- function(variable, name)
{
  plot <- ggplot(data = wine, aes(x = high.quality, y = variable, color = high.quality)) +
  geom_boxplot() +
           xlab(deparse(substitute(name)))
  return(plot)
}
grid.arrange(draw_box(wine$fixed.acidity, FixedAcidity),
             draw_box(wine$volatile.acidity, VolatileAcidity),
             draw_box(wine$citric.acid,CitricAcid),
             draw_box(wine$residual.sugar,ResidualSugar),
             ncol = 2)



## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
grid.arrange(draw_box(wine$chlorides, Chlorides),
             draw_box(wine$free.sulfur.dioxide, FreeSulfurDioxide),
             draw_box(wine$total.sulfur.dioxide, TotalSulfurDioxide),
             draw_box(wine$density,Density),
             ncol = 2)


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
grid.arrange(draw_box(wine$pH, pH),
             draw_box(wine$sulphates, Sulphates),
             draw_box(wine$alcohol, Alcohol),
             draw_box(wine$quality, Quality),
             ncol = 2)



## ----echo=FALSE, message=FALSE, warning=FALSE----------------------------------------------------------------------------------
library(psych)
pairs.panels(wine[c(1:4, 12)], main="Relationships between characteristics of wine factors",
pch=20,
col="blue",
)


## ----echo=FALSE, message=FALSE, warning=FALSE----------------------------------------------------------------------------------
pairs.panels(wine[c(4:7, 12)], main="Relationships between characteristics of wine factors",
pch=20,
col="blue",
)


## ----echo=FALSE, message=FALSE, warning=FALSE----------------------------------------------------------------------------------
pairs.panels(wine[8:12], main="Relationships between characteristics of wine factors",
pch=20,
col="blue",
)


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
library(corrplot)
correlation1<-cor(wine[1:11])

 col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))

corrplot(correlation1,

         method="shade", # visualisation method

         shade.col=NA, # colour of shade line

         tl.col="black", # colour of text label

         tl.srt=45, # text label rotation

         col=col(200), # colour of glyphs

         addCoef.col="black", # colour of coefficients

         order="AOE", # ordering method

         number.cex=0.7

)




## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
wine <- wine[-c(12)]
wine_validation <- wine_validation[-c(12)]


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
glm.fit <- glm(high.quality~.,family = binomial,data = wine)
summary(glm.fit, digits=3)

## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
glm.fit1 <- glm(high.quality~.-citric.acid, family = binomial,data = wine)
summary(glm.fit1, digits=3)

## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
glm.fit2 <- glm(
  high.quality~.-citric.acid-free.sulfur.dioxide, family = binomial,data = wine
  )
summary(glm.fit2, digits=3)

## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
glm.fit3 <- glm(
  high.quality~.
  -citric.acid-free.sulfur.dioxide-pH, family = binomial,data = wine
  )
summary(glm.fit3, digits=3)


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
glm.probs=predict.glm(glm.fit3,type="response")
glm.pred=rep("No",N)
glm.pred[glm.probs>.5]="Yes" 
confMat<-addmargins(table(glm.pred,wine$high.quality))
confMat 
delta=(confMat[1,2]+confMat[2,1])/N*100 
delta


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
glm.probs=predict.glm(glm.fit3, newdata = wine_validation, type="response")
glm.pred=rep("No",N_V)
glm.pred[glm.probs>.5]="Yes" 
confMat<-addmargins(table(glm.pred,wine_validation$high.quality))
confMat 
delta=(confMat[1,2]+confMat[2,1])/N_V*100 
delta


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
library(MASS)
library(caret)
library(lattice)
lda.fit=lda(high.quality~.-citric.acid-free.sulfur.dioxide-pH, data = wine)
lda.fit


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
lda.predict=predict(lda.fit,wine)
pred.class=lda.predict$class
confMat.LDA<-confusionMatrix(pred.class,wine$high.quality)$table
confMat.LDA
delta.LDA=(confMat.LDA[1,2]+confMat.LDA[2,1])/N*100 
delta.LDA


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
lda.predict=predict(lda.fit,wine_validation)
pred.class=lda.predict$class
confMat.LDA<-confusionMatrix(pred.class,wine_validation$high.quality)$table
confMat.LDA
delta.LDA=(confMat.LDA[1,2]+confMat.LDA[2,1])/N_V*100 
delta.LDA


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
qda.fit=qda(high.quality~.-citric.acid-free.sulfur.dioxide-pH,data=wine)
qda.fit


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
qda.predict=predict(qda.fit,wine)
pred.class=qda.predict$class
confMat.QDA<-confusionMatrix(pred.class,wine$high.quality)$table
confMat.QDA
delta.QDA=(confMat.QDA[1,2]+confMat.QDA[2,1])/N*100 
delta.QDA


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
qda.predict=predict(qda.fit,wine_validation)
pred.class=qda.predict$class
confMat.QDA<-confusionMatrix(pred.class,wine_validation$high.quality)$table
confMat.QDA
delta.QDA=(confMat.QDA[1,2]+confMat.QDA[2,1])/N_V*100 
delta.QDA


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
library(tree)
setup<-tree.control(nrow(wine), mincut = 5, minsize = 10, mindev = 0.015)
tree.fit = tree(high.quality ~.-citric.acid-free.sulfur.dioxide-pH, data=wine, control = setup) 
summary(tree.fit)

## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
plot(tree.fit, type="uniform")
text(tree.fit,col="blue")


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
tree.predict=predict(tree.fit,wine, type='class')
confMat.tree<-confusionMatrix(tree.predict,wine$high.quality)$table
confMat.tree
delta.tree=(confMat.tree[1,2]+confMat.tree[2,1])/N*100 
delta.tree


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
tree.predict=predict(tree.fit,wine_validation, type='class')
confMat.tree<-confusionMatrix(tree.predict,wine_validation$high.quality)$table
confMat.tree
delta.tree=(confMat.tree[1,2]+confMat.tree[2,1])/N_V*100 
delta.tree


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
library(randomForest)
rand.wine=randomForest(
high.quality~ alcohol + sulphates + total.sulfur.dioxide + fixed.acidity + volatile.acidity ,data=wine,mtry=2,importance=TRUE)
rand.wine


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
confMat.forest <- rand.wine$confusion
confMat.forest
delta.tree=(confMat.forest[1,2]+confMat.forest[2,1])/N*100 
delta.tree


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
forest.predict=predict(rand.wine,wine_validation, type='class')
confMat.forest<-confusionMatrix(forest.predict,wine_validation$high.quality)$table
confMat.forest
delta.tree=(confMat.tree[1,2]+confMat.tree[2,1])/N_V*100 
delta


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
varImpPlot(rand.wine, col="blue", main="Wine data")


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
library(neuralnet)
wine$high.quality <- as.numeric(as.character(wine$high.quality))
nn = neuralnet(
  high.quality~high.quality~ alcohol + sulphates + total.sulfur.dioxide + fixed.acidity + volatile.acidity, 
  data=wine,
  hidden =5,
  stepmax = 1e+06,
  linear.output = F
  )
summary(nn)

## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
plot(nn)


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
imin_rep=which.min(nn$result.matrix[1,])
yhat = round(nn$net.result[[imin_rep]])
ConfMat=addmargins(table(wine$high.quality,yhat))
ConfMat
delta=(ConfMat[1,2]+ConfMat[2,1])/N*100
delta


## ------------------------------------------------------------------------------------------------------------------------------
pr.nn <- predict(nn,wine_validation, rep=imin_rep)
yhat_val = round(pr.nn)
ConfMat_val=addmargins(table(wine_validation$high.quality,yhat_val))
ConfMat_val
accuracy_val=(ConfMat_val[1,2]+ConfMat_val[2,1])/N_V*100
accuracy_val


## ------------------------------------------------------------------------------------------------------------------------------
library(ROCR)
pred.t.LDA_T=prediction(lda.predict$posterior[,2], wine_validation$high.quality)
perf.t.LDA_T=performance(pred.t.LDA_T, measure = "tpr", x.measure = "fpr")
plot(perf.t.LDA_T,colorize=TRUE,lwd=2, print.cutoffs.at=c(0.2,0.5,0.8))
abline(a=0,b=1, lty=2)

## ------------------------------------------------------------------------------------------------------------------------------
preds <- prediction(as.numeric(forest.predict), wine_validation$high.quality)
perf <- performance(preds,"tpr","fpr")
plot(perf.t.LDA_T,colorize=TRUE,lwd=2, print.cutoffs.at=c(0.2,0.5,0.8))
abline(a=0,b=1, lty=2)


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
wine_test <- read.csv("dataset/winequality-red_test.csv")
wine_test<-wine_test[-c(1,13)]
nT=nrow(wine_test)
pr.nn <- predict(nn,wine_test, rep=imin_rep)
head(pr.nn)

## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
yhat_test = round(pr.nn)
head(yhat_test)


## ----echo=FALSE----------------------------------------------------------------------------------------------------------------
wine_test$high.quality <- yhat_test
write.csv(wine_test,"winequality-red_predicted.csv", row.names = FALSE)

