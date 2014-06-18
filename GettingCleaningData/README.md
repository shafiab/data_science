Readme file for Getting and Cleaning Data Course project
========================================================

File Lists
_______________________________________________________
The following files are included:
* README.md : this file
* run_analysis.R : this file contains code required to create the tidy data set
* finalData.txt : this file contains the final tidy data set
* `.md : this file describes the variables in the tidy data
* features.txt : contains the name of the features in the original untidy data, used by run_analysis.R function
* activity_labels.txt : contains the label for each activity, used by run_analysis.R function
* two folders "test" and "train" , each contains original untidy data, used by run_analysis.R function

How to open tidy data
________________________________________________________
To open the tidy data, run the following command on R:

```{r eval=F}
tidyData = read.table("finalData.txt",header= T)
```

The tidyData will be a data frame with dimension of 180x68.