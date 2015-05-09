-- USEFUL SNIPPETS
-- TO GREEN: where dropoff_zone = "green"
-- FROM GREEN: where pickup_zone = "green"
-- WITHIN GREEN: where dropoff_zone = "green" and pickup_zone = "green"
-- variables to compare: passenger_count trip_distance tolls_amount tip_amount/fare_amount

-- TODO create /tmp/big_data_output/. Make sure it's 777!

-- Delete UNKNOWN pickup or dropoff neighborhoods

DELETE from trips 
WHERE dropoff_neighborhood = "UNKNOWN" 
OR dropoff_neighborhood = "UNKNOWN";

-- Q0A: Total money made per week

select 'week_val', 'sum(total_amount)'
UNION ALL
select week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount
  from trips
) as green_zone
group by week_val
order by week_val
INTO OUTFILE '/tmp/big_data_output/Q0A_total_money_per_week.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


-- Q0C: Total trips made per week

select 'week_val', 'sum(num_trips)'
UNION ALL
select week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips
  from trips
) as green_zone
group by week_val
order by week_val
INTO OUTFILE '/tmp/big_data_output/Q0C_total_trips_per_week.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q1A: Total money made TO green zones

select 'color', 'week_val', 'sum(total_amount)'
UNION ALL
select color,week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount, color
  from trips
  where dropoff_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE '/tmp/big_data_output/Q1A_total_money_made_to_green_zones.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q1C: Total trips made TO green zones

select 'color', 'week_val', 'sum(num_trips)'
UNION ALL
select color, week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips, color
  from trips
  where dropoff_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE '/tmp/big_data_output/Q1C_total_trips_made_to_green_zones.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q2A: Total money made FROM green zones

select 'color', 'week_val', 'sum(total_amount)'
UNION ALL
select color, week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount, color
  from trips
  where pickup_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE '/tmp/big_data_output/Q2A_total_money_made_from_green_zones.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q2C: Total trips made FROM green zones

select 'color', 'week_val', 'sum(num_trips)'
UNION ALL
select color, week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips, color
  from trips
  where pickup_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE '/tmp/big_data_output/Q2C_total_trips_made_from_green_zones.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q3A: Total money made WITHIN green zones

select 'color', 'week_val', 'sum(total_amount)'
UNION ALL
select color, week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount, color
  from trips
  where pickup_zone = "green" and dropoff_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE '/tmp/big_data_output/Q3A_total_money_made_within_green_zones.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q3C: Total trips made WITHIN green zones

select 'color', 'week_val', 'sum(num_trips)'
UNION ALL
select color, week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips, color
  from trips
  where pickup_zone = "green" and dropoff_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val
INTO OUTFILE '/tmp/big_data_output/Q3C_total_trips_made_within_green_zones.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q4A: Total money made TO green zones (by neighborhood)

select 'pickup_neighborhood', 'color', 'sum(total_amount)'
UNION ALL
select pickup_neighborhood, color, sum(total_amount)
from (
  select total_amount, color, pickup_neighborhood
  from trips
  where dropoff_zone = "green"
  and pickup_date >= DATE('2013-08-01')
) as green_zone
group by pickup_neighborhood, color
order by pickup_neighborhood, color
INTO OUTFILE '/tmp/big_data_output/Q4A_total_money_made_to_green_zones_by_neigh.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q4C: Total trips made TO green zones (by neighborhood)

select 'pickup_neighborhood', 'color', 'sum(num_trips)'
UNION ALL
select pickup_neighborhood, color, sum(num_trips)
from (
  select num_trips, color, pickup_neighborhood
  from trips
  where dropoff_zone = "green"
  and pickup_date >= DATE('2013-08-01')
) as green_zone
group by pickup_neighborhood, color
order by pickup_neighborhood, color
INTO OUTFILE '/tmp/big_data_output/Q4C_total_trips_made_to_green_zones_by_neigh.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


-- Q5A: Total money made FROM green zones (by neighborhood)

select 'dropoff_neighborhood', 'color', 'sum(total_amount)'
UNION ALL
select dropoff_neighborhood, color, sum(total_amount)
from (
  select total_amount, color, dropoff_neighborhood
  from trips
  where pickup_zone = "green"
  and pickup_date >= DATE('2013-08-01')
) as green_zone
group by dropoff_neighborhood, color 
order by dropoff_neighborhood, color
INTO OUTFILE '/tmp/big_data_output/Q5A_total_money_made_from_green_zones_by_neigh.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q5C: Total trips made FROM green zones (by neighborhood)

select 'dropoff_neighborhood', 'color', 'sum(num_trips)'
UNION ALL
select dropoff_neighborhood, color, sum(num_trips)
from (
  select num_trips, color, dropoff_neighborhood
  from trips
  where pickup_zone = "green"
  and pickup_date >= DATE('2013-08-01')
) as green_zone
group by dropoff_neighborhood,color
order by dropoff_neighborhood,color
INTO OUTFILE '/tmp/big_data_output/Q5C_total_trips_made_from_green_zones_by_neigh.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q6A: average stats for trips made TO green zones

select 'color', 'avg_passenger_count', 'avg_trip_distance', 'avg_tolls_amount', 'avg_tip'
UNION ALL
select color, 
  sum(passenger_count)/sum(num_trips) as avg_passenger_count,
  sum(trip_distance)/sum(num_trips) as avg_trip_distance,
  sum(tolls_amount)/sum(num_trips) as avg_tolls_amount,
  sum(tip_amount)/sum(fare_amount) as avg_tip
from (
  select color, passenger_count, trip_distance, tolls_amount, tip_amount, fare_amount, num_trips
  from trips
  where dropoff_zone = "green"
  and pickup_date >= DATE('2013-08-01')
) t
group by t.color
INTO OUTFILE '/tmp/big_data_output/Q6A_avg_stats_to_green.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Q6C: average stats for trips made FROM green zones

select 'color', 'avg_passenger_count', 'avg_trip_distance', 'avg_tolls_amount', 'avg_tip'
UNION ALL
select color, 
  sum(passenger_count)/sum(num_trips) as avg_passenger_count,
  sum(trip_distance)/sum(num_trips) as avg_trip_distance,
  sum(tolls_amount)/sum(num_trips) as avg_tolls_amount,
  sum(tip_amount)/sum(fare_amount) as avg_tip
from (
  select color, passenger_count, trip_distance, tolls_amount, tip_amount, fare_amount, num_trips
  from trips
  where pickup_zone = "green"
  and pickup_date >= DATE('2013-08-01')
) t
group by t.color
INTO OUTFILE '/tmp/big_data_output/Q6C_avg_stats_from_green.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


-- Q71 Percent Change in money made by yellow cabs from [2012-08-01, 2013-01-01) to [2013-08-01, 2014-01-01), by pickup neighborhood.

select first_year.pickup_neighborhood as neighborhood, 
  (second_year.sum_total_amount - first_year.sum_total_amount) / first_year.sum_total_amount as percent_money_change
from (
  select pickup_neighborhood, sum(total_amount) as sum_total_amount
  from trips
  where pickup_date >= DATE('2012-08-01')
  and pickup_date < DATE('2013-01-01')
  and color = 'Y'
  group by pickup_neighborhood
) first_year,
(
  select pickup_neighborhood, sum(total_amount) as sum_total_amount
  from trips
  where pickup_date >= DATE('2013-08-01')
  and pickup_date < DATE('2014-01-01')
  and color = 'Y'
  group by pickup_neighborhood
) second_year
where first_year.pickup_neighborhood = second_year.pickup_neighborhood
order by neighborhood
INTO OUTFILE '/tmp/big_data_output/Q71_pct_money_yellow_change_yoy.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


-- Q72 Percent Change in number of trips made by yellow cabs from [2012-08-01, 2013-01-01) to [2013-08-01, 2014-01-01), by pickup neighborhood.

select first_year.pickup_neighborhood as neighborhood, 
  (second_year.sum_num_trips - first_year.sum_num_trips) / first_year.sum_num_trips as percent_trips_change
from (
  select pickup_neighborhood, sum(num_trips) as sum_num_trips
  from trips
  where pickup_date >= DATE('2012-08-01')
  and pickup_date < DATE('2013-01-01')
  and color = 'Y'
  group by pickup_neighborhood
) first_year,
(
  select pickup_neighborhood, sum(num_trips) as sum_num_trips
  from trips
  where pickup_date >= DATE('2013-08-01')
  and pickup_date < DATE('2014-01-01')
  and color = 'Y'
  group by pickup_neighborhood
) second_year
where first_year.pickup_neighborhood = second_year.pickup_neighborhood
order by neighborhood
INTO OUTFILE '/tmp/big_data_output/Q72_pct_trips_yellow_change_yoy.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


