
#' @export
mapp_points <- function(x) {
  st_as_sf(x, coords = c("longitude", "latitude"), crs = 4326)
}

#' @export
mapp_centre <- function(x) {
  x[, .(X = median(longitude), Y = median(latitude))]
}

#' @export
mapp_last_points <- function(x) {
  x[, last_date := max(locationDate), by = tagID]
  o <- unique(x[locationDate == last_date, .(latitude, longitude, tagID, last_date)])[, i := 1:.N, tagID]
  o <- o[i == 1][, i := NULL]


  o[, label := paste(tagID,
    format(last_date, "%d-%b-%y %H:%M"),
    sep = "<br>"
  )]

  o
}

#' @export
map_lines <- function(x) {
  # x is mapp_points(d)
  x |>
    dplyr::group_by(tagID, col) |>
    dplyr::summarise(do_union = FALSE, .groups = "keep") |>
    sf::st_cast("LINESTRING")
}