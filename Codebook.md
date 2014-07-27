# The Code Book
----------------------------------------------------------------------------------------------
This is the codebook for the data set used in the project. Here we explain the source of the data as well as the processing done on the raw data in order to obtain the cleaned and processed tidy dataset - **MyTidyData.txt**

## Source for Raw Data

The raw data was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. A detailed description about the data set can be found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. The readers are encouraged to dowload the data folder from the above link and go through the documentation in order to learn more about the methodology for collecting the data. The data has 10299 observations of 561 variables which are randomly divided into *test* and *training* sets in the ratio of roughly 3:7. Note that all of this is given to us and none of the processing mentioned so far has been done by us.

## Subsetting the Mean and Standard Deviation Variables

The field-data was originally collected in time-domain and was later transformed to frequency-domain.The raw data contains measurements recorded in both the above domains and also some summary statistics on these measurements. Of these, we are only interested in the mean and standard deviations of the following fields of the raw data.

- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

The fields ending with XYZ is a short-hand for 3 different variables one each for X, Y, and Z. Thus, we have 33 measurements of interest and hence 66 variables (1 each for mean and standard deviation) to consider. We do not describe what these variables denote because (a) these are not the variables that will appear in the final, tidy data, and (b) they have already been described in the documentation of raw data.

## Rules for Naming Columns in the Tidy Data

Following are the rules for inferring the meaning of each of the variables in the tidy data, presented in **MyTidyData.txt**

1. The first phrase denotes what domain the the field corresponds to. Time-domain-measurement-variables begin with *Time-Domain-* while their frequency-domain counterparts begin with *Frequency-Domain-*.

2. The next phrase gives the physical meaning of the observation. Specifically, variables related to gravity begin with *Gravity* and the rest begin with *Body*.

3. Since *Acceleration* is the only possible variable when it comes to *Gravity*, the latter is always succeeded by the same. In case of *Body* however, the possible ones are *Gyration* and *Acceleration* denoting the angular and linear accelerations respectively.

4. In case the second phrase starts with *Body*, whenever jerk is considered, it would be included in the variable-name after either  *Gyration* or *Acceleration* as *-Jerk*.

5. For variables denoting magnitude, the next phrase would be *-Magnitude*. For others, this would be absent.

6. The subsequent phrase denotes whether the variable refers to a mean or a standard deviation of the measurement. These are implied, respectively, my the phrases *Mean* and *Standard-Deviation*.

7. For variables representing spatial resolution of measurement, this would be followed by *along-X*, or *along-Y* or *along-Z* to denote the axis they belong to. For others, rules upto #6 would be sufficient to uniquely determine the column-name, knowing the variable of interest.

## Rules for Naming Rows in the Tidy Data

The data set contains measurements done on 30 subjects doing 6 different activities. Since the objective is to calculate the average of the 66 variables mentioned above for each subject and activity, there would be 30x6 rows in the tidy data. The subjects are named from 1-30 and the acitivities have descriptive labels, as defined in *activity_labels.txt* in the root directory.
The naming convention for rowing is fairly straightforward. The characters before *_ (underscore)* denote the subject under consideration (1-30). The ones after it denote one of the six specific activities ("LAYING", "SITTING",  STANDING", "WALKING", "WALKING_DOWNSTAIRS", or "WALKING_UPSTAIRS"). 






