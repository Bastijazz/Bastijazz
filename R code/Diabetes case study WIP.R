#Work in progress

#I want to conduct an exploratory data analysis to understand the dataset as a whole.

head(diabetes)
str(diabetes)
nrow(diabetes)

library(ggplot2)
library(tidyverse)
#The dataset is quite small
#there are a few values with zeroes, I will replace them with the medians of each column.
#I will use a new version of the dataset just to keep a clean backup.

diabetes_v2 <- diabetes
diabetes_v2$Glucose[diabetes_v2$Glucose <=0] <-median(diabetes_v2$Glucose)
diabetes_v2$BloodPressure[diabetes_v2$BloodPressure <=0] <-median(diabetes_v2$BloodPressure)
diabetes_v2$SkinThickness[diabetes_v2$SkinThickness <=0] <-median(diabetes_v2$SkinThickness)
diabetes_v2$Insulin[diabetes_v2$Insulin <=0] <-median(diabetes_v2$Insulin)
diabetes_v2$BMI[diabetes_v2$BMI <=0] <-median(diabetes_v2$BMI)

#Now that the missing values have been replaced by medians, I will start plotting the data and calculate correlations.

#I will create a density plot to get a better view of the columns I am working with. For clarity, I give them a colour.

Glucose_qq <- ggplot(diabetes_v2) + geom_qq(aes(sample = Glucose), colour = "#F8766D")

Age_histogram <- ggplot(diabetes_v2) + geom_histogram(aes(x = Age), colour = "red", fill = "black")


Blood_pressure_density <- ggplot(diabetes_v2) + geom_density(aes(x=BloodPressure), colour = "#00BE67", linewidth = 2)


Pregnancies_histogram <- ggplot(diabetes_v2) + geom_histogram(aes(x = Pregnancies), colour = "blue", fill = "gray") 
#It gets my attention to see some very high pregnancy numbers, this is a number I need to keep in mind as oulier.

SkinThickness_histogram <- ggplot(diabetes_v2) + geom_histogram(aes(x = SkinThickness), colour = "purple", fill = "pink") 
#indicates triceps skinfold thickness in mm, there is one outlier, when looking at the specific line, this person has high BMI and is 62 years old.

Insulin_histogram<- ggplot(diabetes_v2) + geom_histogram(aes(x = Insulin), colour = "orange", fill = "#A3D0D4")

BMI_histogram <- ggplot(diabetes_v2) + geom_histogram(aes(x = BMI), colour = "#0CB702", fill = "#224624")
#The patients with a BMI higher than 35 are considered "Bariatric" and need a surgical procedure.

#Pedigree function indicates the likelihood of diabetes based on family history.
DiabetesPedigreeFunction_qq <- ggplot(diabetes_v2) + geom_qq(aes(sample = DiabetesPedigreeFunction), colour = "#00abff")

#Outcome indicates if the person was diagnosed with diabetes. 1 means yes, 0 means no.
Outcome_bar <- ggplot(diabetes_v2) + geom_bar(aes(x=Outcome), colour = "black",fill = "#E68613") + 
  labs(x= "Diagnosis", y= "Total patients") +
  annotate(geom="text", x = 0, y = 50, label = "Non Diabetic") +
  annotate(geom="text", x = 1, y = 50, label = " Diabetic") + 
  theme(axis.title.x = element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())
#Now that I have visualized the data and investigated on outliers, I want to try to see patterns and correlations.

#The simplest way to visualize correlations is to use the following libraries to create a correlogram.
library(corrplot)
library(RColorBrewer)
Correlation_plot <- cor(diabetes_v2)
corrplot(Correlation_plot, type = "upper", order = "hclust",
         col=brewer.pal(n=8, name = "RdYlBu"))

#From the plot, we can see that BMI and blood pressure have a moderate degree of correlation.
#High BMI and Outcome have moderate correlation.
#Insulin levels don't seem to affect blood pressure, and Age is not a relevant factor for high insulin levels.


#I want to try a correlation matrix  to get numbers together with charts.
download.packages("PerformanceAnalytics")
library("PerformanceAnalytics")
Correlation_matrix <- diabetes_v2
chart.Correlation(Correlation_matrix, histogram=TRUE, pch=10)

#Compute summary statistics.

#calculate mean:
colMeans(diabetes_v2)
#calculate median:
apply(diabetes_v2, 2, median)
#calculate standard deviation:
sapply(diabetes_v2, sd)
#calculate variance:
var(diabetes_v2) #this gives me some negative numbers.

#I can see that the patients are on the higher end when it comes to body mass, a figure more than 30 indicates obesity, in this case we have around 32 on average.


#6.	Identify potential predictors of diabetes using feature selection techniques, such as correlation analysis, principal component analysis (PCA), or decision trees.

#principal component analysis
pca <- prcomp(diabetes_v2, scale = TRUE,
                 center = TRUE, retx = T)
names(pca)
pca$rotation
biplot(pca, main = "Biplot", scale = 1)

#Decision tree
install.packages("rpart.plot")
library(rpart.plot)

create_train_test(diabetes_v2, size=0.8, train = TRUE)


#Work in progress
#_______________________________________________________________________________


