
#' @export
mappUI <- function(projectName = "", ids, days_before = 30, 
                  help = system.file('help.md', package = 'mapps') ) {
  miniPage(
    title = projectName,
    useToastr(),
    autoWaiter(),
    miniTitleBar(projectName,
      left = htmlOutput(outputId = "upper_left_feedback"),
      right =

        dropdown(
          right = TRUE,
          size = "lg",
          style = "stretch",
          status = "danger",
          icon = icon("cogs"),
          airDatepickerInput("mindate", NULL,
            dateFormat = "dd-mm-yy",
            value = Sys.Date() - days_before,
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

      includeMarkdown(help)

      ))
    )
  )
}
