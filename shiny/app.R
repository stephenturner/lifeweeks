library(shiny)
library(ggplot2)


# UI for the application
ui <- fluidPage(
  titlePanel("Your Life in Weeks"),

  # Subtitle below the title
  fluidRow(
    column(12,
           tags$p(
             tags$a("View source code on GitHub", href = "https://github.com/stephenturner/lifeweeks", target = "_blank", style = "font-size: 16px; color: #007bff; text-decoration: underline;")
           )
    )
  ),

  # Input above the plot
  fluidRow(
    column(12,
           dateInput(
             "birthday",
             "Enter your Date of Birth:",
             value = Sys.Date() - 30 * 365.25,
             format = "yyyy-mm-dd"
           ),
           downloadButton("download_plot", "Download PDF"),
           tags$br(),
           tags$br()
    )
  ),

  # Plot below the input
  fluidRow(
    column(12,
           plotOutput("life_plot", height = "1100px", width = "850px") # Larger preview size
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
    filename = function() { "lifeweeks.pdf" },
    content = function(file) {
      data <- life_data()
      p <- generate_plot(data)
      ggsave(file, plot=p, width=8.5, height=11)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
