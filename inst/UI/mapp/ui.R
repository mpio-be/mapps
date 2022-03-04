

mappUI <- function(projectName = "", ids) {
  miniPage(
    title = projectName,
    useToastr(),
    add_busy_spinner(
      position = "top-left",
      spin = "radar",
      color = "#d1360f",
      onstart = FALSE,
      margins = c(20, 50)
    ),
    miniTitleBar(projectName,
      left =
        textOutput("lastUpdate", a),
      right =

        dropdown(
          right = TRUE,
          size = "lg",
          style = "stretch",
          status = "primary",
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
            checkIcon = list(yes = icon("check-square"), no = icon("square-o"))
          ),
          pickerInput(
            inline = FALSE,
            inputId = "tagIDs",
            label = NULL,
            choices = ids$tagID,
            selected = ids$tagID,
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
      miniTabPanel("Map", icon = icon("map-o"), miniContentPanel(
        padding = 0,
        leafletOutput("MAP", width = "100%", height = "100%")
      )),
      miniTabPanel("Summary", icon = icon("table"), miniContentPanel(
        dataTableOutput("summary")
      )),
      miniTabPanel("Help", icon = icon("info-circle"), miniContentPanel(
        HTML("
        <ul>
        
        <li>Lines connect most of the points but some outliers (not all) are avoided. </li>
        <li>Time zone is UTC.</li>
        <li>The <a style='color:#EE3377'>pulsing dots</a> show the last location for each bird.</li>
        <li>You can use the tools on the tool-bar to measure distances, areas, etc on the map. </li>
        
        </ul>

        ")
      ))
    )
  )
}

mappUI(projectName = projName, ids = ids)