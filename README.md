# JHU-Course-3
Final Project
The script begins by loading the libraries.  Not all were used, I have  a standard list of libraries I load
The project data files are downloaded and unzipped and read into R
I build the test and train data frames  by column binding subject, y (acitivity), and x (data) for test and train. The total data frame is built by row combining test and train data frames
I next add varialbe names.  subject for the first column, activity for the 2nd column, and the 581 variable names from features file
I then use select function to select the subject, activity, variables with mean, and variables with std.  I then combine them for a data frame with just mean and std (88 total variables)
Next, I change the acitivity from numbers to the actual name
I then improve variable names by changing to lower case, removing '.', and ensuring each variable has a unique name
Lasly, I group by activity and subject and calculate the mean of each variable.
