## Marissa McKee
## Project 1: EDA

# Import recent data from the U.S. Dept. of Education College scorecard
# All 'NULL' and 'PrivacySuppressed' values are replaced with blanks in the dataset prior to import
setwd('C:/Users/mckee/Documents/College/$Graduate School/ADTA 5410/Projects/Project 1 EDA')
edu <- read.csv(file='project-1-data-elements.csv')

# Preview the beginning of the dataset
head(edu)

# Dataset columns
names(edu)

# Structure of the dataset
str(edu)

# Clean up the data types for character variables
edu$INSTNM <- as.factor(edu$INSTNM)
edu$STABBR <- as.factor(edu$STABBR)
edu$ACCREDAGENCY <- as.factor(edu$ACCREDAGENCY)
edu$MAIN <- as.factor(edu$MAIN)
edu$PREDDEG  <- as.factor(edu$PREDDEG)
edu$CONTROL <- as.factor(edu$CONTROL)
edu$LOCALE <- as.factor(edu$LOCALE)
edu$CCUGPROF <- as.factor(edu$CCUGPROF)
edu$CCSIZSET <- as.factor(edu$CCSIZSET)
edu$PCTFLOAN <- as.numeric(edu$PCTFLOAN)
edu$NPT41_PUB <- as.numeric(edu$NPT41_PUB)
edu$NPT42_PUB <- as.numeric(edu$NPT42_PUB)
edu$NPT43_PUB <- as.numeric(edu$NPT43_PUB)
edu$NPT44_PUB <- as.numeric(edu$NPT44_PUB)
edu$NPT45_PUB <- as.numeric(edu$NPT45_PUB)
edu$LO_INC_RPY_1YR_RT <- as.numeric(edu$LO_INC_RPY_1YR_RT)
edu$MD_INC_RPY_1YR_RT <- as.numeric(edu$MD_INC_RPY_1YR_RT)
edu$HI_INC_RPY_1YR_RT <- as.numeric(edu$HI_INC_RPY_1YR_RT)
edu$MD_EARN_WNE_P6 <- as.numeric(edu$MD_EARN_WNE_P6)
edu$COUNT_NWNE_P6 <- as.numeric(edu$COUNT_NWNE_P6)
edu$COUNT_WNE_P6 <- as.numeric(edu$COUNT_WNE_P6)
str(edu)

head(edu[,10:21])

# Impute missing values 

#We will also discuss the use of a Random Forest imputation method using the missForest package: You can view a vignette in the link below:
#  <https://stat.ethz.ch/education/semesters/ss2012/ams/paper/missForest_1.2.pdf>
  
# MissForest is another machine learning-based data imputation algorithm that operates on the Random Forest algorithm. The creators of the algorithm, conducted a study in 2011 in which imputation methods were compared on datasets with randomly introduced missing values. MissForest outperformed all other algorithms in all metrics, including KNN-Impute, in some cases by over 50%.

# First, the missing values are filled in using median/mode imputation. Then, we mark the missing values as 'Predict' and the others as training rows, which are fed into a Random Forest model trained to predict. The generated prediction for that row is then filled in to produce a transformed dataset.

# This process of looping through missing data points repeats several times, each iteration improving on better and better data. It's like standing on a pile of rocks while continually adding more to raise yourself: the model uses its current position to elevate itself further.

# Iterations continue until some stopping criteria is met or after a certain number of iterations has elapsed. As a general rule, datasets become well imputed after four to five iterations, but it depends on the size and amount of missing data.

# MissForest is also robust to noisy data and multicollinearity, since random-forests have built-in feature selection (evaluating entropy and information gain). KNN-Impute yields poor predictions when datasets have weak predictors or heavy correlation between features.

# Load missforest librariy
library(missForest)

# Several columns have null values
summary(edu)

# There are a total of 42,973 missing values 
# Removing this many values will severely alter the results of any model 
sum(is.na(edu))

# There are missing values in several columns 
colSums(is.na(edu))

# Impute the missing values for all numeric columns using missForest
edu.imp<-missForest(edu[,10:21])

# missforest also provides an OOB imputation error estimate
edu.imp$OOBerror 

# Check the edu.imp$ximp for the imputation results
summary(edu.imp$ximp)

# Combine the other values into the new dataframe object edu.imp
edu.imp<-cbind(edu.imp$ximp, edu[,1:9])

# Validate other columns were appended 
summary(edu.imp)

# Remove records that are highly nulled
edu.imp <- na.omit(edu.imp) 

# Validate all null values have been imputed 
sum(is.na(edu.imp))

# Let's use the imputed values as the edu dataframe 
edu <- edu.imp

# Rows and columns of the dataset
dim(edu)

# Before I filter the data let's take a look at some key columns
Degrees <- table(edu$PREDDEG)
Ownership <- table(edu$CONTROL)
Campus <- table(edu$MAIN)
Location <- table(edu$LOCALE)
Size <- table(edu$CCSIZSET)

# Load a fun color library 
library(RColorBrewer)

# Set the plot/graph color 
color <- brewer.pal(8, "Set2") 

## Pie charts
# Degrees Awarded
labels <- c("Not classified","Predominantly certificate-degree granting","Predominantly associate's-degree granting","Predominantly bachelor's-degree granting","Entirely graduate-degree granting")
pie(Degrees, labels, main = "Degrees Awarded", col = color)

# University Ownership
labels <- c("Public","Private nonprofit" ,"Private for-profit")
pie(Ownership, labels, main="University Ownership", col=color)

# Main Campus
labels <- c("Not main campus","Main campus")
pie(Campus, labels, main="Main Campus", col=color)

## Bar graphs 
# Degrees Awarded
barplot(Degrees, col=color,  names.arg=c("Not classified","Predominantly certificate-degree granting","Predominantly associate's-degree granting","Predominantly bachelor's-degree granting","Entirely graduate-degree granting"),las=2)

# University Ownership
barplot(Ownership, col=color, names.arg=c("Public","Private nonprofit" ,"Private for-profit"),las=2)

# Main Campus
barplot(Campus, col=color, names.arg=c("Not main campus","Main campus"),las=2)

# Load the ggplot library 
library(ggplot2)

# Degrees awarded by Average net price for $0-$30,000 family income (public institutions)
ggplot(data = edu, mapping = aes(x = PREDDEG, y = NPT41_PUB)) +labs(y= "Average net price for $0-$30,000 family income (public institutions)", x = "Predominant undergraduate degree awarded") + labs(title = "Boxplot of Degrees Awarded by Avg Cost for Low Family Income") +
  geom_boxplot()

# Degrees awarded by Average net price for $30,001-$48,000 family income (public institutions)
ggplot(data = edu, mapping = aes(x = PREDDEG, y = NPT42_PUB)) + labs(y= "Average net price for $30,000-$48,000 family income (public institutions)", x = "Predominant undergraduate degree awarded") +labs(title = "Boxplot of Degrees Awarded by Avg Cost for Lower Middle Family Income") +
  geom_boxplot()

# Degrees awarded by Average net price for $48,001-$75,000 family income (public institutions)
ggplot(data = edu, mapping = aes(x = PREDDEG, y = NPT43_PUB)) + labs(y= "Average net price for $48,000-$75,000 family income (public institutions)", x = "Predominant undergraduate degree awarded") + labs(title = "Boxplot of Degrees Awarded by Avg Cost for Middle Family Income") +
  geom_boxplot()

# Degrees awarded by Average net price for $75,001-$110,000 family income (public institutions)
ggplot(data = edu, mapping = aes(x = PREDDEG, y = NPT44_PUB)) + labs(y= "Average net price for $75,000-$110,000 family income (public institutions)", x = "Predominant undergraduate degree awarded") + labs(title = "Boxplot of Degrees Awarded by Avg Cost for Middle Upper Family Income") +
  geom_boxplot()

# Degrees awarded by Average net price for $110,001+ family income (public institutions)
ggplot(data = edu, mapping = aes(x = PREDDEG, y = NPT45_PUB)) + labs(y= "Average net price for $110,000+ family income (public institutions)", x = "Predominant undergraduate degree awarded") + labs(title = "Boxplot of Degrees Awarded by Avg Cost for Upper Family Income") +
  geom_boxplot()

# Preview the proportion of categories 
prop.table(table(edu$STABBR))    # CA, NY, TX have largest proportion of records
prop.table(table(edu$MAIN))      # 79% of records are on the main campus
prop.table(table(edu$PREDDEG))   # 30% Predominantly bachelor's-degree granting 
prop.table(table(edu$CONTROL))   # 40% Private for-profit schools 
prop.table(table(edu$LOCALE))    # 24% Suburb: Large
prop.table(table(edu$CCUGPROF))  # 33% N/A 8% Two-year, higher part-time
prop.table(table(edu$CCSIZSET))  # 33% N/A 8% Four-year, very small, primarily nonresidential

# Load tidyverse library
library(tidyverse)

# Filter the data to look at main campuses, bachelor degrees that are awarded from public schools
eduf <- edu %>% filter(MAIN=="1", PREDDEG=="3", CONTROL=="1") 

# Preview the end of the dataset
tail(eduf)

# Rows and columns of the dataset
dim(eduf)

# Summary statistics for our filtered data
summary(eduf)

# Preview the levels/categories of the factor variables 
levels(eduf$STABBR)
levels(eduf$ACCREDAGENCY)
levels(eduf$MAIN)
levels(eduf$PREDDEG)
levels(eduf$CONTROL)
levels(eduf$LOCALE)
levels(eduf$CCUGPROF)
levels(eduf$CCSIZSET)

# Preview the proportion of categories 
prop.table(table(eduf$STABBR))    # CA, NY, TX have largest proportion of records
prop.table(table(eduf$MAIN))      # 100% of records are on the main campus
prop.table(table(eduf$PREDDEG))   # 100% Predominantly bachelor's-degree granting 
prop.table(table(eduf$CONTROL))   # 100% Public schools 
prop.table(table(eduf$LOCALE))    # 19% City: Large and 14% City: Midsize and 16% City: Small 
prop.table(table(eduf$CCUGPROF))  # 25% Four-year, full-time, selective, higher transfer-in
prop.table(table(eduf$CCSIZSET))  # 20% Four-year, large, primarily residential

## Plots and Graphs Section ##
Degrees <- table(eduf$PREDDEG)
Ownership <- table(eduf$CONTROL)
Campus <- table(eduf$MAIN)
Location <- table(eduf$LOCALE)
Size <- table(eduf$CCSIZSET)

# Bar graphs 
barplot(Degrees, col=color,  names.arg=c("Not classified","Predominantly certificate-degree granting","Predominantly associate's-degree granting","Predominantly bachelor's-degree granting","Entirely graduate-degree granting"),las=2)
barplot(Ownership, col=color, names.arg=c("Public","Private nonprofit" ,"Private for-profit"),las=2)
barplot(Campus, col=color, names.arg=c("Not main campus","Main campus"),las=2)
barplot(Location, col=color, names.arg=c("N/A","City: Large","City: Midsize","City: Small","Suburb: Large","Suburb: Midsize","Suburb: Small","Town: Fringe","Town: Distant", "Town: Remote","Rural: Fringe", "Rural: Distant" ," Rural: Remote"),las=2)
barplot(Size, col=color, names.arg=c("Not applicable" ,"Two-year, very small" ,"Two-year, small" ,"Two-year, medium" ,"Two-year, large" ,"Two-year, very large" ,"Four-year, very small, primarily nonresidential" ,"Four-year, very small, primarily residential" ,"Four-year, very small, highly residential" ,"Four-year, small, primarily nonresidential" ,"Four-year, small, primarily residential" ,"Four-year, small, highly residential" ,"Four-year, medium, primarily nonresidential" ,"Four-year, medium, primarily residential" ,"Four-year, medium, highly residential" ,"Four-year, large, primarily nonresidential" ,"Four-year, large, primarily residential" ,"Four-year, large, highly residential", "Exclusively graduate/professional"),las=2)

# Pie charts
labels <- c("Not classified","Predominantly certificate-degree granting","Predominantly associate's-degree granting","Predominantly bachelor's-degree granting","Entirely graduate-degree granting")
pie(Degrees, labels, main = "Degrees Awarded", col = color)

labels <- c("Public","Private nonprofit" ,"Private for-profit")
pie(Ownership, labels, main="University Ownership", col=color)

labels <- c("Not main campus","Main campus")
pie(Campus, labels, main="Main Campus", col=color)

labels <- c("City: Large","City: Midsize","City: Small","Suburb: Large","Suburb: Midsize","Suburb: Small","Town: Fringe","Town: Distant", "Town: Remote","Rural: Fringe", "Rural: Distant" ," Rural: Remote")
pie(Location, labels,main="University Location",col=color)

labels <- c("Not applicable" ,"Two-year, very small" ,"Two-year, small" ,"Two-year, medium" ,"Two-year, large" ,"Two-year, very large" ,"Four-year, very small, primarily nonresidential" ,"Four-year, very small, primarily residential" ,"Four-year, very small, highly residential" ,"Four-year, small, primarily nonresidential" ,"Four-year, small, primarily residential" ,"Four-year, small, highly residential" ,"Four-year, medium, primarily nonresidential" ,"Four-year, medium, primarily residential" ,"Four-year, medium, highly residential" ,"Four-year, large, primarily nonresidential" ,"Four-year, large, primarily residential" ,"Four-year, large, highly residential", "Exclusively graduate/professional")
pie(Size, labels, main="University Size", col=color)

names(eduf)
# Box plots
boxplot(eduf$PCTFLOAN, horizontal=TRUE, col=color)  
boxplot(eduf$NPT41_PUB, horizontal=TRUE, col=color)  
boxplot(eduf$NPT42_PUB, horizontal=TRUE, col=color)  
boxplot(eduf$NPT43_PUB, horizontal=TRUE, col=color)  
boxplot(eduf$NPT44_PUB, horizontal=TRUE, col=color)  
boxplot(eduf$NPT45_PUB, horizontal=TRUE, col=color)  
boxplot(eduf$LO_INC_RPY_1YR_RT, horizontal=TRUE, col=color)  
boxplot(eduf$MD_INC_RPY_1YR_RT, horizontal=TRUE, col=color)  
boxplot(eduf$HI_INC_RPY_1YR_RT, horizontal=TRUE, col=color) 
boxplot(eduf$MD_EARN_WNE_P6, horizontal=TRUE, col=color)  
boxplot(eduf$COUNT_NWNE_P6, horizontal=TRUE, col=color)  
boxplot(eduf$COUNT_WNE_P6, horizontal=TRUE, col=color)  

# Load the ggplot library 
library(ggplot2)

# Degrees awarded by Average net price for $0-$30,000 family income (public institutions)
ggplot(data = eduf, mapping = aes(x = PREDDEG, y = NPT41_PUB)) +labs(y= "Average net price for $0-$30,000 family income (public institutions)", x = "Predominant undergraduate degree awarded") + labs(title = "Boxplot of Degrees Awarded by Avg Cost for Low Family Income") +
  geom_boxplot()

# Degrees awarded by Average net price for $30,001-$48,000 family income (public institutions)
ggplot(data = eduf, mapping = aes(x = PREDDEG, y = NPT42_PUB)) + labs(y= "Average net price for $30,000-$48,000 family income (public institutions)", x = "Predominant undergraduate degree awarded") +labs(title = "Boxplot of Degrees Awarded by Avg Cost for Lower Middle Family Income") +
  geom_boxplot()

# Degrees awarded by Average net price for $48,001-$75,000 family income (public institutions)
ggplot(data = eduf, mapping = aes(x = PREDDEG, y = NPT43_PUB)) + labs(y= "Average net price for $48,000-$75,000 family income (public institutions)", x = "Predominant undergraduate degree awarded") + labs(title = "Boxplot of Degrees Awarded by Avg Cost for Middle Family Income") +
  geom_boxplot()

# Degrees awarded by Average net price for $75,001-$110,000 family income (public institutions)
ggplot(data = eduf, mapping = aes(x = PREDDEG, y = NPT44_PUB)) + labs(y= "Average net price for $75,000-$110,000 family income (public institutions)", x = "Predominant undergraduate degree awarded") + labs(title = "Boxplot of Degrees Awarded by Avg Cost for Middle Upper Family Income") +
  geom_boxplot()

# Degrees awarded by Average net price for $110,001+ family income (public institutions)
ggplot(data = eduf, mapping = aes(x = PREDDEG, y = NPT45_PUB)) + labs(y= "Average net price for $110,000+ family income (public institutions)", x = "Predominant undergraduate degree awarded") + labs(title = "Boxplot of Degrees Awarded by Avg Cost for Upper Family Income") +
  geom_boxplot()


# Histogram
hist(eduf$log(PCTFLOAN), main = "Histogram of Percent of all undergraduate students receiving a federal student loan",
     xlab = "Percent", col="lightsalmon")
hist(eduf$NPT41_PUB, main = "Histogram of Average net price for $0-$30,000 family income",
     xlab = "Price", col="slateblue1")
hist(eduf$NPT42_PUB, main = "Histogram of Average net price for $30,001-$48,000 family income",
     xlab = "Price", col="springgreen")
hist(eduf$NPT43_PUB, main = "Histogram of Average net price for $48,001-$75,000 family income",
     xlab = "Price", col="plum1")
hist(eduf$NPT44_PUB, main = "Histogram of Average net price for $75,001-$110,000 family income",
     xlab = "Price", col="mistyrose")
hist(eduf$NPT45_PUB, main = "Histogram of Average net price for $110,000+ family income",
     xlab = "Price", col="slategray1") 
hist(eduf$LO_INC_RPY_1YR_RT, main = "Histogram of One-year repayment rate by family income ($0-30,000)",
     xlab = "Percent", col="lightyellow") 
hist(eduf$MD_INC_RPY_1YR_RT, main = "Histogram of One-year repayment rate by family income ($30,000-75,000)",
     xlab = "Percent", col="lightcyan") 
hist(eduf$HI_INC_RPY_1YR_RT, main = "Histogram of One-year repayment rate by family income ($75,000-110,000)",
     xlab = "Percent", col="tan1") 

hist(eduf$MD_EARN_WNE_P6, main = "Histogram of Median earnings of students working and not enrolled 6 years after entry",
     xlab = "Earnings", col="pink") 
hist(eduf$MD_EARN_WNE_P6, main = "Histogram of Median earnings of students working and not enrolled 6 years after entry",
     xlab = "Earnings", col="pink") 
hist(eduf$COUNT_NWNE_P6, main = "Histogram of Number of students not working and not enrolled 6 years after entry",
     xlab = "Earnings", col="slategray", breaks=50) 
hist(eduf$COUNT_WNE_P6, main = "Histogram of Number of students working and not enrolled 6 years after entry",
     xlab = "Earnings", col="plum1", breaks=50) 

# Scatter plot
ggplot(data = eduf, mapping = aes(x = LO_INC_RPY_1YR_RT, y = NPT41_PUB)) + 
  geom_point()

ggplot(data = eduf, mapping = aes(x = LO_INC_RPY_1YR_RT, y = COUNT_WNE_P6)) + 
  geom_point()

plot(eduf$PCTFLOAN, eduf$HI_INC_RPY_1YR_RT, 
     main= "Scatter Plot of Loan Repayment of ",
     xlab="Percent of all undergraduate students receiving a federal student loan", 
     ylab="High Income Repayment 1 year") 

abline(lm(HI_INC_RPY_1YR_RT ~ PCTFLOAN, data = eduf)) ## draw the line of the linear regression

# load corrplot and Hmisc for correlation matrix
library(corrplot)
library(Hmisc)

# Correlation matrix
r <- rcorr(as.matrix(eduf))
corrplot(r$r, type='upper',method = "shade", shade.col = NA, p.mat=r$P, tl.col="black", tl.srt = 45,number.cex = 1,addCoef.col = 'blue', order='hclust',sig.level = 0.05, insig = c("pch"), diag = FALSE, col=colorRampPalette(c("deeppink","white","olivedrab2"))(200))

###################################################################################################
#
# Question 1:        Does working status, 6 years after attending a university, affect loan repayment? 
#
# Variables
# COUNT_WNE_P6:      Number of students working and not enrolled 6 years after entry
# COUNT_NWNE_P6:     Number of students not working and not enrolled 6 years after entry
# LO_INC_RPY_1YR_RT: One-year repayment rate by family income ($0-30,000)
# MD_INC_RPY_1YR_RT: One-year repayment rate by family income ($30,000-75,000)
# HI_INC_RPY_1YR_RT: One-year repayment rate by family income ($75,000+)
#
###################################################################################################

# Scatter plot of loan repayment for high income families that are not working 
plot(eduf$HI_INC_RPY_1YR_RT, eduf$COUNT_NWNE_P6, 
     main= "Scatter Plot of Loan Repayment of for High Income Families NOT Working",
     xlab="One-year repayment rate by family income ($75,000+)", 
     ylab="Number of students not working and not enrolled 6 years after entry") 
abline(lm(COUNT_NWNE_P6 ~ HI_INC_RPY_1YR_RT, data = eduf)) ## draw the line of the linear regression

# Scatter plot of loan repayment for middle income families that are not working 
plot(eduf$MD_INC_RPY_1YR_RT, eduf$COUNT_NWNE_P6, 
     main= "Scatter Plot of Loan Repayment of for Middle Income Families NOT Working",
     xlab="One-year repayment rate by family income ($30,000-$75,000+)", 
     ylab="Number of students not working and not enrolled 6 years after entry") 
abline(lm(COUNT_NWNE_P6 ~ MD_INC_RPY_1YR_RT, data = eduf)) ## draw the line of the linear regression

# Scatter plot of loan repayment for low income families that are not working 
plot(eduf$LO_INC_RPY_1YR_RT, eduf$COUNT_NWNE_P6, 
     main= "Scatter Plot of Loan Repayment of for Low Income Families NOT Working",
     xlab="One-year repayment rate by family income ($0-$30,000+)", 
     ylab="Number of students not working and not enrolled 6 years after entry") 
abline(lm(COUNT_NWNE_P6 ~ LO_INC_RPY_1YR_RT, data = eduf)) ## draw the line of the linear regression

# Scatter plot of loan repayment for high income families that are  working 
plot(eduf$HI_INC_RPY_1YR_RT, eduf$COUNT_WNE_P6, 
     main= "Scatter Plot of Loan Repayment of for High Income Families Working",
     xlab="One-year repayment rate by family income ($75,000+)", 
     ylab="Number of students not working and not enrolled 6 years after entry") 
abline(lm(COUNT_WNE_P6 ~ HI_INC_RPY_1YR_RT, data = eduf)) ## draw the line of the linear regression

# Scatter plot of loan repayment for middle income families that are  working 
plot(eduf$MD_INC_RPY_1YR_RT, eduf$COUNT_WNE_P6, 
     main= "Scatter Plot of Loan Repayment of for Middle Income Families Working",
     xlab="One-year repayment rate by family income ($30,000-$75,000+)", 
     ylab="Number of students not working and not enrolled 6 years after entry") 
abline(lm(COUNT_WNE_P6 ~ MD_INC_RPY_1YR_RT, data = eduf)) ## draw the line of the linear regression

# Scatter plot of loan repayment for low income families that are  working 
plot(eduf$LO_INC_RPY_1YR_RT, eduf$COUNT_WNE_P6, 
     main= "Scatter Plot of Loan Repayment of for Low Income Families Working",
     xlab="One-year repayment rate by family income ($0-$30,000+)", 
     ylab="Number of students not working and not enrolled 6 years after entry") 
abline(lm(COUNT_WNE_P6 ~ LO_INC_RPY_1YR_RT, data = eduf)) ## draw the line of the linear regression


###################################################################################################
#
# Question 2:     By using the variables collected, can we predict loan repayment? 
#
###################################################################################################

# Load fastDummies library
library('fastDummies')

# Create Dummy variables for regression 
regdata <- dummy_cols(eduf, select_columns = c('STABBR','PREDDEG','CONTROL','LOCALE','CCUGPROF','CCSIZSET'))
names(regdata)

# Remove non dummy columns 
regdata <- regdata[,-1:-21]
edur <- cbind(eduf, regdata)
names(edur)

# Load the psych library
library(psych)

# Remove categorical columns 'STABBR','PREDDEG','CONTROL','LOCALE','CCUGPROF','CCSIZSET'
edur <- edur[,c(-13:-21)]

# Validate correct columns are removed [13] should be "PCTFLOAN.1" now
names(edur)

# Summary stats
describe(edur)
summary(edur)

# set dependent and independent vars
X <- edur[,c(1:8,10:126)]
dim(X)
y <- edur[,9]
length(y)

# Generalized matrix of plots on the first 15 variables
ggpairs(edur[,1:15]) 

# Load the Hmisc and corrplot library
library(corrplot)
library(Hmisc)

#Visualize the first 15 columns of the correlation matrix
r <- rcorr(as.matrix(edur[,1:14]))

# Plot the first 15 columns of the correlation matrix
corrplot(r$r, type='upper',method = "shade", shade.col = NA, p.mat=r$P, tl.col="black", tl.srt = 45,number.cex = 1,addCoef.col = 'blue', order='hclust',sig.level = 0.05, insig = c("pch"), diag = FALSE, col=colorRampPalette(c("deeppink","white","olivedrab2"))(200))

#Fit the regression model
edur.ols <- lm(HI_INC_RPY_1YR_RT~.,data=edur) # fit "full" model using all predictors  as terms.
summary(edur.ols)

#Visualize the first significant columns of the regression in the correlation matrix
r <- rcorr(as.matrix(edur[,c('HI_INC_RPY_1YR_RT','STABBR_VI','STABBR_RI','CCUGPROF_10','MD_EARN_WNE_P6','MD_INC_RPY_1YR_RT','LO_INC_RPY_1YR_RT','NPT44_PUB','NPT45_PUB')]))

# Plot the first significant columns of the regression in the correlation matrix
corrplot(r$r, type='upper',method = "shade", shade.col = NA, p.mat=r$P, tl.col="black", tl.srt = 45,number.cex = 1,addCoef.col = 'blue', order='hclust',sig.level = 0.05, insig = c("pch"), diag = FALSE, col=colorRampPalette(c("deeppink","white","olivedrab2"))(200))

#Regression diagnostics
par(mfrow=c(2,2))  # set up plotting region for 4 plots arranged in 2 rows and 2 columns.

# Load ggfortify library
library(ggfortify)

autoplot(edur.ols)
#The residuals vs. fitted graph shows no pattern and the blue line is approximately horizontal at zero. This suggests that we can assume linear relationship between the predictors and the outcome variables. 
#The scale-location graph shows the residuals are spread equally along the range of fitted values indicating the variance is homogeneous (constant variance)
#The Normal QQ plot can be used to visually check the normality assumption. In our example, all the points fall approximately along this reference line, so we can assume normality of the errors.
#The residuals vs leverage chart can be used to identify outliers and leverage points. A data point has high leverage, if it has extreme predictor x values. This can be detected by examining the leverage statistic or the hat-value. A value of this statistic above 2(p + 1)/n indicates an observation with high leverage; where, p is the number of predictors and n is the number of observations.

par(mfrow=c(1,1)) # restore plotting region to contain one plot.

# Load olsrr library
library(olsrr)
# Compute influential points
ols_plot_cooksd_bar(edur.ols) 
?ols_plot_cooksd_bar()

# Compute DFBETAS - 27 pages of graphs
# ols_plot_dfbetas(edur.ols)  
?ols_plot_dfbetas()

# Compute DFFITS
ols_plot_dffits(edur.ols)
?ols_plot_dffits()

# Compute studentized residuals
# ols_plot_resid_stud(edur.ols)
?ols_plot_resid_stud()

?avPlots()
avPlots(edur.ols)

# Final file extracts 
write.csv(eduf, file='eduf.csv')
write.csv(edur, file='edur.csv')
