library(shiny)
library(ggplot2)
library(dplyr)


ui <- fluidPage(
  titlePanel(title = "USA Census Visualization",
             windowTitle = "US Census Viz"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Creates demographic maps with info from the 2010 census"),
      
      selectInput(
        inputId = "list",
        label = "Choose a variable from dropdown menu",
        choices = c("Percent White", 
                    "Percent Black ", 
                    "Percent Latino", 
                    "Percent Asian")
      ) 
    ),
    mainPanel(
      #textOutput( outputId = "text"      ),
      plotOutput( outputId = "map"))
  )
 
  
)

server <- function(input, output) {
  
  #x <- reactive({input$list})  output$text <- renderText({    x()  })
  
  data <- reactive({
    counties <- readRDS("counties.rds")
    counties_map <- map_data("county")
    counties_map$name <- paste(counties_map$region,
                               counties_map$subregion, 
                               sep = ",")
    counties <- full_join(counties_map,counties)
  })
  
  output$map <- renderPlot({
    race <- switch (input$list,
                    "Percent White" = data()$white, 
                    "Percent Black " =data()$black,
                    "Percent Latino" =data()$hispanic,
                    "Percent Asian"= data()$asian)
    
    title <- switch (input$list,
                            "Percent White" = "% white", 
                            "Percent Black " = "% black",
                            "Percent Latino" ="% hispanic",
                            "Percent Asian"= "% asian")
    
    ggplot(data(), aes(x = long, y = lat, fill = race, group = group)) +
      geom_polygon(color = "black") +
      scale_fill_gradient(low = "white", high = "darkred", guide = F) +
      ggtitle(title)
    
  })
}

shinyApp(ui, server)