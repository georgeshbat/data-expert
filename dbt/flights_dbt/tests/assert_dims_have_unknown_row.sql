-- Every dimension should have exactly one -1 (unknown) row, added by the post-hook.
-- The test fails if it returns rows.

select 'dim_airport' as dim_name
      ,count(*) as unknown_rows
from {{ ref('dim_airport') }}
where airport_code = '-1'
having count(*) <> 1

union all

select 'dim_aircraft' as dim_name
      ,count(*) as unknown_rows
from {{ ref('dim_aircraft') }}
where aircraft_code = '-1'
having count(*) <> 1
