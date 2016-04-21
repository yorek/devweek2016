#install libraries
install.packages("RODBC")
install.packages("e1071")
install.packages("class")
install.packages("useful")

#import needed libraries
library("RODBC")
library("e1071")
library("class")
library("useful")

# create an ODBC connection to SQL Server
conn = odbcConnect("DataSets", "dm", "Passw0rd!")

# get dbo.Iris table
iris = sqlFetch(conn, "dbo.Iris")

# show iris data type
class(iris)

# count rows
nrow(iris)

# count columns
ncol(iris)

# show first rows
head(iris)

# ways to get a column (vector)
head(iris$petal_length_in_cm)
head(iris[[4]])
head(iris[,4])

# get a data frame slice
# for columns
head(iris[4])
head(iris[4:5])
head(iris[-4])
head(iris["petal_length_in_cm"])
head(iris[c("petal_length_in_cm", "petal_width_in_cm")])

# get a data frame slice
# for rows
head(iris[2,])
head(iris["10",])

# get a single "cell"
iris[[1,2]]

# filter rows using a "logical index vector"
IS = iris$class == "Iris-setosa"
nrow(iris[IS,])


# plot some data
BG = c("red", "green", "blue")
plot(iris$petal_length_in_cm, iris$petal_width_in_cm, bg=BG[unclass(iris$class)], pch=21)
plot(iris$sepal_length_in_cm , iris$sepal_width_in_cm, bg=BG[unclass(iris$class)], pch=21)
plot(iris[2:5], bg=BG[unclass(iris$class)], pch=21)

# what about correlation between columns?
cor(iris["petal_length_in_cm"], iris["sepal_length_in_cm"], method="pearson")

# define a functio to calculate Pearson Coefficient
panel.pearson = function(x, y, ...) 
{
  horizontal = (par("usr")[1] + par("usr")[2]) / 2; 
  vertical = (par("usr")[3] + par("usr")[4]) / 2; 
  text(horizontal, vertical, format(abs(cor(x,y,method="pearson")), digits=2)) 
}

pairs(iris[2:5], bg=c("red", "green", "blue")[unclass(iris$class)], pch=21, upper.panel=panel.pearson)

#
# Test Supervised Machine Learning
#

# create test and train indexes
train.index = sample(nrow(iris), ceiling(nrow(iris) * 0.7))
test.index = (1:nrow(iris))[-train.index]

plot(iris[train.index,2:5], bg=BG[unclass(iris[train.index,]$class)], pch=21)
plot(iris[test.index,2:5], bg=BG[unclass(iris[test.index,]$class)], pch=21)

# create a naive-bayes classifier
nbc = naiveBayes(iris[train.index,2:5], iris[train.index,6])

# test classifier
confusion.matrix = table(predict(nbc, iris[test.index,-6]), iris[test.index,6], dnn=list('predicted','actual'))
confusion.matrix

# accuracy
sum(diag(confusion.matrix)) / sum(confusion.matrix)

# manual test / sample usage
iris.new = iris[1,]
iris.new[1,] = c(900, 5.2, 3.7, 1.6, 0.6, NA)
iris.new[2,] = c(901, 5.5, 2.5, 2.5, 2, NA)
iris.new[3,] = c(902, 6.0, 3.4, 5.8, 2, NA)

iris.new
plot(iris.new[2:5], bg=BG[unclass(iris.new$class)], pch=21)

# plot new and old values
iris.union = rbind(iris, iris.new) 
plot(iris.union[2:5], bg=BG[unclass(iris.union$class)], pch=21)

# predict 
predict(nbc, iris.new[,-6], type="raw")
predict(nbc, iris.new[,-6])
nbc

#
# Test unsupervised machine learning
#
iris.km = iris[2:5]
iris.km
pairs(iris.km)
plot(iris.km$sepal_width_in_cm, iris.km$sepal_length_in_cm)

km = kmeans(iris.km, 3)
km

table(iris$class, km$cluster)

pairs(iris.km, bg=BG[as.vector(km$cluster)], pch=21)
