

#' @export
speed_along <- function(x, .lat = "latitude", .lon = "longitude", .dt = "locationDate", .grp = "tagID", clean = TRUE) {
  setnames(x, c(.lat, .lon, .dt, .grp), c(".lat", ".lon", ".dt", ".grp"))
  setorder(x, .dt, .grp)
  x[, .deltaT := difftime(.dt,
    shift(.dt, type = "lag"),
    units = "hour"
  ), by = .(.grp)]

  x[, .dst := geodist::geodist(cbind(.lat, .lon), sequential = TRUE, pad = TRUE, measure = "cheap"),
    by = .grp
  ]

  x[, speed_kmh := (.dst / 1000) / (.deltaT %>% as.numeric())]

  setnames(x, c(".lat", ".lon", ".dt", ".grp"), c(.lat, .lon, .dt, .grp))

  if (clean) {
    x[, ":="(.dst = NULL, .deltaT = NULL)]
  }
}

#' @export 
activity_summary <- function(x, trending_N_days = 10) {

  # overall summaries
  s <- x[, .(N_pts = .N, First_location = min(locationDate), Last_loc = max(locationDate)),
    by = .(tagID)
  ]
  s[, days_since_deploy := difftime(Last_loc, First_location, units = "days") %>% round(digits = 1) %>% as.numeric()]
  s[, points_per_day := round(N_pts / days_since_deploy, 1)]
  s <- s[, .(tagID, Last_loc, days_since_deploy, points_per_day)]

  # add trending
  x[, date := yday(locationDate)]

  r <- x[date > yday(Sys.Date()) - trending_N_days, .N, by = .(tagID, date)]

  r <- r[, .(trending_N_days = {
    o <- try(lm(N ~ scale(date, scale = FALSE)), silent = TRUE)
    if (inherits(o, "try-error")) {
      o <- as.numeric(NA)
    } else {
      o <- coef(o)[2]
    }
    round(o, 1)
  }), by = tagID]

  setnames(r, "trending_N_days", glue("trending_{trending_N_days}_days"))

  s <- merge(s, r, all.x = TRUE, sort = FALSE, by = "tagID")

  setorder(s, Last_loc)
  s

}
