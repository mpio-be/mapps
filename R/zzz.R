
#' @title       Map apps
#' @name        mapps
#' @description Building blocks for simple map web apps using shiny and MariaDB
#' @docType     package
NULL



.onAttach <- function(libname, pkgname) {
  dcf <- read.dcf(file = system.file("DESCRIPTION", package = pkgname))
  packageStartupMessage(paste("This is", pkgname, dcf[, "Version"]))

  # see ./inst/install_testdb.sql
  options(mapps.host = "127.0.0.1")
  options(mapps.db = "tests")
  options(mapps.user = "testuser")
  options(mapps.pwd = "testuser")
}



#' @import data.table  RMariaDB methods glue sf
NULL
#' @import shiny shinyWidgets waiter miniUI leaflet leaflet.extras  
NULL
#' @import leaflet leaflet.extras  
NULL

#' @importFrom geodist geodist
NULL
#' @importFrom shinytoastr useToastr toastr_error
NULL
