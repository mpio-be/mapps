
#' DB query
#' DB query using default parameters.
#' @return a data.table (also for errors). When in shiny query errors are captured by [shinytoastr::toastr_error()]
#' @export
#' @examples
#' DBq("SELECT 1")
#' DBq("SELECT err")
#' 
DBq <- function(x, 
  host     = getOption("mapps.host"), 
  user     = getOption("mapps.user"),
  password = getOption("mapps.pwd"),
  db       = getOption("mapps.db")
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
#' @param input a list containing "mindate", "individuals", "locationClass" and LocationDate".
#'        the input is usually defined within a shiny UI like [mapps::mappUI()].
#' @note a 'labels' dataframe should be loaded in global.R
#' @export
  mapp_data <- function(input) {
    sql <- glue("SELECT DISTINCT tagID as individual, latitude, longitude, locationDate
              FROM {dbtable} WHERE
                locationDate >= '{input$mindate}' ")

    if (!is.null(input$individuals)) {
      sql <- glue("{sql} AND tagID in ({paste(input$individuals, collapse = ',')})")
    }

    if (!is.null(input$locationClass)) {
      sql <- glue("{sql} AND locationClass in ({paste(input$locationClass|>shQuote(), collapse = ',')})")
    }

    sql = glue("{sql} ORDER BY locationDate")

    x <- DBq(sql)

 
    x[, label := glue_data(.SD, "{individual} <br> {format(locationDate, '%d-%b-%y %H:%M')} ")]

    cols = c(
      "#059c6f", "#D95F02", "#382fb3", "#E7298A", "#5cac02", "#f7b603",
      "#a06c0a", "#0e0000", "#e02807"
    ) |>
      colorRampPalette()

    z <- x[, .N, individual][, col := cols(.N)][, N := NULL]

    merge(x, z, by = "individual", sort = FALSE)
  }