# Load required libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(gapminder)

# Print custom message with a link
cat("Starting my Shiny application.\n\nVisit http://localhost:8082 to access the application.\n")

# Print Author
cat("
            _  __       _ _     _                       _
  __ _ _ __(_)/ _|_   _| (_)___| | __ _ _ __ ___   __ _| |_   ___ ___   _ __ ___
 / _` | '__| | |_| | | | | / __| |/ _` | '_ ` _ \\ / _` | __| / __/ _ \\ | '_ ` _ \\
| (_| | |  | |  _| |_| | | \\__ \\ | (_| | | | | | | (_| | |_ | (_| (_) || | | | | |
 \\__,_|_|  |_|_|  \\__,_|_|_|___/_|\\__,_|_| |_| |_|\\__,_|\\__(_)___\\___/||_| |_| |_|
")

# Specify the application port
options(shiny.host = "0.0.0.0")
options(shiny.port = 8082)

# Define the user interface layout
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      tags$h4("Gapminder Dashboard"),
      tags$hr(),
      selectInput(inputId = "selectedContinent", label = "Select Continent", 
                  choices = unique(gapminder$continent), selected = "Europe")
    ),
    mainPanel(
      plotOutput(outputId = "plotLifeExpectancy"),
      plotOutput(outputId = "plotGDP")
    )
  )
)

# Define the server logic
server <- function(input, output, session) {
  # Filter data based on selected continent and calculate summary statistics
  filtered_data <- reactive({
    gapminder %>%
      filter(continent == input$selectedContinent) %>%
      group_by(year) %>%
      summarise(
        AvgLifeExp = round(mean(lifeExp)),
        AvgGdpPercap = round(mean(gdpPercap), digits = 2)
      )
  })

  # Define common theme for plots
  chart_theme <- ggplot2::theme(
    plot.title = element_text(hjust = 0.5, size = 20, face = "bold"),
    axis.title.x = element_text(size = 15),
    axis.title.y = element_text(size = 15),
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12)
  )

  # Render Life Expectancy plot
  output$plotLifeExpectancy <- renderPlot({
    ggplot(filtered_data(), aes(x = year, y = AvgLifeExp)) +
      geom_col(fill = "#0099f9") +
      geom_text(aes(label = AvgLifeExp), vjust = 2, size = 6, color = "#ffffff") +
      labs(title = paste("Average Life Expectancy in", input$selectedContinent)) +
      theme_classic() +
      chart_theme
  })

  # Render GDP plot
  output$plotGDP <- renderPlot({
    ggplot(filtered_data(), aes(x = year, y = AvgGdpPercap)) +
      geom_line(color = "#f96000", size = 2) +
      geom_point(color = "#f96000", size = 5) +
      geom_label(
        aes(label = AvgGdpPercap),
        nudge_x = 0.25,
        nudge_y = 0.25
      ) +
      labs(title = paste("Average GDP per Capita in", input$selectedContinent)) +
      theme_classic() +
      chart_theme
  })
}

# Save the current stdout connection
old_stdout <- stdout()

# Redirect stdout to null device
sink(NULL, type = "message")

# Run the Shiny app server
shinyApp(ui = ui, server = server, options = list(silent = TRUE))

# Restore the original stdout connection
sink(old_stdout)
