
# README File
----------------------------------------------------------------------------------------------
This file explains how run_analysis.R works on the accelerometer data set used in the project to create an independent tidy data for further analysis downstream. More information on the raw data set as well as the tidy set, in terms of what do the specific fields mean, could be obtained in the CodeBook.

# Cleaning the Raw Dataset
----------------------------------------------------------------------------------------------

##  Loading the Dataset
Assuming we are in the root of the unzipped directory, the following lines load the training and test datasets.
```{r}
train_X <- read.table("train/X_train.txt");
test_X  <- read.table("test/X_test.txt");
```
We the combine the two as follows:
```{r}
Combined_X <- rbind(train_X, test_X);
```
##  Adding Column-names through *features.txt*

The features.txt file in the root directory is read and the columns are assigned the default names through this:
```{r}
features_names <- read.table("features.txt");
colnames(Combined_X) <- features_names$V2;
```

## Selecting the Required Columns

The ones we are interested in are the ones corresponding to mean and standard deviation of the measurements. However, some of the columns containing the phrase **meanFreq** do not correspond to actual means and hence need to be eliminated. This is done in two steps:

1. Subset all columns with column-names containing **mean** and **std**.
2. Remove the ones that contain **meanFreq**.

```{r}
Selected_X <- Combined_X[, c(grep("mean", colnames(Combined_X), fixed = TRUE), grep("std", colnames(Combined_X), fixed = TRUE))];
Selected_X <- Selected_X[, -c(grep("meanFreq", colnames(Selected_X), fixed = TRUE))];
```

## Merging Activity Labels from Test and Training Sets

This is done in the same fashion as before.

```{r}
train_y <- read.table("train/y_train.txt");
test_y <- read.table("test/y_test.txt");
Combined_y <- rbind(train_y, test_y);
```

## Making Activity Labels More Descriptive

We do this by manually looking up the *activity_labels.txt* in the root directory as this is a small data file with only 6 records. The following chunk of code does this.

```{r}
Activity <- apply(Combined_y, 2, as.character);
Activity <- sub("3", "WALKING_DOWNSTAIRS", Activity, fixed = TRUE);
Activity<- sub("2", "WALKING_UPSTAIRS", Activity, fixed = TRUE);
Activity <- sub("1", "WALKING", Activity, fixed = TRUE);
Activity <- sub("4", "SITTING", Activity, fixed = TRUE);
Activity <- sub("5", "STANDING", Activity, fixed = TRUE);
Activity <- sub("6", "LAYING", Activity, fixed = TRUE);
```
This data, *Activity*, is added as a new column to the dataframe *Selected_X*.

## Adding Subject Info to the Dataframe

The next step is to add subject information, similar to adding activity. This is accomplished through the following lines.

```{r}
sub_train <- read.table("train/subject_train.txt");
sub_test <- read.table("test/subject_test.txt");
Selected_X$Subject <- apply(rbind(sub_train, sub_test), 2, as.character);
```
## Editing the Default Column-names 

The original dataset has a set of column-names that are both incompatible for downstream use as well as are indescriptive. Hence they need to be renamed as a part of the cleaning process. While R does support use of regular expressions, at this moment, due to my lack of knowledge, I have resorted to static expressions for modifying column names. The following lines are self-explanatory for the changes they affect.

```{r}
colnames(Selected_X) <- sub("BodyBody", "Body", colnames(Selected_X), fixed = TRUE);
colnames(Selected_X) <- sub("f", "Frequency-Domain-", colnames(Selected_X), fixed = TRUE);
colnames(Selected_X) <- sub("std()", "Standard-Deviation", colnames(Selected_X), fixed = TRUE);
colnames(Selected_X) <- sub("mean()", "Mean", colnames(Selected_X), fixed = TRUE);
colnames(Selected_X) <- sub("Mag", "-Magnitude", colnames(Selected_X), fixed = TRUE);
colnames(Selected_X) <- sub("X", "along-X", colnames(Selected_X), fixed = TRUE);
colnames(Selected_X) <- sub("Y", "along-Y", colnames(Selected_X), fixed = TRUE);
colnames(Selected_X) <- sub("Z", "along-Z", colnames(Selected_X), fixed = TRUE);
colnames(Selected_X) <- sub("tBody", "Time-Domain-Body", colnames(Selected_X), fixed = TRUE);
colnames(Selected_X) <- sub("tGravity", "Time-Domain-Gravity", colnames(Selected_X), fixed = TRUE);
colnames(Selected_X) <- sub("Acc", "Acceleration", colnames(Selected_X), fixed = TRUE);
colnames(Selected_X) <- sub("Gyro", "Gyration", colnames(Selected_X), fixed = TRUE);
colnames(Selected_X) <- sub("Jerk", "-Jerk", colnames(Selected_X), fixed = TRUE);
```
# Creating an Independent Tidy Dataset
----------------------------------------------------------------------------------------------

The second part in the process of getting and cleaning data involves creating an independent, tidy dataset that would be relevant for future analysis purposes. What kind of transformations this would involve on the original data would certainly depend on the application at hand. Here we are asked to create a table of the average of each of the variables for all subjects and activities. The first step involves copying the existing dataframe to another temporary dataframe.
```{r}
TidyData_X <- Selected_X;
```
## Sorting by Subject and Activity

Since we merged the test and training sets, the data need not be sorted w.r.t. any of the variables of interest. However, in the tidy data, we would like the data to be arranged in a systematic way. We begin by sorting *TidyData_X*.

```{r}
TidyData_X <- TidyData_X[with(TidyData_X, order(as.numeric(TidyData_X$Subject), TidyData_X$Activity)), ];
```
## Creating new row-names

While the columns of the average of the selected variables would be same as the original dataset, the row-names would be different as the rows correspond to the averages of measurements corresponding to a subject *S* doing an activity *A*. The row-names of the tidy dataframe would reflect this.
To create the new row-names, we do the following.

```{r}
sname <- unique(factor(TidyData_X$Subject));
aname <- unique(factor(TidyData_X$Activity));
TidyData_rownames <- paste(rep(sname, each=length(aname)), rep(aname, length(sname)), sep = "_");
```

## Merging Factors from Subject and Activity

In order to calculate average over factors corresponding to both *Subject* and *Activity*, we need to combine the two factors (30 levels of *Subject* and 6 of *Activity*) to form a factor with 180 levels. The following expression accomplishes the above. Note that the *dae* package needs to be installed for *fac.combine* to work.

```{r}
library(dae);
comb_factors <- fac.combine(list(factor(TidyData_X$Subject), factor(TidyData_X$Activity)));
```

## Forming the Tidy Dataset

In this step, we create the new dataframe representing the average of the variables, calculated over *comb_factors*. This is done using the *aggregate* function of R. 
```{r}
num_cols = ncol(TidyData_X);
TidyData <- aggregate(TidyData_X[, 1:(num_cols-2)], by=list(comb_factors), mean);
row.names(TidyData) <- TidyData_rownames;
TidyData$Group.1 <- NULL;
```
The last line deletes the column corresponding to default row-names obtained from *aggregate* function.

## Writing the Dataframe to File

Finally, *TidyData* needs to be written to the disk for future usage. 
```{r}
write.table(TidyData, "MyTidyData.txt", sep="    ");
```
