# Predicting All-NBA Teams
## Requirements
* R
    - kknn
    - e1071
    - rpart
    - randomForest
    - caret
    - C50
    - neuralnet
    - Optional
        + tidyr
        + purrr
* Python 3.x with
    - Requests
    - Beautiful Soup

## Running the Classifier
To run:
* Run `scrape.sh` to grab the most recent data from https://www.basketball-reference.com/
* Open **preprocessing.R** and specify
    * If you are using per100 stats or per36 stats
    * If you are including any snubs
* If you want to generate any graphs or do any data analysis, you can run **EDA.R**
* Open **classify.R** and set the `this_year` variable to be the current season
* Running **classify.R** will provide info about the results of the classifiers and will output the All NBA probabilities into **classified.csv**