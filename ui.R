#Author: Scott Lee
#Title: Near Earth Object (NEO) Visualization
# Date of Last Edit: 18 April 2022

#NEO = Near Earth Object as defined by NASA.
#An asteroid or comet projected to pass within 1.3 astronomical units of the Earth

#Load library, if not loaded on system, then run install.packages("ggplot2")
#In the command line.
library(shiny)
library(ggplot2)

# Define the shiny User Interface Functions
shinyUI(fluidPage(
    #Application title

    titlePanel('Visualising Near Earth Objects'),
    
    h3('What Are Near Earth Objects?'),
    h5("Near Earth Objects (NEOs) are objects in the solar system (like asteroids and comets) that are projected to travel within 1.3 Astronomical Units of the Earth (the distance between the Earth and the Sun)."),
    h5("Organisations like NASA track these objects, partially to monitor the risk of these NEOs colliding with the Earth."),
    h3("What is the point of paying attention to them?"),
    h5("The implications of NEO striks can be serious. An Asteroid approximatley 10-15 km across and travelling at a velocity of 30 km/s is believed to have made the Dinosaurs Extinct."),
    h5("Fortunately for us, the data will show that there's nothing anywhere near that big or that fast expected to hit us in the next 200 years."),
    
    
    #Use fluidRow so multiple displays can be organised on the one page
    fluidRow(
        #Histogram of number of NEOs per year.
        #Filtered by classification of "Close", "Mid-Distance", "Far".
        #This classification is defined in data wrangling and the report
        column(width = 10,
               sidebarLayout(
                   sidebarPanel(
                       sliderInput("bins",
                                   "Number of bins:",
                                   min = 20,
                                   max = 50,
                                   value = 35),
                       selectInput('variable', "Nearness to the Earth:",
                                   list("Close", 'Mid-Distance', 'Far Away'))
                   ),
                   # Plot of histogram
                   mainPanel(
                       h3(textOutput("caption")),
                       plotOutput("NeoPlot")
                   )
               )
        ),
        
        # DEV
        column(width = 6, h5("NEO of Interest",
                             verbatimTextOutput("click_info"))),
        # DEV
        
        # Setting up panels to plot the velocity vs mininum distance from earth charts
        column(width = 8, class = "well",
               h4("Velocity and Minimum Distance From Earth"),
               h5("Hold cursor over area of interest, then drag and double click to zoom."),
               h5("Click on a particular point if you find it interesting, and more information on this NEO will be displayted."),
               plotOutput("plot1", height = 300,
                          
                          #DEV
                          click = "plot1_click",
                          #DEV
                          
                          #double click function
                          dblclick = "plot1_dblclick",
                          #apply the brush function to allow the cursor to "brush" over the area of interest.
                          brush = brushOpts(
                              id = "plot1_brush",
                              resetOnNew = TRUE
                          )
               )
        ),
        # Plotting Min Distance to Earth and Max Diameter interactive plot. 
        column(width = 8, class = "well",
               h4("Minimum Distance to Earth and Max Diameter of NEO"),
               h5("The most concerning ones are those close to zero on the x-axis and a higher y-axis value (e.g. they're close to Earth and quite large."),
               h5('Look at the left plot, then click on it to show a zoomed in version on the right plot.'),
               fluidRow(
                   column(width = 6,
                          plotOutput("plot2", height = 300,
                                     
                                     #Enable brushing
                                     brush = brushOpts(
                                         id = "plot2_brush",
                                         resetOnNew = TRUE
                                     )
                          )
                   ),
                   
                   column(width = 6,
                          plotOutput("plot3", height = 300)
                   )
               )
        )
    ),
    h3('Concluding Remarks'),
    h5("Hopefully looking at the above has given you an appreciation for just how many Near Earth Objects there are in Space."),
    h5("Fortunatley for us, the vast majority of those that come near us will miss."),
    h5("Of the NEOs likely to hit the Earth over the next 200 years, they're all SIGNFICANTLY smaller and slower then the one that made the Dinosaurs Extinct, so it looks like we're safe for now!")
    
))