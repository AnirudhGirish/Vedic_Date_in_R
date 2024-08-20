# Load required libraries
library(swephR)
library(lubridate)

# Function to calculate Vedic date and time
vedic_date_time <- function(date_time, latitude, longitude) {
  # Convert date_time to UTC
  utc_time <- with_tz(date_time, "UTC")
  
  # Set up Swiss Ephemeris (swephR) for calculations
  swe_set_ephe_path()  # Defaults to internal path of the Swiss Ephemeris

  # Get Julian day number
  julian_day <- swe_julday(year(utc_time), month(utc_time), day(utc_time), 
                           hour(utc_time) + minute(utc_time)/60 + second(utc_time)/3600, 
                           calendar = 1)
  
  # Calculate sidereal time
  sidereal_time <- swe_sidtime(julian_day)
  
  # Calculate planetary positions (Sun and Moon)
  sun_pos <- swe_calc_ut(julian_day, 0)$xx[1] # 0 = Sun
  moon_pos <- swe_calc_ut(julian_day, 1)$xx[1] # 1 = Moon
  
  # Calculate Tithi
  tithi <- floor(((moon_pos - sun_pos) %% 360) / 12) + 1
  
  # Calculate Masa (Lunar Month)
  masa <- floor(sun_pos / 30) + 1
  
  # Output Vedic time information
  list(
    Tithi = tithi,
    Masa = masa,
    SiderealTime = sidereal_time,
    JulianDay = julian_day
  )
}

# Function to set up Swiss Ephemeris
initialize_ephemeris <- function() {
  swe_set_ephe_path()  # Defaults to internal path of the Swiss Ephemeris
}

# Function to calculate Julian day
get_julian_day <- function(date_time) {
  swe_julday(year(date_time), month(date_time), day(date_time),
             hour(date_time) + minute(date_time)/60 + second(date_time)/3600,
             calendar = 1)
}

# Function to calculate sidereal time
get_sidereal_time <- function(julian_day, longitude) {
  sidereal_time <- swe_sidtime(julian_day) + (longitude / 15)
  sidereal_time <- sidereal_time %% 24  # Ensure it's within 0-24 hours
  return(sidereal_time)
}

# Function to calculate planetary positions (Sun, Moon)
get_planetary_positions <- function(julian_day) {
  sun_pos <- swe_calc_ut(julian_day, 0)$xx[1]  # 0 = Sun
  moon_pos <- swe_calc_ut(julian_day, 1)$xx[1] # 1 = Moon
  return(list(Sun = sun_pos, Moon = moon_pos))
}

# Function to calculate Tithi
calculate_tithi <- function(moon_pos, sun_pos) {
  tithi <- floor(((moon_pos - sun_pos) %% 360) / 12) + 1
  return(tithi)
}

# Function to calculate Masa (Lunar Month)
calculate_masa <- function(sun_pos) {
  masa <- floor(sun_pos / 30) + 1
  return(masa)
}

# Function to calculate Nakshatra (constellation)
calculate_nakshatra <- function(moon_pos) {
  nakshatra <- floor((moon_pos %% 360) / 13.3333) + 1
  return(nakshatra)
}

# Function to calculate Yoga
calculate_yoga <- function(sun_pos, moon_pos) {
  yoga <- floor(((sun_pos + moon_pos) %% 360) / 13.3333) + 1
  return(yoga)
}

# Function to calculate Karana
calculate_karana <- function(tithi) {
  karana <- ((tithi - 1) * 2) %% 11 + 1
  return(karana)
}

# Function to calculate sunrise and sunset times
calculate_sunrise_sunset <- function(julian_day, latitude, longitude) {
  sunrise <- swe_rise_trans(julian_day, 0, flag = 2, geolon = c(longitude, latitude))$tret[1] # 0 = Sun
  sunset <- swe_rise_trans(julian_day, 0, flag = 4, geolon = c(longitude, latitude))$tret[1]  # 0 = Sun
  return(list(Sunrise = sunrise, Sunset = sunset))
}

# Function to calculate all Vedic time elements
vedic_date_time <- function(date_time, latitude, longitude) {
  # Convert date_time to UTC
  utc_time <- with_tz(date_time, "UTC")
  
  # Initialize Swiss Ephemeris
  initialize_ephemeris()
  
  # Get Julian day number
  julian_day <- get_julian_day(utc_time)
  
  # Calculate sidereal time
  sidereal_time <- get_sidereal_time(julian_day, longitude)
  
  # Calculate planetary positions
  positions <- get_planetary_positions(julian_day)
  sun_pos <- positions$Sun
  moon_pos <- positions$Moon
  
  # Calculate Vedic elements
  tithi <- calculate_tithi(moon_pos, sun_pos)
  masa <- calculate_masa(sun_pos)
  nakshatra <- calculate_nakshatra(moon_pos)
  yoga <- calculate_yoga(sun_pos, moon_pos)
  karana <- calculate_karana(tithi)
  
  # Calculate sunrise and sunset times
  sun_times <- calculate_sunrise_sunset(julian_day, latitude, longitude)
  
  # Output Vedic time information
  list(
    Tithi = tithi,
    Masa = masa,
    Nakshatra = nakshatra,
    Yoga = yoga,
    Karana = karana,
    SiderealTime = sidereal_time,
    Sunrise = sun_times$Sunrise,
    Sunset = sun_times$Sunset,
    JulianDay = julian_day
  )
}

# Function to convert Julian day to standard date-time
julian_to_datetime <- function(julian_day) {
  jd_conv <- swe_revjul(julian_day)
  dt <- make_datetime(jd_conv$year, jd_conv$month, jd_conv$day, jd_conv$hour)
  return(dt)
}

# Example usage
date_time <- ymd_hms("2024-08-20 15:30:00", tz = "Asia/Kolkata")
latitude <- 28.6139  # Delhi latitude
longitude <- 77.2090 # Delhi longitude

vedic_info <- vedic_date_time(date_time, latitude, longitude)

# Print Vedic information
cat("Vedic Date and Time Information:\n")
cat("Tithi:", vedic_info$Tithi, "\n")
cat("Masa:", vedic_info$Masa, "\n")
cat("Nakshatra:", vedic_info$Nakshatra, "\n")
cat("Yoga:", vedic_info$Yoga, "\n")
cat("Karana:", vedic_info$Karana, "\n")
cat("Sidereal Time:", vedic_info$SiderealTime, "hours\n")
cat("Sunrise:", julian_to_datetime(vedic_info$Sunrise), "\n")
cat("Sunset:", julian_to_datetime(vedic_info$Sunset), "\n")
cat("Julian Day:", vedic_info$JulianDay, "\n")
