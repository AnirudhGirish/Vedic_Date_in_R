# Vedic Calendar in R

This repository contains an R script that calculates the Vedic date and time based on user input. The script determines the `tithi`, `masa`, and other Vedic time-related information based on the given date, time, and geographical location.

## Features

- Calculate Vedic tithi (lunar day)
- Determine Masa (lunar month)
- Provide sidereal time based on location

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
print(vedic_info)
