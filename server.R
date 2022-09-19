#Author: Scott Lee
#Title: Near Earth Object (NEO) Visualization
# Date of Last Edit: 18 April 2022

#NEO = Near Earth Object as defined by NASA.
#An asteroid or commet projected to pass within 1.3 astronomical units of the Earth

#Pre processing
df <- read.csv("neo_data.csv")
library(shiny)
library(tidyverse)

#Pre processing data
df <- df %>% 
    rename(
        Year = Close.Approach.Date.and.Time,
        Error_Minutes = Close.Approach.Time.Error,
        Nominal_Distance = Close.Approach.Nominal.Distance.LD,
        Min_Distance = Close.Approach.Minimum.Distance.LD,
        Min_Distance_Category = Minimum.Distance.Category,
        Min_Diameter = Diameter.Min..m.,
        Max_Diameter  =Diameter.Max..m.,
        NEO_Size_Category = NEO.Size.Category,
        Rel_Velocity = Relative.Velocity..km.s.,
        Inf_Velocity = V.Infinity..km.s.,
        Rel_Velocity_Category = Relative.Velocity.Category,
        Abs_Magnitude = Absolute.Magnitude..mag.
    )    %>% 
    filter(Min_Distance_Category == "Close")



NeoData <- df

# Main function

shinyServer(function(input, output) {
    
    #Application title
    titlePanel('Are We at Risk of a Serious Astriod Strike?
               Visualising Near Earth Objects')
    
    # -------------------------------------------------------------------
    # Single zoomable plot (on left)
    ranges <- reactiveValues(x = NULL, y = NULL)
    
    output$plot1 <- renderPlot({
        
        #DEV
        df_vel = df[,c("Year", "Min_Distance", "Rel_Velocity")]
        #DEV
        #Scatter plot
        ggplot(df_vel, aes(Min_Distance, Rel_Velocity)) + # DEV Change df_vel back to df if crash
            geom_point(color = 'green') +
            coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE) + 
            xlab("Distance from Earth (LD)") +
            ylab("Relative Velocity (km/s)")
    })
    
    #DEV##################
    df_vel = df[,c("Year", "Min_Distance", "Rel_Velocity")]
    output$click_info <- renderPrint({
        nearPoints(df_vel, input$plot1_click, addDist=TRUE)
    })
    #DEV##################
    
    # When a double-click happens, check if there's a brush on the plot.
    # If so, zoom to the brush bounds; if not, reset the zoom.
    observeEvent(input$plot1_dblclick, {
        brush <- input$plot1_brush
        if (!is.null(brush)) {
            ranges$x <- c(brush$xmin, brush$xmax)
            ranges$y <- c(brush$ymin, brush$ymax)
            
        } else {
            ranges$x <- NULL
            ranges$y <- NULL
        }
    })
    
    # -------------------------------------------------------------------
    # Linked plots (middle and right)
    ranges2 <- reactiveValues(x = NULL, y = NULL)
    
    output$plot2 <- renderPlot({
        ggplot(df, aes(Min_Distance, Max_Diameter)) +
            geom_point(color = 'blue') +
            xlab("Minimum Distance to Earth (LD)") +
            ylab("Max Diameter of NEO (m)")
    })
    
    output$plot3 <- renderPlot({
        ggplot(df, aes(Min_Distance, Max_Diameter)) +
            geom_point(color = 'blue') +
            #DEV
            #DEV
            coord_cartesian(xlim = ranges2$x, ylim = ranges2$y, expand = FALSE) +
            xlab("Minimum Distance to Earth (LD)") +
            ylab("Max Diameter of NEO (m)")
    })
    
    # When a double-click happens, check if there's a brush on the plot.
    # If so, zoom to the brush bounds; if not, reset the zoom.
    observe({
        brush <- input$plot2_brush
        if (!is.null(brush)) {
            ranges2$x <- c(brush$xmin, brush$xmax)
            ranges2$y <- c(brush$ymin, brush$ymax)
            
        } else {
            ranges2$x <- NULL
            ranges2$y <- NULL
        }
    })
    
    
    output$NeoPlot <- renderPlot({
        
        #Create new df, as the above df was filtered. 
        #This will be the complete data set. 
        df_full <- read.csv('neo_data.csv')
        df_full <- df_full %>%
            rename(Min_Distance_Category = Minimum.Distance.Category)
        
        #If statement
        if (input$variable == "Close") {
            x <- filter(df_full, Min_Distance_Category == 'Close')
            x <- x[,3]
            bins <- seq(min(x), max(x), length.out = input$bins + 1)
        }
        else if (input$variable == "Mid-Distance"){
            x <- filter(df_full, Min_Distance_Category == 'Mid-Distance')
            x <- x[,3]
            bins <- seq(min(x), max(x), length.out = input$bins + 1)
        }
        else if (input$variable == "Far Away"){
            x <- filter(df_full, Min_Distance_Category == 'Far Away')
            x <- x[,3]
            bins <- seq(min(x), max(x), length.out = input$bins + 1)
        }
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'red', border = 'white',
             main = 'Histogram of Near Earth Objects Per Year', xlab = 'Year',
             ylab = "Number of Near Earth Objects")
        
    })
})

