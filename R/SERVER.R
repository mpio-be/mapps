
#' Shiny server function
#'
#' @param input     Shiny server
#' @param output    Shiny server
#' @param session   Shiny server
#'
#' @export
#' @note hardwired objects expected to be defined in global.R: dbtable, tiles, logo_base64, URL, md.csv
#'

mappServer <- function(input, output, session) {
  # observe(on.exit(assign("input", reactiveValuesToList(input), envir = .GlobalEnv)))
  
  autoInvalidate <- reactiveTimer(120000) # reset map after two mins of inactivity

  observeEvent(list(input$mindate, autoInvalidate()), {
  
  output$upper_left_feedback <- renderUI({
  
    lastloc = glue('Last location: <span class="badge">{last_entry(dbtable)}</span> hours ago.')
    sset = glue(' Showing: last <span class="badge">{(Sys.Date() - as.Date(input$mindate) )}</span> days.')
    
    paste(lastloc, sset) |> HTML()
  
  })
   
  })


  map <- leaflet_map(tiles = tiles, logo_img = logo_base64, logo_url = URL)

  output$MAP <- renderLeaflet(map)

  observeEvent(list(input$mindate, input$individuals, input$locationClass, autoInvalidate()), {

    # DATA
    d <- mapp_data(input)

    if (nrow(d) > 0) {
      p <- mapp_points(d)
      xy <- mapp_centre(d)
      last_pts <- mapp_last_points(d)
      lines_ <- map_lines(p)

      # MAP
      leafletProxy("MAP") |>
        clearMarkers() |>
        clearShapes() |>
        addPolylines(data = lines_, weight = 2, color = ~col) |>
        addCircleMarkers(
          data = p, color = ~col, radius = 2,
          fillOpacity = 0.5, opacity = 0.5, popup = ~label
        ) |>
        addPulseMarkers(
          data = last_pts,
          lng = ~longitude, lat = ~latitude, popup = ~label,
          icon = makePulseIcon(heartbeat = 1.3, color = "rgba(238, 51, 119, 0.5)", iconSize = 9)
        ) |>
        setView(lng = xy$X, lat = xy$Y, zoom = 5)
    } else {
      toastr_error("The map did not change. Using the current settings no dataset can be prepared.")
    }
  })



  # Summary
  make_summary <- eventReactive(input$showSummary, {
    mapp_data(input) |> activity_summary()
  })

  output$summary <- renderDataTable(options = list(pageLength = 40, searchHighlight = TRUE), {
    make_summary()
  })

  # Info
  output$info <- renderDataTable(options = list(pageLength = 40, searchHighlight = TRUE), {


    fread("md.csv")
  })
}