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

# Example usage
date_time <- ymd_hms("2024-08-20 15:30:00", tz = "Asia/Kolkata")
latitude <- 28.6139  # Delhi latitude
longitude <- 77.2090 # Delhi longitude

vedic_info <- vedic_date_time(date_time, latitude, longitude)
print(vedic_info)
