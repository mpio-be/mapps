
#' @export
mapp_points <- function(x) {
  o = st_as_sf(x, coords = c("longitude", "latitude"), crs = 4326)
  
  shiftlon = getOption("mapps.shift_longitude")

  if (!is.null(shiftlon) && shiftlon) {
    o = st_shift_longitude(o)
  }
  
  o
    
}

#' @export
mapp_centre <- function(x) {
  # x is mapp_points(d)
  st_union(x) |>
  st_centroid() |>
  st_coordinates() |>
  data.frame()
}

#' @export
mapp_last_points <- function(x) {
  # x is mapp_points(d)
  z = data.table(x)
  z[, last_date := max(locationDate), by = individual]
  z = cbind(z, st_coordinates(x))
  o <- unique(z[locationDate == last_date, .(latitude=Y, longitude=X, individual, last_date)])[, i := 1:.N, individual]
  o <- o[i == 1][, i := NULL]


  o[, label := paste(individual,
    format(last_date, "%d-%b-%y %H:%M"),
    sep = "<br>"
  )]

  o
}

#' @export
map_lines <- function(x) {
  # x is mapp_points(d)
  x |>
    dplyr::group_by(individual, col) |>
    dplyr::summarise(do_union = FALSE, .groups = "keep") |>
    sf::st_cast("LINESTRING")
}