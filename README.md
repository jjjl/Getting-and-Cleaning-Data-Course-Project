# How run_analysis.R works

* The dplyr library is first loaded to use the functionalities employed in Step 3 and Step 5.

* Then subject ID, activity labels, and measurements from the training set and the test set, as well as activity names and feature names are read from different files with read.table().

* In Step 1, the training set and test set are concatenated using rbind(, and then subject ID, activity labels, and measurements are put in the same data frame "mergedData" using cbind().

* In Step 2, grep() uses exact matching to get column indices of measurements with names mean() and std() as described in features.txt, which is then selected in "mergedData" to get "extractedData".

* In Step 3, "extractedData" is first divided by activity label into a list "activitiesData" using split(), which is then passed by lappy() to a custom function describe. The function converts the column of activity label as numeric into activity name as character, based on the value correspondence in activity_labels.txt. In the end the data is passed to unsplit() to get "describedData".

* In Step 4, the column names are labeled as defined in features.txt.

* In Step 5, "describedData" passes the column ID and activity to group_by(), so that summarise_each() can calculate the mean of each variable grouped by each activity and each subject, and the result is "tidyData".

* Finaly the tidy data is stored in a text file.
