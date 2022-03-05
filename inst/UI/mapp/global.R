
#' shiny::runApp('./inst/UI/mapp', launch.browser =  TRUE)
# https://fontawesome.com/v5.15/icons?d=gallery&p=2


# SETTINGS 
  require(mapps)
  options(mapps.host = "127.0.0.1")
  options(mapps.db = "tests")
  options(mapps.user = "testuser")
  options(mapps.pwd = "testuser")
  dbtable = "argos"

  projName = "ARGOS test"

# VARIABLES
  # general
  tiles = "OpenStreetMap.Mapnik"
  
  f = system.file("mpio_logo.txt", package = "mapps")
  logo_base64 = readChar(f, file.info(f)$size)
  URL = "https://www.bi.mpg.de/kempenaers"
  
  ids = DBq(glue("SELECT DISTINCT tagID from {dbtable}"))$tagID
  
  info_path = "md.csv"
  
  days_before = 90
