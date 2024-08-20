# Vedic Calendar in R

This repository contains an R script that calculates various Vedic date and time elements based on user input. The script determines the `tithi`, `masa`, `nakshatra`, `yoga`, `karana`, and sunrise/sunset times using the Swiss Ephemeris and user-provided date, time, and location.

## Features

- Calculate Vedic tithi (lunar day)
- Determine Masa (lunar month)
- Identify Nakshatra (constellation)
- Calculate Yoga and Karana
- Provide sidereal time based on location
- Calculate sunrise and sunset times

## Prerequisites

- R (version 4.0 or higher)
- `swephR` package for astronomical calculations
- `lubridate` package for date and time manipulation

## Installation

1. Install R from [CRAN](https://cran.r-project.org/).
2. Install the required R packages:

    ```r
    install.packages("swephR")
    install.packages("lubridate")
    ```

## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/vedic-calendar.git
    cd vedic-calendar
    ```

2. Open the `vedic_calendar.R` script in RStudio or any R IDE.

3. Modify the `date_time`, `latitude`, and `longitude` variables as per your location and desired date-time.

4. Run the script to get the Vedic date and time information.

    ```r
    source("vedic_calendar.R")
    ```

## Example

```r
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
