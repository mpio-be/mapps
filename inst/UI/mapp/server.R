
# mapps::mappServer


#' Shiny server function
#'
#' @param input     Shiny server
#' @param output    Shiny server
#' @param session   Shiny server
#'
#' @export
#' @note hardwired objects expected to be defined in global.R: dbtable, tiles, logo, url
#'
mappServer <- function(input, output, session) {
  observe(on.exit(assign("input", reactiveValuesToList(input), envir = .GlobalEnv)))

  output$lastUpdate <- renderUI({
    invalidateLater(120000, session)

    glue('
    Last entry
    <span class="badge">
    {last_entry(dbtable)}
    </span>
    hours ago.') |> HTML()
    
  })

  autoInvalidate <- reactiveTimer(120000) # reset map after two mins of inactivity

  map <- leaflet_map(tiles = tiles, logo = logo, url = url)

  output$MAP <- renderLeaflet(map)

  observeEvent(list(input$mindate, input$IDs, input$locationClass, autoInvalidate() ), {

    # DATA
    d <- mapp_data(input)

    if (nrow(d) > 0) {
      
      p = mapp_points(d)
      xy = mapp_centre(d)
      last_pts = mapp_last_points(d)
      lines_ = map_lines(p)

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
    } 
  
  })



  # Summary

  output$summary <- renderDataTable(options = list(pageLength = 40, searchHighlight = TRUE), {
  
  
    mapp_data(input) |> activity_summary()
  
  
  })




}