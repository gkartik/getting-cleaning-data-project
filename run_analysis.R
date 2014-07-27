#Load training and test data sets
train_X <- read.table("train/X_train.txt");
test_X  <- read.table("test/X_test.txt");

#Combine test and training data
Combined_X <- rbind(train_X, test_X);

#To name the columns, read the featueres.txt 
features_names <- read.table("features.txt");
colnames(Combined_X) <- features_names$V2;

# Select only those columns of combined data set that are means and standard deviations of measurements
Selected_X <- Combined_X[, c(grep("mean", colnames(Combined_X), fixed = TRUE), grep("std", colnames(Combined_X), fixed = TRUE))];
# Remove the ones that have meanFreq in their names as they are not true means - Source: Class Discussion Forum 
Selected_X <- Selected_X[, -c(grep("meanFreq", colnames(Selected_X), fixed = TRUE))];

# Load the label and combine from training and test sets
train_y <- read.table("train/y_train.txt");
test_y <- read.table("test/y_test.txt");
Combined_y <- rbind(train_y, test_y);

# Make the label more descriptive by looking up manually from activity_labels.txt
Activity <- apply(Combined_y, 2, as.character);
Activity <- sub("3", "WALKING_DOWNSTAIRS", Activity, fixed = TRUE);
Activity<- sub("2", "WALKING_UPSTAIRS", Activity, fixed = TRUE);
Activity <- sub("1", "WALKING", Activity, fixed = TRUE);
Activity <- sub("4", "SITTING", Activity, fixed = TRUE);
Activity <- sub("5", "STANDING", Activity, fixed = TRUE);
Activity <- sub("6", "LAYING", Activity, fixed = TRUE);

# Add the Acitivity as a new column
Selected_X$Activity <- Activity;

# Load and add the subject information to Selected_X
sub_train <- read.table("train/subject_train.txt");
sub_test <- read.table("test/subject_test.txt");
Selected_X$Subject <- apply(rbind(sub_train, sub_test), 2, as.character);

# Make better column names; I'm not familiar with regular expressions yet. Hence a bit inefficient
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

# For preparing tidy data, first copy Selected_X to a new data frame

TidyData_X <- Selected_X;

# First sort the TidyData rows by Subject and Activity
TidyData_X <- TidyData_X[with(TidyData_X, order(as.numeric(TidyData_X$Subject), TidyData_X$Activity)), ];

# Creating row names for the final averaged data frame
sname <- unique(factor(TidyData_X$Subject));
aname <- unique(factor(TidyData_X$Activity));

# The format for naming is SubjectName_ActivityName
TidyData_rownames <- paste(rep(sname, each=length(aname)), rep(aname, length(sname)), sep = "_");

# For combining factors, use fac.combine from dae package
# install.packages(dae) Uncomment this line if not installed already
library(dae);
comb_factors <- fac.combine(list(factor(TidyData_X$Subject), factor(TidyData_X$Activity)));

num_cols = ncol(TidyData_X);
TidyData <- aggregate(TidyData_X[, 1:(num_cols-2)], by=list(comb_factors), mean);
row.names(TidyData) <- TidyData_rownames;

# Remove default row names given by aggregate function
TidyData$Group.1 <- NULL;

# Write tidy data to a txt file 
write.table(TidyData, "MyTidyData.txt", sep="    ");







