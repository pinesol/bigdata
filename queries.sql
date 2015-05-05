-- Delete UNKNOWN pickup or dropoff neighborhoods

DELETE from trips 
WHERE dropoff_neighborhood = "UNKNOWN" OR dropoff_neighborhood = "UNKNOWN"


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

