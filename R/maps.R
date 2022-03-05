
#' @export
leaflet_map <- function(tiles = "OpenStreetMap.Mapnik", 
                        logo_img = 'https://leafletjs.com/docs/images/logo-ua.png', 
                        logo_url = 'https://leafletjs.com/' ) {
  leaflet(options = leafletOptions(zoomControl = TRUE)) |>
    addProviderTiles(tiles) |>
    leafem::addMouseCoordinates() |>
    leafem::addLogo(img = logo_img,
      position = "topright",
      width = 290, offset.x = 1, offset.y = 1, url = logo_url
    ) |>
    addDrawToolbar(
      targetGroup = "draw",
      editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions())
    )
}