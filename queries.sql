-- USEFUL SNIPPETS
-- TO GREEN: where dropoff_zone = "green"
-- FROM GREEN: where pickup_zone = "green"
-- WITHIN GREEN: where dropoff_zone = "green" and pickup_zone = "green"
-- variables to compare: passenger_count trip_distance tolls_amount tip_amount/total_amount



-- Delete UNKNOWN pickup or dropoff neighborhoods

DELETE from trips 
WHERE dropoff_neighborhood = "UNKNOWN" OR dropoff_neighborhood = "UNKNOWN"

---------------------------------------------------------------------------------------

-- Q0A: Total money made

select week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount, color
  from trips
) as green_zone
group by week_val
order by week_val;

-- Q0C: Total trips made

select week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips
  from trips
) as green_zone
group by week_val
order by week_val;

---------------------------------------------------------------------------------------

-- Q1A: Total money made TO green zones

select color,week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount, color
  from trips
  where dropoff_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val;

-- Q1C: Total trips made TO green zones

select color,week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips, color
  from trips
  where dropoff_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val;

-- Q2A: Total money made FROM green zones

select color,week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount, color
  from trips
  where pickup_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val;

-- Q2C: Total trips made FROM green zones

select color,week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips, color
  from trips
  where pickup_zone = "green"
) as green_zone
group by color, week_val
order by color, week_val;

-- Q3A: Total money made WITHIN green zones

select color,week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount, color
  from trips
  where pickup_zone = "green" and dropoff_zone= "green"
) as green_zone
group by color, week_val
order by color, week_val;

-- Q3C: Total trips made WITHIN green zones

select color,week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips, color
  from trips
  where pickup_zone = "green" and dropoff_zone= "green"
) as green_zone
group by color, week_val
order by color, week_val;

---------------------------------------------------------------------------------

-- Q4A: Total money made TO green zones (by neighborhood)

select pickup_neighborhood,color,week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount, color,pickup_neighborhood
  from trips
  where dropoff_zone = "green"
) as green_zone
group by pickup_neighborhood,color, week_val
order by pickup_neighborhood,color, week_val;

-- Q4C: Total trips made TO green zones (by neighborhood)

select pickup_neighborhood,color,week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips, color,pickup_neighborhood
  from trips
  where dropoff_zone = "green"
) as green_zone
group by pickup_neighborhood,color, week_val
order by pickup_neighborhood,color, week_val;


-- Q5A: Total money made FROM green zones (by neighborhood)

select dropoff_neighborhood,color,week_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, total_amount, color,dropoff_neighborhood
  from trips
  where pickup_zone = "green"
) as green_zone
group by dropoff_neighborhood,color, week_val
order by dropoff_neighborhood,color, week_val;

-- Q5C: Total trips made FROM green zones (by neighborhood)

select dropoff_neighborhood,color,week_val, sum(num_trips)
from (
  select YEARWEEK(pickup_date) as week_val, num_trips, color,dropoff_neighborhood
  from trips
  where pickup_zone = "green"
) as green_zone
group by dropoff_neighborhood,color, week_val
order by dropoff_neighborhood,color, week_val;

---------------------------------------------------------------------------------------



---------------OLD QUERIES

-- Total money made in green zones

select year_val, month_val, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, MONTH(pickup_date) as month_val, total_amount
  from trips
  where zone = 'green'
) as green_zone
group by year_val, month_val
order by year_val, month_val;

-- Total money made in green zones, split into taxi color

select year_val, month_val, color, sum(total_amount)
from (
  select YEARWEEK(pickup_date) as week_val, MONTH(pickup_date) as month_val, color, total_amount
  from trips
  where zone = 'green'
) as green_zone
group by year_val, month_val, color
order by year_val, month_val, color;

