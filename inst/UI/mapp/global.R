
#' shiny::runApp('./inst/UI/mapp', launch.browser =  TRUE)
# https://fontawesome.com/v5.15/icons?d=gallery&p=2

# Settings
sapply(
  c(
    "data.table", "glue",
    "shiny", "shinytoastr", "shinyWidgets", "waiter",
    "miniUI", "leaflet", "leaflet.extras",
     "sf"
  ),
  function(x) require(x, character.only = TRUE, quietly = TRUE)
)


# SETTINGS 
  options(mapps.host = "127.0.0.1")
  options(mapps.db = "tests")
  options(mapps.user = "testuser")
  options(mapps.pwd = "testuser")
  dbtable = "argos"

  projName = "argos test"

# VARIABLES
  # general
  tiles = "OpenStreetMap.Mapnik"
  
  f = system.file("mpio_logo.txt", package = "mapps")
  logo_base64 = readChar(f, file.info(f)$size)
  
  URL = "https://www.bi.mpg.de/kempenaers"
  

  # project specific
  ids = DBq(glue("SELECT DISTINCT tagID from {dbtable}"))$tagID
  
  info_path = "md.csv"
  
