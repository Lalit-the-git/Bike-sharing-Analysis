create schema bike_sharing;
use bike_sharing;

select * from bikes_data;
select * from maintenance_data;
select * from revenue_data;
select * from stations_data;
select * from trips_data;
select * from users_data;
select * from weather_data;

SELECT 'Users', COUNT(*) AS Total_Records FROM Users_data
UNION ALL
SELECT 'Stations', COUNT(*) FROM Stations_data
UNION ALL
SELECT 'Bikes', COUNT(*) FROM Bikes_data
UNION ALL
SELECT 'Trips', COUNT(*) FROM Trips_data
UNION ALL
SELECT 'Weather', COUNT(*) FROM Weather_data
UNION ALL
SELECT 'Maintenance', COUNT(*) FROM Maintenance_data
UNION ALL
SELECT 'Revenue', COUNT(*) FROM Revenue_data;



-- Checking missing values in trips_data table

-- Checking missing values in trips_data table

SELECT
    'User_ID'            AS Column_Name,
    SUM(User_ID IS NULL) AS Missing_Values,
    ROUND(SUM(User_ID IS NULL) * 100.0 / COUNT(*), 2) AS Percentage_Missing,
    CASE
        WHEN SUM(User_ID IS NULL) * 100.0 / COUNT(*) > 10 THEN 'High'
        WHEN SUM(User_ID IS NULL) * 100.0 / COUNT(*) > 5  THEN 'Medium'
        ELSE 'Low'
    END AS Impact_Level
FROM trips_data

UNION ALL

SELECT
    'Bike_ID',
    SUM(Bike_ID IS NULL),
    ROUND(SUM(Bike_ID IS NULL) * 100.0 / COUNT(*), 2),
    CASE
        WHEN SUM(Bike_ID IS NULL) * 100.0 / COUNT(*) > 10 THEN 'High'
        WHEN SUM(Bike_ID IS NULL) * 100.0 / COUNT(*) > 5  THEN 'Medium'
        ELSE 'Low'
    END
FROM trips_data

UNION ALL

SELECT
    'Start_Station_ID',
    SUM(Start_Station_ID IS NULL),
    ROUND(SUM(Start_Station_ID IS NULL) * 100.0 / COUNT(*), 2),
    CASE
        WHEN SUM(Start_Station_ID IS NULL) * 100.0 / COUNT(*) > 10 THEN 'High'
        WHEN SUM(Start_Station_ID IS NULL) * 100.0 / COUNT(*) > 5  THEN 'Medium'
        ELSE 'Low'
    END
FROM trips_data

UNION ALL

SELECT
    'End_Station_ID',
    SUM(End_Station_ID IS NULL),
    ROUND(SUM(End_Station_ID IS NULL) * 100.0 / COUNT(*), 2),
    CASE
        WHEN SUM(End_Station_ID IS NULL) * 100.0 / COUNT(*) > 10 THEN 'High'
        WHEN SUM(End_Station_ID IS NULL) * 100.0 / COUNT(*) > 5  THEN 'Medium'
        ELSE 'Low'
    END
FROM trips_data

UNION ALL

SELECT
    'Start_Time',
    SUM(Start_Time IS NULL),
    ROUND(SUM(Start_Time IS NULL) * 100.0 / COUNT(*), 2),
    CASE
        WHEN SUM(Start_Time IS NULL) * 100.0 / COUNT(*) > 10 THEN 'High'
        WHEN SUM(Start_Time IS NULL) * 100.0 / COUNT(*) > 5  THEN 'Medium'
        ELSE 'Low'
    END
FROM trips_data

UNION ALL

SELECT
    'End_Time',
    SUM(End_Time IS NULL),
    ROUND(SUM(End_Time IS NULL) * 100.0 / COUNT(*), 2),
    CASE
        WHEN SUM(End_Time IS NULL) * 100.0 / COUNT(*) > 10 THEN 'High'
        WHEN SUM(End_Time IS NULL) * 100.0 / COUNT(*) > 5  THEN 'Medium'
        ELSE 'Low'
    END
FROM trips_data

UNION ALL

SELECT
    'Trip_Duration_Min',
    SUM(Trip_Duration_Min IS NULL),
    ROUND(SUM(Trip_Duration_Min IS NULL) * 100.0 / COUNT(*), 2),
    CASE
        WHEN SUM(Trip_Duration_Min IS NULL) * 100.0 / COUNT(*) > 10 THEN 'High'
        WHEN SUM(Trip_Duration_Min IS NULL) * 100.0 / COUNT(*) > 5  THEN 'Medium'
        ELSE 'Low'
    END
FROM trips_data

UNION ALL

SELECT
    'Distance_KM',
    SUM(Distance_KM IS NULL),
    ROUND(SUM(Distance_KM IS NULL) * 100.0 / COUNT(*), 2),
    CASE
        WHEN SUM(Distance_KM IS NULL) * 100.0 / COUNT(*) > 10 THEN 'High'
        WHEN SUM(Distance_KM IS NULL) * 100.0 / COUNT(*) > 5  THEN 'Medium'
        ELSE 'Low'
    END
FROM trips_data;

-- Finding where User_IDs are missing by Ride Type
-- Casual missing = normal, Monthly/Yearly missing = bug

SELECT
    Ride_Type,
    SUM(User_ID IS NULL) AS Missing_User_ID_Count,
    COUNT(*)             AS Total_Trips,
    ROUND(SUM(User_ID IS NULL) * 100.0 / COUNT(*), 2) AS Percentage
FROM trips_data
GROUP BY Ride_Type
ORDER BY Missing_User_ID_Count DESC;

SELECT 
    Trip_ID,
    User_ID,
    Bike_ID,
    Start_Time,
    COUNT(*) AS Duplicate_Count
FROM trips_data
GROUP BY Trip_ID, User_ID, Bike_ID, Start_Time
HAVING COUNT(*) > 1;

SET SQL_SAFE_UPDATES = 0;


DELETE FROM trips_data
WHERE Trip_ID IN (
    SELECT Trip_ID FROM (
        SELECT 
            Trip_ID,
            ROW_NUMBER() OVER (
                PARTITION BY Trip_ID, User_ID, Bike_ID, Start_Time
                ORDER BY Trip_ID
            ) AS row_num
        FROM trips_data
    ) AS duplicates
    WHERE row_num > 1
);


-- Quick check for duplicates in trips_data

SELECT COUNT(*) AS Duplicate_Records
FROM trips_data
GROUP BY Trip_ID, User_ID, Bike_ID, Start_Time
HAVING COUNT(*) > 1;



-- Checking if missing User_IDs cluster 
-- around specific stations or time periods

SELECT 
    Start_Station_ID,
    HOUR(Start_Time)     AS Hour_Of_Day,
    COUNT(*)             AS Total_Trips,
    SUM(User_ID IS NULL) AS Missing_User_IDs
FROM trips_data
WHERE User_ID IS NULL
GROUP BY Start_Station_ID, HOUR(Start_Time)
ORDER BY Missing_User_IDs DESC;



-- Assigning CASUAL_UNKNOWN only to casual rides
-- where User_ID is missing

SET SQL_SAFE_UPDATES = 0;

UPDATE trips_data
SET User_ID = 0
WHERE User_ID IS NULL
AND Ride_Type = 'Casual';


-- Check negative trip durations
SELECT COUNT(*) AS Negative_Durations
FROM trips_data
WHERE Trip_Duration_Min < 0;


-- Check station name inconsistencies
SELECT DISTINCT Station_Name
FROM stations_data;



-------------------------------------------------------------------------------------------
select * from bikes_data;
select * from maintenance_data;
select * from revenue_data;
select * from stations_data;
select * from trips_data;
select * from users_data;
select * from weather_data;

-- q1 hourly demand
-- Finding total rides per hour and labeling peak vs off-peak
-- We use average ride count as the threshold

SELECT
    HOUR(Start_Time)  AS Hour_of_Day,
    COUNT(*)          AS Total_Trips,
    CASE
        WHEN COUNT(*) > (SELECT COUNT(*) / 24 FROM trips_data) 
        THEN 'Peak'
        ELSE 'Off-Peak'
    END  AS Peak_Off_Peak
FROM trips_data
GROUP BY HOUR(Start_Time)
ORDER BY Hour_of_Day;


select case
when
DAYOFWEEK(start_time) in(1,7) then "Weakend"
else "Weekday"
end as day_type,count(*) as Total_rides ,
avg(trip_duration_min) as totalmin_duration
FROM trips_data
GROUP BY day_type
;

-- Comparing weekday vs weekend ride patterns
-- DAYOFWEEK: 1=Sunday, 2=Monday ... 7=Saturday

SELECT
    CASE
        WHEN DAYOFWEEK(Start_Time) IN (1, 7) 
        THEN 'Weekend'
        ELSE 'Weekday'
    END                        AS Day_Type,
    COUNT(*)                   AS Total_Rides,
    ROUND(AVG(Trip_Duration_Min), 2) AS Avg_Trip_Duration,
    CASE
        WHEN DAYOFWEEK(Start_Time) IN (1, 7) 
        THEN 'Leisure Trips'
        ELSE 'Work Commute'
    END                        AS Main_Ride_Purpose
FROM trips_data
GROUP BY Day_Type, Main_Ride_Purpose;


-- Calculating net bike usage per station
-- Positive = bikes accumulating, Negative = bikes depleting

SELECT
    s.Station_Name,
    COUNT(DISTINCT t_start.Trip_ID)  AS Total_Departures,
    COUNT(DISTINCT t_end.Trip_ID)    AS Total_Arrivals,
    COUNT(DISTINCT t_end.Trip_ID) - 
    COUNT(DISTINCT t_start.Trip_ID)  AS Net_Usage
FROM stations_data s
LEFT JOIN trips_data t_start 
       ON s.Station_ID = t_start.Start_Station_ID
LEFT JOIN trips_data t_end   
       ON s.Station_ID = t_end.End_Station_ID
GROUP BY s.Station_Name
ORDER BY Net_Usage DESC;



-- Counting departures and arrivals per station
-- Using CASE WHEN to separate start and end stations

SELECT
    s.Station_Name,
    
    -- Count trips where this station was START = Departures
    SUM(CASE WHEN t.Start_Station_ID = s.Station_ID 
        THEN 1 ELSE 0 END)  AS Total_Departures,
    
    -- Count trips where this station was END = Arrivals
    SUM(CASE WHEN t.End_Station_ID = s.Station_ID 
        THEN 1 ELSE 0 END)  AS Total_Arrivals,
    
    -- Net = Arrivals minus Departures
    SUM(CASE WHEN t.End_Station_ID   = s.Station_ID 
        THEN 1 ELSE 0 END) -
    SUM(CASE WHEN t.Start_Station_ID = s.Station_ID 
        THEN 1 ELSE 0 END)  AS Net_Usage

FROM stations_data s
JOIN trips_data t 
  ON s.Station_ID = t.Start_Station_ID 
  OR s.Station_ID = t.End_Station_ID
GROUP BY s.Station_Name
ORDER BY Net_Usage DESC;

-- Comparing trip duration and distance 
-- between peak and off-peak hours

SELECT
    CASE
        WHEN HOUR(Start_Time) BETWEEN 7 AND 9   THEN 'Peak Hours'
        WHEN HOUR(Start_Time) BETWEEN 17 AND 19  THEN 'Peak Hours'
        ELSE 'Off-Peak Hours'
    END                            AS Time_Period,
    ROUND(AVG(Trip_Duration_Min), 2) AS Avg_Trip_Duration,
    ROUND(AVG(Distance_KM), 2)       AS Avg_Trip_Distance,
    CASE
        WHEN HOUR(Start_Time) BETWEEN 7 AND 9   THEN 'Commute'
        WHEN HOUR(Start_Time) BETWEEN 17 AND 19  THEN 'Commute'
        ELSE 'Leisure'
    END                            AS Primary_Ride_Type
FROM trips_data
GROUP BY Time_Period, Primary_Ride_Type;


-- Finding stations that peak outside normal commute hours
-- Normal commute = 7-9AM and 17-19PM

-- Finding stations with unusual peak hours
-- Using ROW_NUMBER instead of correlated subquery
-- Finding stations with unusual peak hours
-- Using ROW_NUMBER instead of correlated subquery

SELECT
    Station_Name,
    Peak_Usage_Hour,
    Total_Rides_During_Peak,
    CASE
        WHEN Peak_Usage_Hour NOT BETWEEN 7 AND 9
        AND  Peak_Usage_Hour NOT BETWEEN 17 AND 19
        THEN 'Yes'
        ELSE 'No'
    END AS Unusual_Peak_Pattern

FROM (
    -- Inner query: rank hours per station
    SELECT
        s.Station_Name,
        HOUR(t.Start_Time)   AS Peak_Usage_Hour,
        COUNT(*)             AS Total_Rides_During_Peak,
        ROW_NUMBER() OVER (
            PARTITION BY s.Station_Name
            ORDER BY COUNT(*) DESC
        )                    AS rn
    FROM trips_data t
    JOIN stations_data s
      ON t.Start_Station_ID = s.Station_ID
    GROUP BY s.Station_Name, HOUR(t.Start_Time)
) AS ranked

-- Only keep peak hour per station
WHERE rn = 1
AND Peak_Usage_Hour NOT BETWEEN 7 AND 9
AND Peak_Usage_Hour NOT BETWEEN 17 AND 19

ORDER BY Total_Rides_During_Peak DESC;


-- Comparing ride behavior across different user types
-- Casual vs Monthly vs Yearly riders

SELECT
    Ride_Type,
    ROUND(AVG(Trip_Duration_Min), 2)  AS Avg_Duration,
    ROUND(AVG(Distance_KM), 2)        AS Avg_Distance,
    COUNT(*)                          AS Total_Trips
FROM trips_data
GROUP BY Ride_Type
ORDER BY Total_Trips DESC;


select u.subscription_type,count(*) as trips from trips_data tr 
join users_data u on tr.user_ID=u.user_id
group by subscription_type
order by trips desc;

-- Finding top users by trip frequency
-- and their total distance traveled

SELECT
    t.User_ID,
    t.Ride_Type,
    COUNT(*)                    AS Total_Trips,
    ROUND(SUM(t.Distance_KM), 1) AS Total_KM
FROM trips_data t
GROUP BY t.User_ID, t.Ride_Type
ORDER BY Total_Trips DESC, Total_KM DESC
LIMIT 10;


-- Finding hourly ride patterns for each user type
-- This shows when each type of rider prefers to ride

SELECT
    HOUR(Start_Time)  AS Hour_Of_Day,
    Ride_Type,
    COUNT(*)          AS Trip_Count
FROM trips_data
GROUP BY HOUR(Start_Time), Ride_Type
ORDER BY Hour_Of_Day, Ride_Type;











