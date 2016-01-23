library(shiny)
library(scatterplot3d)
data(mtcars)

modelFit <- lm(mpg ~ hp + cyl + wt, data=mtcars)

mpg <- function(hp, cyl, wt) {
    modelFit$coefficients[1] + modelFit$coefficients[2] * hp + 
        modelFit$coefficients[3] * cyl + modelFit$coefficients[4] * wt
}

shinyServer(
    function(input, output) {
        adjusted_weight <- reactive({input$wt/1000})
        predicted_mpg <- reactive({mpg(input$hp, as.numeric(input$cyl), adjusted_weight())})
        output$inputValues <- renderPrint({paste(input$cyl, "cylinders, ",
                                                 input$hp, "horsepower, ",
                                                 input$wt, "lbs")})
        output$prediction <- renderPrint({paste(round(predicted_mpg(), 2), "miles per gallon")})
        output$plots <- renderPlot({
          
          # create column indicating point color
          mtcars$pcolor[mtcars$cyl==4] <- "red"
          mtcars$pcolor[mtcars$cyl==6] <- "blue"
          mtcars$pcolor[mtcars$cyl==8] <- "darkgreen"
          with(mtcars, {
            s3d <- scatterplot3d(hp, wt, mpg,                 # x y and z axis
                                 color=pcolor, pch=19,        # circle color indicates no. of cylinders
                                 type="h", lty.hplot=2,       # lines to the horizontal plane
                                 scale.y=.75,                 # scale y axis (reduce by 25%)
                                 main="3-D Scatterplot (Hp, weight vs mpg)",
                                 xlab="Horse Powers",
                                 ylab="Weight (lb/1000)",
                                 zlab="Miles/(US) Gallon")
            s3d.coords <- s3d$xyz.convert(hp, wt, mpg)
            text(s3d.coords$x, s3d.coords$y,                  # x and y coordinates
                 labels=row.names(mtcars),                    # text to plot
                 pos=4, cex=.5)                               # shrink text 50% and place to right of points)
            # add the legend
            legend("topleft", inset=.05,                      # location and inset
                   bty="n", cex=.5,                           # suppress legend box, shrink text 50%
                   title="Number of Cylinders",
                   c("4", "6", "8"), fill=c("red", "blue", "darkgreen")) 
            s3d$points3d(input$hp, adjusted_weight(), predicted_mpg(), col='magenta', cex=2, pch=8)
          })

        })
    }
)