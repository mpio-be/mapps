
#' shiny::runApp('./inst/UI/mapp', launch.browser =  TRUE)
# https://fontawesome.com/v5.15/icons?d=gallery&p=2

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
  ids = DBq(glue("SELECT DISTINCT tagID from {dbtable}"))$tagID

  tiles = "OpenStreetMap.Mapnik"
  system.file("logo.R", package = "mapps") |> source() # loads logo
  url = "https://www.bi.mpg.de/kempenaers"

# FUNCTIONS
