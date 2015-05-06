-- USEFUL SNIPPETS
-- TO GREEN: where dropoff_zone = "green"
-- FROM GREEN: where pickup_zone = "green"
-- WITHIN GREEN: where dropoff_zone = "green" and pickup_zone = "green"
-- variables to compare: passenger_count trip_distance tolls_amount tip_amount/total_amount

-- TODO change default data directory!!!!!

-- Delete UNKNOWN pickup or dropoff neighborhoods

DELETE from trips 
WHERE dropoff_neighborhood = "UNKNOWN" 
OR dropoff_neighborhood = "UNKNOWN";

---------------------------------------------------------------------------------------

-- Q0A: Total money made per week

select week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount
  from trips
) as green_zone
group by week_val
order by week_val
INTO OUTFILE 'Q0A_total_money_per_week.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


-- Q0C: Total trips made per week

select week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips
  from trips
) as green_zone
group by week_val
order by week_val
select week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount
  from trips
) as green_zone
group by week_val
order by week_val
INTO OUTFILE 'Q0C_total_trips_per_week.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

---------------------------------------------------------------------------------------

-- Q1A: Total money made TO green zones

select color,week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount, color
  from trips
  where dropoff_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE 'Q1A_total_money_made_to_green_zones.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q1C: Total trips made TO green zones

select color, week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips, color
  from trips
  where dropoff_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE 'Q1C_total_trips_made_to_green_zones.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q2A: Total money made FROM green zones

select color, week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount, color
  from trips
  where pickup_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE 'Q2A_total_money_made_from_green_zones.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q2C: Total trips made FROM green zones

select color, week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips, color
  from trips
  where pickup_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE 'Q2C_total_trips_made_from_green_zones.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q3A: Total money made WITHIN green zones

select color, week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount, color
  from trips
  where pickup_zone = "green" and dropoff_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE 'Q3A_total_money_made_within_green_zones.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q3C: Total trips made WITHIN green zones

select color, week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips, color
  from trips
  where pickup_zone = "green" and dropoff_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE 'Q3C_total_trips_made_within_green_zones.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

---------------------------------------------------------------------------------

-- Q4A: Total money made TO green zones (by neighborhood)

select pickup_neighborhood, color, sum(total_amount)
from (
  select total_amount, color, pickup_neighborhood
  from trips
  where dropoff_zone = "green"
  and pickup_date >= DATE('2013-08-01')
) as green_zone
group by pickup_neighborhood, color
order by pickup_neighborhood, color
INTO OUTFILE 'Q4A_total_money_made_to_green_zones_by_neigh.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q4C: Total trips made TO green zones (by neighborhood)

select pickup_neighborhood, color, sum(num_trips)
from (
  select num_trips, color, pickup_neighborhood
  from trips
  where dropoff_zone = "green"
  and pickup_date >= DATE('2013-08-01')
) as green_zone
group by pickup_neighborhood, color
order by pickup_neighborhood, color;
INTO OUTFILE 'Q4C_total_trips_made_to_green_zones_by_neigh.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


-- Q5A: Total money made FROM green zones (by neighborhood)

select dropoff_neighborhood, color, sum(total_amount)
from (
  select total_amount, color, dropoff_neighborhood
  from trips
  where pickup_zone = "green"
  and pickup_date >= DATE('2013-08-01')
) as green_zone
group by dropoff_neighborhood, color 
order by dropoff_neighborhood, color
INTO OUTFILE 'Q5A_total_money_made_from_green_zones_by_neigh.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q5C: Total trips made FROM green zones (by neighborhood)

select dropoff_neighborhood, color, sum(num_trips)
from (
  select num_trips, color, dropoff_neighborhood
  from trips
  where pickup_zone = "green"
  and pickup_date >= DATE('2013-08-01')
) as green_zone
group by dropoff_neighborhood,color
order by dropoff_neighborhood,color
INTO OUTFILE 'Q5C_total_trips_made_from_green_zones_by_neigh.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

---------------------------------------------------------------------------------------

-- Q6: characteristics to green
--TODO passenger_count, trip_distance tolls_amount, tip_amount/total_amount

select color, 
  sum(passenger_count)/sum(num_trips) as avg_passenger_count,
  sum(trip_distance)/sum(num_trips) as avg_trip_distance,
  sum(tolls_amount)/sum(num_trips) as avg_tolls_amount,
  tip/count(*) as avg_tip
from (
  select color, passenger_count, trip_distance, tolls_amount, tip_amount/total_amount as tip, num_trips
  from trips
  where dropoff_zone = "green"
  and pickup_date >= DATE('2013-08-01')
  group by color
) subtable;


-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------

-- Q1AB: Total money made TO green zones [border]

select color,week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount, color
  from trips
  where dropoff_zone = "green" 
  and pickup_border = "TRUE"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE 'Q1A_total_money_made_to_green_zones_B.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q1C: Total trips made TO green zones [border]

select color, week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips, color
  from trips
  where dropoff_zone = "green"
  and pickup_border = "TRUE"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE 'Q1C_total_trips_made_to_green_zones_B.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q2A: Total money made FROM green zones [border]

select color, week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount, color
  from trips
  where pickup_zone = "green"
  and dropoff_border = "TRUE"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE 'Q2A_total_money_made_from_green_zones_B.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q2C: Total trips made FROM green zones [border]

select color, week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips, color
  from trips
  where pickup_zone = "green"
  and dropoff_border = "TRUE"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE 'Q2C_total_trips_made_from_green_zones_B.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

---------------OLD QUERIES

-- Total money made in green zones

-- select year_val, month_val, sum(total_amount)
-- from (
--   select YEARWEEK(pickup_date) as week_val, MONTH(pickup_date) as month_val, total_amount
--   from trips
--   where zone = 'green'
-- ) as green_zone
-- group by year_val, month_val
-- order by year_val, month_val;

-- Total money made in green zones, split into taxi color

-- select year_val, month_val, color, sum(total_amount)
-- from (
--   select YEARWEEK(pickup_date) as week_val, MONTH(pickup_date) as month_val, color, total_amount
--   from trips
--   where zone = 'green'
-- ) as green_zone
-- group by year_val, month_val, color
-- order by year_val, month_val, color;

