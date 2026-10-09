-- A flight can not arrive before it departs.
-- The test fails if it returns rows.

select flight_id
      ,scheduled_departure
      ,scheduled_arrival
      ,actual_departure
      ,actual_arrival
from {{ ref('fact_flights') }}
where scheduled_arrival <= scheduled_departure
   or actual_arrival <= actual_departure
