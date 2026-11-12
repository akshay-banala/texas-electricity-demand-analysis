# Texas Electricity Demand & Weather Analysis | ERCOT 2025

### End-to-End Data Analytics Portfolio Project

**Python | Pandas | SQL | SQLite | Tableau | Data Visualization**

## Project Overview

This project analyzes hourly electricity demand across Texas during 2025 using publicly available ERCOT electricity load data and historical weather data.

The objective is to understand how electricity consumption changes across seasons, hours, geographical regions, and temperature conditions.

The project demonstrates an end-to-end data analytics workflow, including data collection, cleaning, transformation, SQL analysis, and interactive dashboard development.

## Business Questions

1. How does electricity demand change throughout the year?
2. Which Texas regions contribute the most to electricity consumption?
3. How does temperature relate to electricity demand?
4. At what hours does electricity demand typically peak?
5. How do hourly consumption patterns vary by month?

## Tools & Technologies

| Tool | Purpose |
|---|---|
| Python | Data processing and exploratory analysis |
| Pandas | Data cleaning, transformation, and validation |
| SQL | Data analysis and aggregation |
| SQLite | Storing and querying structured datasets |
| DBeaver | SQL query development |
| Tableau Public | Interactive dashboard and visualization |
| VS Code / Jupyter | Python development and documentation |

## Data Sources

**Electricity Demand:** Electric Reliability Council of Texas (ERCOT), 2025 hourly native load data.

Source: https://www.ercot.com/gridinfo/load

**Weather Data:** Open-Meteo Historical Weather API, using ERA5 reanalysis data for eight Texas locations.

Source: https://open-meteo.com/en/docs/historical-weather-api

The electricity dataset contains 8,760 hourly observations, covering the 2025 calendar year.

Weather observations include temperature, relative humidity, and apparent temperature.

## Data Preparation

The data preparation process included:

- Inspecting data types, missing values, and duplicates.
- Standardizing electricity timestamps, including hour-ending conventions.
- Handling daylight saving time transitions.
- Converting timestamps to UTC for consistent time alignment.
- Validating statewide electricity demand against the sum of regional demand.
- Integrating hourly electricity demand with historical weather observations.
- Creating calendar features such as month, day of week, and hour.
- Preparing structured datasets for SQL analysis and Tableau visualization.

The final integrated statewide dataset contains **8,760 hourly records**, with no unmatched weather records.

## Key Findings

### 1. Annual Electricity Demand

- Average hourly statewide demand: **55,734 MW**
- Maximum hourly demand: **83,679 MW**
- Minimum hourly demand: **38,363 MW**

### 2. Seasonal Demand

- **August** recorded the highest monthly average demand at approximately **66,421 MW**.
- **March** recorded the lowest monthly average demand at approximately **46,701 MW**.

This indicates substantially higher electricity consumption during the summer.

### 3. Regional Demand

The two regions with the highest average electricity demand were:

- **NCENT:** approximately 15,307 MW
- **COAST:** approximately 14,746 MW

These regions represented major contributors to statewide electricity consumption.

### 4. Temperature and Electricity Demand

The analysis revealed a U-shaped relationship between temperature and electricity demand.

| Temperature range | Average electricity demand |
|---|---:|
| Below 5°C | 60,363 MW |
| 15–20°C | 46,412 MW |
| 30°C and above | 73,910 MW |

Demand was higher during both cold and hot conditions, with particularly strong demand during high temperatures.

Temperature categories were calculated using an unweighted average across eight selected Texas weather locations. These results describe associations rather than establishing causation.

### 5. Hourly Consumption Patterns

- Electricity demand was generally lowest during the early morning, around 4–5 AM.
- Average demand typically peaked around 6 PM.
- Summer months showed particularly high electricity demand during afternoon and evening hours.

## Interactive Tableau Dashboard

**[View the Texas Electricity Demand Dashboard on Tableau Public](https://public.tableau.com/app/profile/akshay.banala/viz/TexasElectricityDemandWeatherAnalysisERCOT2025/TexasElectricityDemand2025)**

The dashboard includes:

- Annual average demand and peak-month KPI cards
- Monthly electricity demand trends
- Regional electricity demand comparison
- Temperature versus electricity demand analysis
- Hourly demand patterns
- Month-by-hour electricity demand heatmap

## Project Structure

```text
texas-electricity-demand-analysis/
├── data/
│   └── processed/
│       ├── electricity_weather_integrated_2025.csv
│       ├── ercot_statewide_2025.csv
│       ├── ercot_zones_2025.csv
│       └── texas_weather_8cities_2025.csv
├── notebooks/
│   ├── 01_data_exploration.ipynb
│   ├── 02_exploratory_analysis.ipynb
│   ├── 02_weather_exploration.ipynb
│   ├── 03_weather_collection.ipynb
│   └── 05_sql_database_setup.ipynb
├── sql/
│   └── ercot_analysis.sql
└── README.md
```

## Skills Demonstrated

- Data cleaning and quality validation
- Exploratory data analysis (EDA)
- Time-series data preparation
- Integration of multiple data sources
- SQL joins, aggregations, and common table expressions (CTEs)
- Data visualization and dashboard design
- Communicating analytical insights

## Conclusion

Texas electricity demand exhibits clear seasonal, regional, hourly, and temperature-related patterns.

This project demonstrates how Python, SQL, and Tableau can be combined to transform raw operational and weather data into insights that support electricity demand monitoring, capacity planning, and further analytical investigation.

---

**Project Type:** End-to-End Data Analytics Portfolio Project  
**Industry:** Energy & Utilities  
**Analysis Period:** 2025  
**Tools:** Python, SQL, SQLite, Tableau
