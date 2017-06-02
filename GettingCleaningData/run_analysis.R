library(dplyr)

#########################################################################
# 1. Merge the train and test data sets together to create one data set #
#########################################################################

# First, we need to load the TRAINING Data. We'll do it in 3 steps:
# a) Load the train subject data into a data frame
  subject_train_df <- read.table("./Project/UCI HAR Dataset/train/subject_train.txt")
  print("subject_train_df: Number of lines and columns loaded")
  print(dim(subject_train_df))
  print("subject_train_df: List of unique values")
  print(unique(subject_train_df))
  print("subject_train_df: Number of unique values")
  print(nrow(unique(subject_train_df)))
#
# b) Load the X Train data into a data frame
  x_train_df <- read.table("./Project/UCI HAR Dataset/train/x_train.txt")
  print("x_train_df: Number of lines and columns loaded")
  print(dim(x_train_df))
#
# c) Load the Y Train data into a data frame
  y_train_df <- read.table("./Project/UCI HAR Dataset/train/y_train.txt")
  print("y_train_df: Number of lines and columns loaded")
  print(dim(y_train_df))
  print("y_train_df: List of unique values")
  print(unique(y_train_df))
  print("y_train_df: Number of unique values")
  print(nrow(unique(y_train_df)))
#
# Then, we need to do the same with the TEST data
# d) Load the test subject data into a data frame
  subject_test_df <- read.table("./Project/UCI HAR Dataset/test/subject_test.txt")
  print("subject_test_df: Number of lines and columns loaded")
  print(dim(subject_test_df))
  print("subject_test_df: List of unique values")
  print(unique(subject_test_df))
  print("subject_test_df: Number of unique values")
  print(nrow(unique(subject_test_df)))
#
# b) Load the X Test data into a data frame
  x_test_df <- read.table("./Project/UCI HAR Dataset/test/x_test.txt")
  print("x_test_df: Number of lines and columns loaded")
  print(dim(x_test_df))
#
# c) Load the Y Test data into a data frame
  y_test_df <- read.table("./Project/UCI HAR Dataset/test/y_test.txt")
  print("y_test_df: Number of lines and columns loaded")
  print(dim(y_test_df))
  print("y_test_df: List of unique values")
  print(unique(y_test_df))
  print("y_test_df: Number of unique values")
  print(nrow(unique(y_test_df)))
#
# Before merging the Training and Test data, we need to tidy up each data set separate (i.e. the Training data all together as well as the Test data)
# First, merge the training data together: We can use the function cbind()
  train_merged_df <- cbind(subject_train_df, y_train_df, x_train_df)
#
# Then, we do the same with the test data
  test_merged_df <- cbind(subject_test_df, y_test_df, x_test_df)
  
# Finally, we merge both datasets together, so we have just 1 data set with all the data together. We can do this with the rbind() function
  merged_df <- rbind(train_merged_df, test_merged_df)


################################################################################
# 2. Extract only the measurements on the mean and standard deviation for each #
#    measurement                                                               #
################################################################################

# First, let's load the list of features from the features file
  features_df <- read.table("./Project/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
#  
# Now, let`s create a vector with the column names
  colnames_vector <- c("subjectid", "activityid")
#  
# Then, we append the names of the 561 features that come from the data frame that was used to load the features file
  colnames_vector <- append(colnames_vector, features_df[,2])
#  
# We need to change the name of the first 2 columns of the merged data frame
  names(merged_df)[1:2] <- colnames_vector[1:2]
#  
# Let`s create a new data frame with only the columns needed
  mean_std_features_df <- select(merged_df, 1:2, grep("mean()|std()", colnames_vector))
#  
#
################################################################################
# 3. Use descriptive activity names to name the activities in the data set     #
################################################################################
  
# Load the activities data into R data frames
  activity_labels_df <- read.table("./Project/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
#  
# Change the column names of the activities data loaded
  colnames(activity_labels_df) <- c("activityid", "activityname")
#  
# Now, we can join both tables by the column activityid
  mean_std_features_df <- inner_join(mean_std_features_df, activity_labels_df)
#  
# Reorganize the table 
  mean_std_features_df <- select(mean_std_features_df, 1,2,82,3:81)
#
#
################################################################################
# 4. Appropriately label the data set with descriptive variable names.         #
################################################################################
  
# Gives the names to the columns. Since columns 1 to 3 are already correctly named, we just name every other column (i.e. 4th to 82nd)
  colnames(mean_std_features_df)[4:82] <- colnames_vector[grep("mean()|std()", colnames_vector)]
#
#
################################################################################
# 5. From the data set in step 4, create a second, independent tidy data set   #
#    with  the average of each variable for each activity and each subject.    #
################################################################################

# First, let's create a dyplr data frame so we can group it by the subject and activity  
  mean_std_features_dt <- tbl_df(mean_std_features_df)
#  
# Then, let's create another data frame that's already grouped by the subject and activity
  features_by_activity_subject <- group_by(mean_std_features_dt, subjectid, activityid, activityname)
#
# Finally, let's calculate the mean for every variable and create a new data frame with the results
  summ_features_by_activity_subject <- summarize_all(features_by_activity_subject, mean)
#
# Write a file with the contents of the data frame
  write.table(summ_features_by_activity_subject, file = "./Project/summ_features_by_activity_subject.txt", row.names = FALSE)