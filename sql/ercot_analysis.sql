SELECT
    date,
    hour,
    ROUND(demand_mw, 2) AS demand_mw
FROM electricity_statewide
ORDER BY demand_mw DESC
LIMIT 10;





SELECT
    month,
    ROUND(AVG(demand_mw), 2) AS avg_demand_mw,
    ROUND(MAX(demand_mw), 2) AS peak_demand_mw,
    ROUND(MIN(demand_mw), 2) AS lowest_demand_mw
FROM electricity_statewide
GROUP BY month
ORDER BY month;



SELECT
    zone,
    ROUND(AVG(demand_mw), 2) AS avg_demand_mw,
    ROUND(MAX(demand_mw), 2) AS peak_demand_mw,
    ROUND(
        100.0 * SUM(demand_mw) /
        (SELECT SUM(demand_mw)
         FROM electricity_regional),
        2
    ) AS share_of_total_pct
FROM electricity_regional
GROUP BY zone
ORDER BY avg_demand_mw DESC;





WITH peak_hour AS (
    SELECT
        hour_ending_utc,
        demand_mw AS statewide_demand
    FROM electricity_statewide
    ORDER BY demand_mw DESC
    LIMIT 1
),
regional_peak AS (
    SELECT
        r.zone,
        r.demand_mw,
        p.statewide_demand
    FROM electricity_regional r
    JOIN peak_hour p
        ON r.hour_ending_utc = p.hour_ending_utc
)
SELECT
    zone,
    ROUND(demand_mw, 2) AS regional_demand_mw,
    ROUND(
        100.0 * demand_mw / statewide_demand,
        2
    ) AS contribution_pct,
    RANK() OVER (
        ORDER BY demand_mw DESC
    ) AS demand_rank
FROM regional_peak
ORDER BY demand_rank;





WITH ranked_demand AS (
    SELECT
        zone,
        hour_ending_utc,
        demand_mw,
        ROW_NUMBER() OVER (
            PARTITION BY zone
            ORDER BY demand_mw DESC
        ) AS rn
    FROM electricity_regional
)
SELECT
    zone,
    hour_ending_utc,
    ROUND(demand_mw, 2) AS peak_demand_mw
FROM ranked_demand
WHERE rn = 1
ORDER BY peak_demand_mw DESC;





WITH peak_hours AS (
    SELECT
        hour_ending_utc,
        demand_mw
    FROM electricity_statewide
    ORDER BY demand_mw DESC
    LIMIT 10
),
weather_average AS (
    SELECT
        hour_utc,
        AVG(temperature_2m) AS avg_temperature_c
    FROM weather_hourly
    GROUP BY hour_utc
)
SELECT
    p.hour_ending_utc,
    ROUND(p.demand_mw, 2) AS demand_mw,
    ROUND(w.avg_temperature_c, 2) AS avg_temperature_c
FROM peak_hours p
LEFT JOIN weather_average w
    ON datetime(p.hour_ending_utc, '-1 hour')
       = datetime(w.hour_utc)
ORDER BY p.demand_mw DESC;






SELECT
    CASE
        WHEN CAST(strftime('%m', hour_utc) AS INTEGER)
             IN (6, 7, 8) THEN 'Summer'
        WHEN CAST(strftime('%m', hour_utc) AS INTEGER)
             IN (12, 1, 2) THEN 'Winter'
        ELSE 'Other'
    END AS season,
    ROUND(AVG(temperature_2m), 2) AS avg_temperature_c,
    ROUND(MIN(temperature_2m), 2) AS min_temperature_c,
    ROUND(MAX(temperature_2m), 2) AS max_temperature_c
FROM weather_hourly
GROUP BY season
ORDER BY season;


WITH hourly_weather AS (
    SELECT
        hour_utc,
        AVG(temperature_2m) AS avg_temperature_c
    FROM weather_hourly
    GROUP BY hour_utc
)
SELECT
    'Hottest' AS condition,
    hour_utc,
    ROUND(avg_temperature_c, 2) AS temperature_c
FROM hourly_weather
ORDER BY avg_temperature_c DESC
LIMIT 1;









WITH hourly_weather AS (
    SELECT
        hour_utc,
        AVG(temperature_2m) AS avg_temp_c
    FROM weather_hourly
    GROUP BY hour_utc
),
combined AS (
    SELECT
        e.demand_mw,
        w.avg_temp_c
    FROM electricity_statewide e
    JOIN hourly_weather w
        ON datetime(e.hour_ending_utc, '-1 hour')
         = datetime(w.hour_utc)
)
SELECT
    CASE
        WHEN avg_temp_c < 5 THEN '1. Below 5°C'
        WHEN avg_temp_c < 10 THEN '2. 5–10°C'
        WHEN avg_temp_c < 15 THEN '3. 10–15°C'
        WHEN avg_temp_c < 20 THEN '4. 15–20°C'
        WHEN avg_temp_c < 25 THEN '5. 20–25°C'
        WHEN avg_temp_c < 30 THEN '6. 25–30°C'
        ELSE '7. 30°C and above'
    END AS temperature_range,
    COUNT(*) AS total_hours,
    ROUND(AVG(demand_mw), 2) AS avg_demand_mw,
    ROUND(MAX(demand_mw), 2) AS peak_demand_mw
FROM combined
GROUP BY temperature_range
ORDER BY temperature_range;




CREATE INDEX IF NOT EXISTS idx_electricity_time
ON electricity_statewide(hour_ending_utc);




CREATE INDEX IF NOT EXISTS idx_weather_time
ON weather_hourly(hour_utc);



WITH hourly_weather AS (
    SELECT
        hour_utc,
        AVG(temperature_2m) AS avg_temp_c
    FROM weather_hourly
    GROUP BY hour_utc
),
combined AS (
    SELECT
        e.demand_mw,
        w.avg_temp_c
    FROM hourly_weather w
    JOIN electricity_statewide e
        ON w.hour_utc =
           strftime('%Y-%m-%d %H:%M:%S',
                    datetime(e.hour_ending_utc, '-1 hour'))
)
SELECT
    CASE
        WHEN avg_temp_c < 5 THEN '1. Below 5°C'
        WHEN avg_temp_c < 10 THEN '2. 5–10°C'
        WHEN avg_temp_c < 15 THEN '3. 10–15°C'
        WHEN avg_temp_c < 20 THEN '4. 15–20°C'
        WHEN avg_temp_c < 25 THEN '5. 20–25°C'
        WHEN avg_temp_c < 30 THEN '6. 25–30°C'
        ELSE '7. 30°C and above'
    END AS temperature_range,
    COUNT(*) AS total_hours,
    ROUND(AVG(demand_mw), 2) AS avg_demand_mw,
    ROUND(MAX(demand_mw), 2) AS peak_demand_mw
FROM combined
GROUP BY temperature_range
ORDER BY temperature_range;





SELECT hour_ending_utc
FROM electricity_statewide
LIMIT 5;




SELECT hour_utc
FROM weather_hourly
LIMIT 5;




WITH hourly_weather AS (
    SELECT
        hour_utc,
        AVG(temperature_2m) AS avg_temp_c
    FROM weather_hourly
    GROUP BY hour_utc
)
SELECT
    COUNT(*) AS matched_hours
FROM electricity_statewide e
JOIN hourly_weather w
    ON w.hour_utc = strftime(
        '%Y-%m-%d %H:%M:%S',
        e.hour_ending_utc,
        '-1 hour'
    ) || '+00:00';


SELECT
    e.hour_ending_utc,
    strftime(
        '%Y-%m-%d %H:%M:%S',
        e.hour_ending_utc,
        '-1 hour'
    ) || '+00:00' AS expected_weather_hour
FROM electricity_statewide e
WHERE NOT EXISTS (
    SELECT 1
    FROM weather_hourly w
    WHERE w.hour_utc = strftime(
        '%Y-%m-%d %H:%M:%S',
        e.hour_ending_utc,
        '-1 hour'
    ) || '+00:00'
)
ORDER BY e.hour_ending_utc;





SELECT
    hour_ending_utc
FROM electricity_statewide
WHERE datetime(hour_ending_utc, '-1 hour')
    NOT IN (
        SELECT datetime(hour_utc)
        FROM weather_hourly
    )
ORDER BY hour_ending_utc;





SELECT
    COUNT(*) AS total_records,
    MAX(hour_utc) AS latest_timestamp
FROM weather_hourly;

WITH hourly_weather AS (
    SELECT
        hour_utc,
        AVG(temperature_2m) AS avg_temp_c
    FROM weather_hourly
    GROUP BY hour_utc
)
SELECT
    COUNT(*) AS matched_hours
FROM electricity_statewide e
JOIN hourly_weather w
    ON w.hour_utc =
       strftime(
           '%Y-%m-%d %H:%M:%S',
           e.hour_ending_utc,
           '-1 hour'
       ) || '+00:00';



WITH hourly_weather AS (
    SELECT
        hour_utc,
        AVG(temperature_2m) AS avg_temp_c
    FROM weather_hourly
    GROUP BY hour_utc
),
combined AS (
    SELECT
        e.demand_mw,
        w.avg_temp_c
    FROM electricity_statewide e
    JOIN hourly_weather w
        ON w.hour_utc =
           strftime(
               '%Y-%m-%d %H:%M:%S',
               e.hour_ending_utc,
               '-1 hour'
           ) || '+00:00'
)
SELECT
    CASE
        WHEN avg_temp_c < 5 THEN '1. Below 5°C'
        WHEN avg_temp_c < 10 THEN '2. 5-10°C'
        WHEN avg_temp_c < 15 THEN '3. 10-15°C'
        WHEN avg_temp_c < 20 THEN '4. 15-20°C'
        WHEN avg_temp_c < 25 THEN '5. 20-25°C'
        WHEN avg_temp_c < 30 THEN '6. 25-30°C'
        ELSE '7. 30°C and above'
    END AS temperature_range,
    COUNT(*) AS total_hours,
    ROUND(AVG(demand_mw), 2) AS avg_demand_mw,
    ROUND(MAX(demand_mw), 2) AS peak_demand_mw
FROM combined
GROUP BY temperature_range
ORDER BY temperature_range;

