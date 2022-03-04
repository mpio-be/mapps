
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


#' last entry in db table (hh:mm:ss hours ago.)
#' @export
#' @examples
#' last_entry(test)
last_entry <- function(tab) {
  DBq(glue("
  SELECT CAST(
      TIMEDIFF(UTC_TIMESTAMP(), max(locationDate)
    ) AS CHAR) tdiff from {tab}"))$tdiff
}




#' UI interface to database
#' @param input a list containing "mindate", "tagIDs", "locationClass" and LocationDate".
#'        the input is usually defined within a shiny UI like [mapps::mappUI()].
#' @export
  mapp_data <- function(input) {
    sql <- glue("SELECT DISTINCT tagID, latitude, longitude, locationDate
              FROM {dbtable} WHERE
                locationDate >= '{input$mindate}'
                  ORDER BY locationDate, tagID")

    if (!is.null(input$tagIDs)) {
      sql <- glue("{sql} AND tagID in ({paste(input$tagIDs, collapse = ',')})")
    }

    if (!is.null(input$locationClass)) {
      sql <- glue("{sql} AND locationClass in ({paste(input$locationClass|>shQuote(), collapse = ',')})")
    }

    x <- DBq(sql)

    x[, label := glue_data(.SD, "{tagID} <br> {format(locationDate, '%d-%b-%y %H:%M')} ")]

    cols = c(
      "#059c6f", "#D95F02", "#382fb3", "#E7298A", "#5cac02", "#f7b603",
      "#a06c0a", "#0e0000", "#e02807"
    ) |>
      colorRampPalette()

    z <- x[, .N, tagID][, col := cols(.N)][, N := NULL]

    merge(x, z, by = "tagID", sort = FALSE)
  }