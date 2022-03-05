
#' @export
mappUI <- function(projectName = "", ids) {
  miniPage(
    title = projectName,
    useToastr(),
    autoWaiter(),
    miniTitleBar(projectName,
      left = htmlOutput(outputId = "lastUpdate"),
      right =

        dropdown(
          right = TRUE,
          size = "lg",
          style = "stretch",
          status = "danger",
          icon = icon("cogs"),
          airDatepickerInput("mindate", NULL,
            dateFormat = "dd-mm-yy",
            value = Sys.Date() - 90,
            max = Sys.Date() + 1
          ),
          checkboxGroupButtons(
            inputId = "locationClass",
            size = "xs",
            label = NULL,
            choices = c(0:3, "A", "B", "Z"),
            selected = c(0:3, "A", "B"),
            status = "  ",
            justified = TRUE,
            checkIcon = list(yes = icon("check-square"), no = icon("square"))
          ),
          pickerInput(
            inline = FALSE,
            inputId = "individuals",
            label = NULL,
            choices = ids,
            selected = ids,
            multiple = TRUE,
            options = pickerOptions(
              virtualScroll = TRUE,
              actionsBox = TRUE,
              mobile = TRUE,
              windowPadding = "[0, 1, 80, 1]" # [top, right, bottom, left].
            )
          )
        )
    ),
    miniTabstripPanel(
      miniTabPanel("Map", icon = icon("map"), miniContentPanel(
        padding = 0,
        leafletOutput("MAP", width = "100%", height = "100%")
      )),
      miniTabPanel("Summary", icon = icon("table"), miniContentPanel(
        actionBttn(
          inputId = "showSummary",
          label = "Show summary"
        ),
        hr(),
        dataTableOutput("summary")
      )),
      miniTabPanel("Info", icon = icon("info"), miniContentPanel(
        dataTableOutput("info")
      )),
      miniTabPanel("Help", icon = icon("question-circle"), miniContentPanel(
        HTML("
        <ul>

        <li>Lines connect most of the points but some outliers (not all) are avoided. </li>
        <li>Time zone is UTC.</li>
        <li>The <a style='color:#EE3377'>pulsing dots</a> show the last location for each individual.</li>
        <li>You can use the tools on the tool-bar to measure distances, areas, etc on the map. </li>

        </ul>

        ")
      ))
    )
  )
}
