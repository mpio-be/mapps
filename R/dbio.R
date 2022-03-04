
#' DB query
#' DB query using default parameters.
#' @return a data.table (also for errors). When in shiny query errors are captured by [shinytoastr::toastr_error()]
#' @export
#' @examples
#' DBq("SELECT 1")
#' DBq("SELECT err")
#' 
DBq <- function(x, 
  host = getOption("mapps.host"), 
  user = getOption("mapps.user"),
  password = getOption("mapps.pwd"),
  db = getOption("mapps.db")
  ) {

  con <- DBI::dbConnect(MariaDB(),
    host = host,
    user = user,
    password = password,
    db = db
  )
  on.exit(DBI::dbDisconnect(con))
  
  if(! missing(db))
  DBI::dbExecute(con, paste("USE", db))
  

  o <- try(DBI::dbGetQuery(con, x), silent = TRUE)

  if (inherits(o, "try-error")) {
    err <- as.character(attributes(o)$condition)
    if (shiny::isRunning()) {
      toastr_error(err, "Query returned an error")

    }
    return(data.table(error = err))
  } else {
    return(data.table(o))
  }
}


#' db table checksum
#' @export
#' @examples
#' checksumtab(test)
#' 

checksumtab <- function(tab) {
  DBq(glue("CHECKSUM TABLE {tab}"))$Checksum
}
