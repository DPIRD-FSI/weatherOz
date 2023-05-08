
#' Construct a list of options to pass to the DPIRD API
#'
#' @param station_code
#' @param start_date_time
#' @param end_date_time
#' @param api_key
#' @param interval
#' @param limit
#' @param which_values
#' @param group
#' @return A `list` object of values to be passed to a [crul] object to query
#'  the \acronym{DPIRD} Weather 2.0 \acronym{API}.
#' @keywords internal
#' @noRd
.build_query <- function(station_code,
                         start_date_time,
                         end_date_time,
                         api_key,
                         interval,
                         limit,
                         which_values,
                         group) {
  if (interval == "minute") {
    query_list <- list(
      startDateTime = start_date_time,
      endDateTime = end_date_time,
      api_key = api_key,
      select = paste(which_values, collapse = ","),
      limit = 1000
    )
  } else if (interval %in% c("15min", "30min", "hourly")) {
    query_list <- list(
      stationCode = station_code,
      startDateTime = format(first, "%Y-%m-%d"),
      endDateTime = format(last + lubridate::days(1), "%Y-%m-%d"),
      interval = interval,
      select = which_values,
      limit = 1000,
      group = all,
      api_key = api_key
    )
  } else if (interval == "daily") {
    query_list <- list(
      stationCode = station_code,
      startDateTime = format(first, "%Y-%m-%d"),
      endDateTime = format(last, "%Y-%m-%d"),
      select = which_values,
      limit = 1000,
      group = all,
      api_key = api_key
    )
  } else if (interval == "monthly") {
    query_list <- list(
      stationCode = station_code,
      startDateTime = format(first, "%Y-%"),
      endDateTime = format(last, "%Y-%m"),
      limit = ceiling(as.double(
        difftime(
          format(last, "%Y-%m-%d"),
          format(first, "%Y-%m-%d"),
          units = "days"
        ) / 365
      ) * 12),
      select = which_values,
      group = all,
      api_key = api_key
    )
  }  else {
    query_list <- list(
      stationCode = station_code,
      startDateTime = format(first, "%Y"),
      endDateTime = format(last, "%Y"),
      select = which_values,
      limit = 1000,
      group = all,
      api_key = api_key
    )
  }

  return(query_list)
}

#' Query the DPIRD API using {crul}
#'
#' @param base_url the base URL for the API query
#' @param query_list a list of values in the API to query
#'
#' @return A `data.table` of data for manipulating before returning to the user
#'
#' @noRd
#' @keywords internal

.query_dpird_api <- function(.base_url,
                             .query_list) {
  client <- crul::HttpClient$new(url = .base_url)

  # nocov begin
  response <- client$get(query = .query_list,
                         retry = 6L,
                         timeout = 30L)

  # check to see if request failed or succeeded
  # - a custom approach this time combining status code,
  #   explanation of the code, and message from the server
  if (response$status_code > 201) {
    mssg <- jsonlite::fromJSON(response$parse("UTF-8"))$message
    x <- response$status_http()
    stop(sprintf("HTTP (%s) - %s\n  %s",
                 x$status_code,
                 x$message,
                 x$explanation),
         call. = FALSE)
  }

  response$raise_for_status()
  # create meta object
  dpird_stations <- jsonlite::fromJSON(response$parse("UTF8"))
  dpird_stations <- data.table::data.table(dpird_stations$collection)
}