library(shiny)
library(DT)
fluidPage(
  headerPanel('IMDB TOP250'),
  fluidPage(
    fluidRow(
      column(3,
             sliderInput("rate", "rate",
                         min = 8.3, max = 9.7, value = c(8.3,9.7)),
      )
    ),
  ),
  fluidRow(
    column(10,
           DT::dataTableOutput('table')
    ),
  ),
  fluidRow(
    column(6,
           plotOutput(outputId = "plot1")
    )
  ),
)
