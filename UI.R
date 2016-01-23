library(shiny)
shinyUI(pageWithSidebar(
    headerPanel('Predicting MPG'),
    sidebarPanel(
        h3('Instructions'),
        p('Enter your car Horse Powers, number of cylinders and weight; 
           the predicted MPG will be shown to the right and appear in
           the scatterplot as a magenta star'),
        h3('Enter MPG predictors:'),
        numericInput('hp', 'horsepower (HP):', 150, min = 50, max = 330, step = 10), 
        radioButtons('cyl', 'Number of cylinders:', c('4' = 4, '6' = 6, '8' = 8), selected = '6'), 
        numericInput('wt', 'Weight (lbs):', 3500, min = 1500, max = 5500, step = 100)
        ),
    mainPanel(
        h3('Predicted MPG'),
        h4('You entered:'),
        verbatimTextOutput("inputValues"),
        h4('resulting MPG:'),
        verbatimTextOutput("prediction"),
        h4('MPG compared to cars detailed in mtcars data set'),
        plotOutput('plots'),
        h3('Method'),
        p('The prediction is based on a linear model using mtcars dataset.
           The model relates the effect of horsepower, number of cylinders, and weight
           to MPG. The choice of number of cylinders is limited using a radio
           button to 4, 6 and 8 which are the only number of cyclinders considered
           in mtcars. The weight is pre converted to the unit expected by the model.')
        )
    ))
