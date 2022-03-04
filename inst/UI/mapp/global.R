
#' shiny::runApp('./inst/UI/mapp', launch.browser =  TRUE)

# Settings
sapply(
  c(
    "data.table", "glue",
    "shiny", "shinytoastr", "shinyWidgets", "shinybusy",
    "miniUI", "leaflet", "leaflet.extras",
     "sf"
  ),
  function(x) require(x, character.only = TRUE, quietly = TRUE)
)

require(mapps)
require(glue)
require(miniUI)


# SETTINGS 
  options(mapps.host = "127.0.0.1")
  options(mapps.db = "tests")
  options(mapps.user = "testuser")
  options(mapps.pwd = "testuser")
  dbtable = "argos"

  projName = "argos test"

# VARIABLES
  ids = DBq(glue("SELECT DISTINCT tagID from {dbtable}"))

# FUNCTIONS
  mapp_data <- function(input) {

    sql = glue("SELECT DISTINCT tagID, latitude, longitude, locationDate
              FROM {dbtable} WHERE
                locationDate >= '{input$mindate}'")
    
    if (!is.null(input$tagIDs)) {
      sql = glue("{sql} AND tagID in ({paste(input$tagIDs, collapse = ',')})")
    }

    if (!is.null(input$locationClass)) {
      sql = glue("{sql} AND locationClass in ({paste(input$locationClass|>shQuote(), collapse = ',')})")
    }

   DBq(sql)

  }

  mapp_points <- function(x) {
      x[, label := paste(paste(tagID, sep = "-"),
        format(locationDate, "%d-%b-%y %H:%M"),
        sep = "<br>"
      )]
      x[, col := "red"]
      st_as_sf(x, coords = c("longitude", "latitude"), crs = 4326)
  }

  mapp_centre <- function(x) {
    x[, .(X = median(longitude), Y = median(latitude))] 
  }

  mapp_last_points <- function(x) {
    
    x[, last_date := max(locationDate), by = tagID]
    o <- unique(x[locationDate == last_date, .(latitude, longitude, tagID, last_date)])[, i := 1:.N, tagID]
    o <- o[i == 1][, i := NULL]


    o[, label := paste( tagID,
      format(last_date, "%d-%b-%y %H:%M"),
      sep = "<br>"
    )]

    o

  }
