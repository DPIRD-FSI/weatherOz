% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_dpird_summaries.R
\name{get_dpird_summaries}
\alias{get_dpird_summaries}
\title{Get DPIRD Weather Data in Summarised Formats}
\usage{
get_dpird_summaries(
  station_code,
  start_date,
  end_date = Sys.Date(),
  interval = "daily",
  values = "all",
  include_closed = FALSE,
  api_key
)
}
\arguments{
\item{station_code}{A \code{character} string of the \acronym{DPIRD} station code
for the station of interest.}

\item{start_date}{A \code{character} string or \code{Date} object representing the
beginning of the range to query in the format \dQuote{yyyy-mm-dd}
(ISO8601).  Data returned is inclusive of this range.}

\item{end_date}{A \code{character} string or \code{Date} object representing the end of
the range query in the format  \dQuote{yyyy-mm-dd} (ISO8601).  Data
returned is inclusive of this range.  Defaults to the current system date.}

\item{interval}{A \code{character} string that indicates the time interval to
\code{monthly} or \code{yearly}.  For intervals shorter than 1 day, the time period
covered will be midnight to midnight, with the end_date time interval being
before midnight - hour/minute values are for the end of the time period.
Data for shorter intervals (\verb{15min}, \verb{30min}) are available from January of
the previous year.}

\item{values}{A \code{character} string with the type of summarised weather
to return.  See \strong{Available Values} for a full list of valid values.
Defaults to \code{all} with all available values being returned.}

\item{include_closed}{A \code{Boolean} value that defaults to \code{FALSE}.  If set to
\code{TRUE} the query returns closed and open stations.  Closed stations are
those that have been turned off and no longer report data.  They may be
useful for historical purposes.}

\item{api_key}{A \code{character} string containing your \acronym{API} key from
\acronym{DPIRD}, \url{https://www.agric.wa.gov.au/web-apis}, for the
\acronym{DPIRD} Weather 2.0 \acronym{API}.}
}
\value{
a \link[data.table:data.table]{data.table::data.table} with \code{station_code} and the date interval
queried together with the requested weather variables in alphabetical
order.  The first ten columns will always be:
\itemize{
\item \code{station_code},
\item \code{station_name},
\item \code{latitude},
\item \code{longitude},
\item \code{year},
\item \code{month},
\item \code{day},
\item \code{hour},
\item \code{minute}, and if \code{month} or finer is present,
\item \code{date} (a combination of year, month, day, hour, minute as appropriate).
}
}
\description{
Fetch nicely formatted individual station weather summaries from the
\acronym{DPIRD} Weather 2.0 \acronym{API}.
}
\note{
Please note this function converts date-time columns from Coordinated
Universal Time \sQuote{UTC} to Australian Western Standard Time
\sQuote{AWST}.
}
\section{Available Values}{

\itemize{
\item all (which will return all of the following values),
\item airTemperature,
\item airTemperatureAvg,
\item airTemperatureMax,
\item airTemperatureMaxTime,
\item airTemperatureMin,
\item airTemperatureMinTime,
\item apparentAirTemperature,
\item apparentAirTemperatureAvg,
\item apparentAirTemperatureMax,
\item apparentAirTemperatureMaxTime,
\item apparentAirTemperatureMin,
\item apparentAirTemperatureMinTime,
\item barometricPressure,
\item barometricPressureAvg,
\item barometricPressureMax,
\item barometricPressureMaxTime,
\item barometricPressureMin,
\item barometricPressureMinTime,
\item battery,
\item batteryMinVoltage,
\item batteryMinVoltageDateTime,
\item chillHours,
\item deltaT,
\item deltaTAvg,
\item deltaTMax,
\item deltaTMaxTime,
\item deltaTMin,
\item deltaTMinTime,
\item dewPoint,
\item dewPointAvg,
\item dewPointMax,
\item dewPointMaxTime,
\item dewPointMin,
\item dewPointMinTime,
\item erosionCondition,
\item erosionConditionMinutes,
\item erosionConditionStartTime,
\item errors,
\item etoShortCrop,
\item etoTallCrop,
\item evapotranspiration,
\item frostCondition,
\item frostConditionMinutes,
\item frostConditionStartTime,
\item heatCondition,
\item heatConditionMinutes,
\item heatConditionStartTime,
\item observations,
\item observationsCount,
\item observationsPercentage,
\item panEvaporation,
\item rainfall,
\item relativeHumidity,
\item relativeHumidityAvg,
\item relativeHumidityMax,
\item relativeHumidityMaxTime,
\item relativeHumidityMin,
\item relativeHumidityMinTime,
\item richardsonUnits,
\item soilTemperature,
\item soilTemperatureAvg,
\item soilTemperatureMax,
\item soilTemperatureMaxTime,
\item soilTemperatureMin,
\item soilTemperatureMinTime,
\item solarExposure,
\item wetBulb,
\item wetBulbAvg,
\item wetBulbMax,
\item wetBulbMaxTime,
\item wetBulbMin,
\item wetBulbMinTime,
\item wind,
\item windAvgSpeed, and
\item windMaxSpeed
}
}

\examples{
\dontrun{
# You must have a DPIRD API key to proceed

# Use default for end data (current system date) to get rainfall
wd <- get_dpird_summaries(
   station_code = "CL001",
   start_date = "20171028",
   api_key = "your_api_key",
   interval = "yearly",
   values = "rainfall"
)

# Only for wind and erosion conditions for daily time interval

wd <- get_dpird_summaries(
  station_code = "BI",
  start_date = "20220501",
  end_date = "20220502",
  api_key = "your_api_key",
  interval = "daily",
  values = c(
    "wind",
    "erosionCondition",
    "erosionConditionMinutes",
    "erosionConditionStartTime"
    )
)
}
}
\seealso{
Other DPIRD: 
\code{\link{dpird_extreme_weather_values}},
\code{\link{dpird_minute_values}},
\code{\link{dpird_summary_values}},
\code{\link{find_nearby_stations}()},
\code{\link{get_dpird_availability}()},
\code{\link{get_dpird_extremes}()},
\code{\link{get_dpird_minute}()},
\code{\link{get_station_metadata}()}

Other data fetching: 
\code{\link{get_ag_bulletin}()},
\code{\link{get_coastal_forecast}()},
\code{\link{get_data_drill_apsim}()},
\code{\link{get_data_drill}()},
\code{\link{get_dpird_extremes}()},
\code{\link{get_dpird_minute}()},
\code{\link{get_patched_point_apsim}()},
\code{\link{get_patched_point}()},
\code{\link{get_precis_forecast}()},
\code{\link{get_radar_imagery}()},
\code{\link{get_satellite_imagery}()}
}
\author{
Adam H. Sparks \email{adam.sparks@dpird.wa.gov.au} and Rodrigo Pires,
\email{rodrigo.pires@dpird.wa.gov.au}
}
\concept{DPIRD}
\concept{data fetching}
