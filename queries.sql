

-- Total money made in green zones

select year_val, month_val, sum(total_amount)
from (
  select YEAR(pickup_date) as year_val, MONTH(pickup_date) as month_val, total_amount
  from trips
  where zone = 'green'
) as green_zone
group by year_val, month_val
order by year_val, month_val;

-- Total money made in green zones, split into taxi color

select year_val, month_val, color, sum(total_amount)
from (
  select YEAR(pickup_date) as year_val, MONTH(pickup_date) as month_val, color, total_amount
  from trips
  where zone = 'green'
) as green_zone
group by year_val, month_val, color
order by year_val, month_val, color;

