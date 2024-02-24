-- A median is defined as a number separating the higher half of a data set from the lower half. Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to  decimal places.

-- Input Format

-- The STATION table is described as follows:

-- Station.jpg

-- where LAT_N is the northern latitude and LONG_W is the western longitude.

SELECT CASE
         WHEN MOD(Count(lat_n), 2) = 0 THEN Round(SUM(lat_n) / 2, 4)
         ELSE Round(SUM(lat_n), 4)
       END AS median
FROM   (SELECT lat_n,
               Row_number()
                 over(
                   ORDER BY lat_n) AS seq
        FROM   station)
WHERE  seq IN (SELECT CASE
                        WHEN MOD(Count(lat_n), 2) = 1 THEN Round(
                        Count(lat_n) / 2)
                      END AS position
               FROM   station
               UNION
               SELECT CASE
                        WHEN MOD(Count(lat_n), 2) = 0 THEN Count(lat_n) / 2
                      END AS position
               FROM   station
               UNION
               SELECT CASE
                        WHEN MOD(Count(lat_n), 2) = 0 THEN
                        ( Count(lat_n) / 2 ) + 1
                      END AS position
               FROM   station); 
