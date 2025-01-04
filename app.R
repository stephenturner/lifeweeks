library(shiny)
library(ggplot2)

# UI for the application
ui <- fluidPage(
  titlePanel("Your Life in Weeks"),

  sidebarLayout(
    sidebarPanel(
      dateInput("birthday", "Enter your Date of Birth:", value = Sys.Date() - 30 * 365.25, format = "yyyy-mm-dd"),
      downloadButton("download_plot", "Download PDF")
    ),

    mainPanel(
      plotOutput("life_plot", height = "600px", width = "400px") # Adjust the aspect ratio of the preview
    )
  )
)

# Server logic
server <- function(input, output) {
  # Reactive data to calculate weeks lived
  life_data <- reactive({
    today <- Sys.Date()
    birthday <- input$birthday

    # Time lived
    days_lived <- as.numeric(difftime(as.Date(today), as.Date(birthday)))
    years_lived <- days_lived / 365.25
    weeks_lived <- round(years_lived * 52)

    total_weeks <- 52 * 90 # Assuming 90 years lifespan

    data.frame(
      week = 1:total_weeks,
      lived = c(rep(TRUE, weeks_lived), rep(FALSE, total_weeks - weeks_lived))
    )
  })

  # Generate the plot
  generate_plot <- function(data) {
    data$year <- (data$week - 1) %/% 52
    data$week_of_year <- (data$week - 1) %% 52 + 1

    ggplot(data, aes(x = week_of_year, y = -year, fill = lived)) +
      geom_tile(color = "black", width = 0.8, height = 0.8) + # Increased whitespace between blocks
      scale_fill_manual(values = c("TRUE" = "gray30", "FALSE" = "white")) + # Darker red
      scale_y_continuous(breaks = seq(0, -90, by = -10), labels = abs(seq(0, -90, by = -10))) +
      theme_minimal() +
      labs(title = "Your Life in Weeks", x = "Week of the Year", y = "Age (Years)") +
      theme(
        axis.text.y = element_text(size = 10),
        axis.text.x = element_text(size = 8),
        panel.grid = element_blank(),
        legend.position = "none" # Remove the legend
      )
  }

  # Render the preview plot
  output$life_plot <- renderPlot({
    data <- life_data()
    generate_plot(data)
  }, height = 800, width = 600) # Match the aspect ratio of the PDF

  # Downloadable plot as PDF
  output$download_plot <- downloadHandler(
    filename = function() { "life_in_weeks.pdf" },
    content = function(file) {
      pdf(file, width = 8.5, height = 11) # Standard letter size
      data <- life_data()
      print(generate_plot(data))
      dev.off()
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
