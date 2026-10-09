{{ config(materialized='incremental',unique_key='flight_id') }}

with flights as(
  select f.*
      	,'{{run_started_at.strftime("%Y-%m-%d %H:%M:%S")}}'::timestamp as dbt_run_time
  from {{source('stg','flights')}} f
)
,aircraft as (
	select 
	distinct aircraft_code
	from {{ ref('dim_aircraft') }}
)
,airport as (
	select 
	*
	from {{ ref('dim_airport') }}
)
,final_result as (
	select 
	f.flight_id
	,f.flight_no
	,f.scheduled_departure
	,f.scheduled_arrival
	,case when departure.airport_code is null then '-1' else departure.airport_code end as departure_airport
	,case when arrival.airport_code is null then '-1' else arrival.airport_code end as arrival_airport
	,f.status
	,case when aircraft.aircraft_code is null then '-1' else aircraft.aircraft_code end as aircraft_code
	,f.actual_departure
	,f.actual_arrival
	,round((extract(epoch from f.actual_arrival - f.actual_departure)/(60*60))::numeric,2) as flight_duration
	,round((extract(epoch from f.scheduled_arrival - f.scheduled_departure)/(60*60))::numeric,2) as flight_duration_expected
	,case when f.actual_departure is null or f.actual_arrival is null then null
		  when (f.scheduled_arrival - f.scheduled_departure) = (f.actual_arrival - f.actual_departure) then 'As Expected'
		  when (f.scheduled_arrival - f.scheduled_departure) > (f.actual_arrival - f.actual_departure) then 'Longer'
		  else 'Shorter'
	end as duration_expected_than_actual
		,f.last_update
		,f.dbt_run_time
	from flights f
	left join aircraft on aircraft.aircraft_code = f.aircraft_code
	left join airport as arrival on arrival.airport_code = f.arrival_airport
	left join airport as departure on departure.airport_code = f.departure_airport
)
select 
*
from final_result
where 1=1
{% if is_incremental() %}
and last_update > (select coalesce(max(last_update),'1900-01-01') from {{ this }})
{% endif %}
