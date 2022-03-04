
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



#' @import data.table shiny RMariaDB methods glue stringr shinytoastr shinyWidgets shinybusy miniUI leaflet leaflet.extras fasttime geodist sf 
NULL

#' @importFrom geodist geodist
#' @importFrom shinytoastr toastr_error
NULL
