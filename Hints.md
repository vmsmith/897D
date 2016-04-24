* Start by running the code in the R script file “TeamProjectEx.R.” Then adapt the code to build your own models. The script file just includes linear discriminant analysis, logistic regression, and linear regression, but you should consider applying as many of the techniques we’ve covered in class as you can.  



* Feel free to use any transformations of the predictor variables – some are included in the R script file as examples. However, do not transform either DONR or DAMT. The predictor transformations in the R script file are purely illustrative. You can use any transformations you can think of for any of the predictors:

  * Sometimes predictor transformations can be suggested by thinking about the underlying data. For example, one rationale for trying a quadratic transformation in a linear regression model is if you believe there is a possibility that the association between the response and that predictor (controlling for all the other included predictors) is non-linear. Perhaps average gifts tend to increase with donor's incomes but then level off when incomes are very high? Similar arguments can be made for classification models. Another type of transformation that may be suggested by the application at hand is indicator variables for certain "interesting" quantitative predictor variable values (e.g., if observations with X1=0 behave differently to observations with X1>0, then an indicator variable that is 1 for observations with X1=0 and 0 for observations with X1>0 may be helpful).  
  
  * Other times, transformations are tried in a more exploratory, ad-hoc way. For example, a log transformation is often used for highly skewed variables (although sometimes the log transformation is "too strong" and a square root transformation may be better, while at other times the log transformation is "not strong enough" and a reciprocal or negative square root transformation may be better).  
  
  * You can, if you wish, try either of these approaches for this project. You may not have enough time to be fully comprehensive in trying every possibility you can think of, so you may have to be selective and allocate your time carefully (just as in any real-world project where time and cost constraint always limit what you can do).
  
* It is worth spending some time seeing if there are any unimportant predictor terms that are merely adding noise to the predictions, thereby harming the ability of the model to predict test data. Simplifying your model by removing such terms can bring model improvements.  

* To calculate profit for a particular classification model applied to the validation data, remember that each donor donates $14.50 on average and each mailing costs $2. So, to find an “ordered profit function” (ordered from most likely donor to least likely):

  * Calculate the posterior probabilities for the validation dataset;
  
  * Sort DONR in order of the posterior probabilities from highest to lowest;
  
  * Calculate the cumulative sum of (14.5  DONR – 2) as you go down the list.

Then find the maximum of this profit function. The R script file “TeamProjectEx.R” describes how to do this.

* To classify DONR responses in the test dataset you need to account for the “weighted sampling” (sometimes called “over-sampling”). Since the validation data response rate is 0.5 but the test data response rate is 0.1, the optimal mailing rate in the validation data needs to be adjusted before you apply it to the test data. Suppose the optimal validation mailing rate (corresponding to the maximum profit) is 0.7:

  * Adjust this mailing rate using 0.7/(0.5/0.1) = 0.14;

  * Adjust the “non-mailing rate” using (1–0.7)/((1–0.5)/(1–0.1)) = 0.54;

  * Scale the mailing rate so that it is a proportion: 0.14/(0.14+0.54) = 0.206.

The optimal test mailing rate is thus 0.206. The R script file “TeamProjectEx.R” provides full details of how to do this adjustment. Further details are available at http://blog.data-miners.com/2009/09/adjusting-for-oversampling.html. (If copying and pasting this link is unsuccessful, please type it in. It is a valid link.)

