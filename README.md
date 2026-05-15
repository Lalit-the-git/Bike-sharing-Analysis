# Bike Sharing Services — Data Analysis Project

## Overview
This project is a complete data analysis of a bike-sharing platform operating across 5 US cities — Boston, Chicago, New York, San Francisco, and Seattle.

The goal was to analyze 50,000 bike trips to find useful patterns in demand, user behavior, station performance, and maintenance trends that can help the business make better decisions.

---

## Tools Used
- **MySQL** — Data cleaning and analysis (SQL queries)
- **Power BI** — Interactive dashboard and visualizations

---

## Dataset
The dataset contains 7 tables:

| Table | Records | Description |
|-------|---------|-------------|
| trips_data | 50,000 | Every bike ride taken |
| users_data | 5,000 | User profiles and subscription info |
| stations_data | 200 | Station details and locations |
| bikes_data | 1,000 | Fleet information |
| maintenance_data | 10,000 | Bike repair logs |
| revenue_data | 5,000 | Payment and fare records |
| weather_data | 8,760 | Hourly weather data |

---

## Project Structure
The analysis is divided into 5 stages:

- **Stage 1** — Data Quality Check (missing values, record counts)
- **Stage 2** — Data Cleaning (duplicates, anomalies, standardization)
- **Stage 3** — Demand Analysis (peak hours, weekday vs weekend, station flow)
- **Stage 4** — User Behavior (ride types, top riders, time preferences)
- **Stage 5** — Maintenance Analysis (common issues, downtime, at-risk bikes)

---

## Key Findings
- Casual riders make up **50% of all trips** and are the most active users
- **8 AM** is the busiest hour — morning commute peak
- **Station 171** has 70% of its fleet under maintenance — critical shortage
- **Flat Tire** is the most common issue, peaking in Spring
- Top 10 most active riders are all Casual users — big subscription conversion opportunity

---

## Dashboard
The Power BI dashboard has 3 pages:
1. **Overview** — KPIs, hourly demand, ride type breakdown
2. **Station & Demand** — Top stations, maintenance issues, city map
3. **Maintenance & Revenue** — Downtime analysis, revenue breakdown

---

## How to Run
1. Import all 7 CSV files into MySQL
2. Run SQL queries from each stage
3. Connect Power BI to MySQL database
4. Open the Power BI dashboard file
