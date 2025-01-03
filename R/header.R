
# Define the add-in function
insert_header_addin <- function() {

  # Load required libraries
  library(shiny)
  library(rstudioapi)

  # Shiny gadget UI
  ui <- fluidPage(
    titlePanel("Insert Header"),
    sidebarLayout(
      sidebarPanel(
        textInput("programname", "Program Name:", placeholder = "programname.R"),
        textInput("study", "Study:", placeholder = "ICTUSTUDYNAME"),
        textInput("purpose", "Purpose:", placeholder = "Produce the table of demographics for DMEC report"),
        textInput("output", "Output:", placeholder = "Add any files your program will produce, e.g. log files and rtfs"),
        textInput("author", "Author:", placeholder = "Your Name"),
        textInput("date", "Date:", value = format(Sys.Date(), "%d-%b-%Y")),
        actionButton("insert", "Insert Header"),
        actionButton("cancel", "Cancel")
      ),
      mainPanel(
        verbatimTextOutput("preview")
      )
    )
  )

  # Shiny gadget server
  server <- function(input, output, session) {

    # Create a reactive expression for the header preview
    header_preview <- reactive({
      paste0(
        "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#\n",
        "#........................................................................\n",
        "#............ __           ___         ______          _  _  ............\n",
        "#............ ||          //             ||           ||  || ............\n",
        "#............ ||         (               ||           (|  |) ............\n",
        "#............ ||    o     \\\\__     o     ||     o      \\__/  ............\n",
        "#........................................................................\n",
        "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#\n",
        "# \n Program Name: ", input$programname, "\n",
        "# \n",
        "# Study: ", input$study, "\n",
        "# \n",
        "# Purpose: ", input$purpose, "\n",
        "# Output: ", input$output, "\n",
        "# \n",
        "# Author : ", input$author, "\n",
        "# Date   : ", input$date, "\n",
        "# \n",
        "#------------------------------------------------------------------------\n",
        "# Change Log: \n",
        "# \n",
        "# Change ID: \n",
        "# Date:    \n",
        "# Description: \n",
        "# \n",
        "#------------------------------------------------------------------------\n"


      )
    })

    # Render the preview in the main panel
    output$preview <- renderText({
      header_preview()
    })

    # Insert the header into the active R script when the Insert button is clicked
    observeEvent(input$insert, {
      header <- header_preview()
      rstudioapi::insertText(header)
      stopApp() # Close the gadget
    })

    # Cancel the gadget
    observeEvent(input$cancel, {
      stopApp() # Close the gadget without doing anything
    })
  }

  # Launch the Shiny gadget
  runGadget(ui, server, viewer = dialogViewer("Insert Header"))
}
