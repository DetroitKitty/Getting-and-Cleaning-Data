# Getting and Cleaning Data Project Notes
## R program in run_analysis.R

Data loaded from separate text files containing variable labels, volunteerID, activity and measurements for test and training sets.

Final goal: create a tidy data set containing averages of means and stddevs.

Five steps:
* 1. Merge the training and testing data (alldata)
* 2. Extract data representing means and standard deviations (statdata)
* 3. Change activity factors to descriptive text
* 4. Add labels to the data
* 5. Create a second data set with the averages of the statdata (statsavg) by Volunteer and Activity

My run_analysis performs these steps in a different order: 1, 4, 2, 5 and 3.

Performing Step 4 before 2 allowed me to use grep to select from the column names.

Changing Activity to text (step 3) last allowed the use of colMeans

* Key functions for each step
    * 1. cbind and rbind 
    * 2. grep
      	* mnums <- grep("mean",allvar,ignore.case=TRUE)
	* snums <- grep("std",allvar,ignore.case=TRUE)
    * 3. mutate
	* statsavg <- mutate(statsavg,Activity=act_file[Activity])
    * 4. "VolunteerID" and "Activity" added to labels from features.txt; colnames
	* allvar <- c("VolunteerID", "Activity", var_labels)
	* colnames(alldata) <- allvar 
    * 5. for loops to select by VolunteerId and Activity; colMeans and "Av_" added to variable labels

  