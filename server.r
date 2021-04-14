library(shiny)
library(dplyr)
library(rvest)
library(tidyverse)
library(stringr)
library(ggplot2)
library(DT)
base_url<- "http://www.imdb.com"
url250 <- "https://www.imdb.com/chart/top?ref_=nv_mv_250_6"

imdb_250 <- read_html(url250)

movie_list <- imdb_250 %>%
  html_nodes(".titleColumn a") %>%
  html_text()
head(movie_list)
movie_year<- gsub(")","", gsub("\\(","", 
                               imdb_250 %>%
                                 html_nodes(".secondaryInfo") %>%
                                 html_text()))

rate <- imdb_250 %>%
  html_nodes("strong") %>%
  html_text() %>%
  as.numeric()

all_nodes<-html_nodes(imdb_250, ".titleColumn a")


key_cast<- sapply(html_attrs(all_nodes),'[[','title')
movie_link <- paste0(base_url,sapply(html_attrs(all_nodes),'[[','href'))

rank <- c(1:length(movie_link))

x<- html_nodes(imdb_250, ".ratingColumn strong")
voters_count<- gsub(".*?based on ","",gsub(" user ratings.*","",x))

db_250 = data.frame(rank, movie_list, key_cast, movie_year, rate, voters_count)


function(input, output, session) {

  output$table <- renderDataTable(
    DT::datatable({
      db_250 %>%
        filter(rate<=input$rate[2] & rate>=input$rate[1])
  })
  )
  output$plot1 <- renderPlot({
    db_250 %>%
      group_by(movie_year) %>%
      summarise(number=n()) %>%
      arrange(desc(number)) %>%
      top_n(10,number) %>%
      ggplot(aes(movie_year,number,fill=movie_year))+
      geom_bar(stat='identity')+
      theme_bw()+
      coord_flip()+
      theme(
        legend.position = 'none',
        axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=15,color='black'),
        legend.text=element_text(size=12),
        plot.title = element_text(size = 20, face = "bold"))
    
  })
  
}


