SELECT AVG(predicted_duration_minutes) AS average_predicted_trip_length
FROM ML.predict(MODEL austin.subscriber_model, (
SELECT
    start_station_name,
    EXTRACT(HOUR FROM start_time) AS start_hour,
    subscriber_type,
    duration_minutes
FROM
  `bigquery-public-data.austin_bikeshare.bikeshare_trips`
WHERE 
  EXTRACT(YEAR FROM start_time) = 2019
  AND subscriber_type = 'Single Trip'
  AND start_station_name = (SELECT start_station_name
                            FROM `bigquery-public-data.austin_bikeshare.bikeshare_trips`
                            WHERE EXTRACT(YEAR FROM start_time) = 2019  
                            GROUP BY start_station_name 
                            ORDER BY COUNT(*) DESC LIMIT 1)))