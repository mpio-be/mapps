
#' @export
leaflet_map <- function(tiles = "OpenStreetMap.Mapnik", 
                        logo = 'https://leafletjs.com/docs/images/logo-ua.png', 
                        url = 'https://leafletjs.com/' ) {
  leaflet(options = leafletOptions(zoomControl = TRUE)) |>
    addProviderTiles(tiles) |>
    leafem::addMouseCoordinates() |>
    leafem::addLogo(logo,
      position = "topright",
      width = 290, offset.x = 1, offset.y = 1, url = url
    ) |>
    addDrawToolbar(
      targetGroup = "draw",
      editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions())
    )
}