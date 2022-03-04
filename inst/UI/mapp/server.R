
# mapps::mappServer


#' Shiny server function
#'
#' @param input     Shiny server
#' @param output    Shiny server
#' @param session   Shiny server
#'
#' @export
#' @note hardwired objects expected to be defined in global.R: dbtable
#'
mappServer <- function(input, output, session) {
  observe(on.exit(assign("input", reactiveValuesToList(input), envir = .GlobalEnv)))


  output$lastUpdate <- renderText({
    invalidateLater(1500, session)
    
    paste("Next update in zzz" )
  })


  map <- leaflet_map()



  output$MAP <- renderLeaflet(map)

  observeEvent(list(input$mindate, input$tagIDs, input$locationClass), {

    # DATA
    d <- mapp_data(input)

    if (nrow(d) > 0) {
      
      p = mapp_points(d)
      xy = mapp_centre(d)
      last_pts = mapp_last_points(d)

      # MAP
      leafletProxy("MAP") |>
        clearMarkers() |>
        clearShapes() |>
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
    activeData() |> activity_summary()
  })
}