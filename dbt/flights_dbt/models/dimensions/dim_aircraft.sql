{{ config(
    indexes=[
        {'columns': ['aircraft_code', 'seat_no'], 'unique': True}
       ,{'columns': ['aircraft_code']}
    ],
    post_hook="insert into {{this}} (aircraft_code, model_english, model_russian, range_desc, seat_no, fare_conditions) values ('-1','NA','NA','NA','NA','NA')"
) }}

with aircrafts_data as(
  select a.*
        ,{{ dbt_run_time() }} as dbt_run_time
  from {{source('stg','aircrafts_data')}} a
)
, seats as (
  select *
  from {{source('stg','seats')}}
)
select ad.aircraft_code
      ,{{ json_value('ad.model', 'en') }} as model_english
      ,{{ json_value('ad.model', 'ru') }} as model_russian
  	  ,ad."range"
  	  ,case when ad."range" > 5600 then 'high' else 'low' end as range_desc
  	  ,s.seat_no
  	  ,s.fare_conditions
      ,ad.dbt_run_time
from aircrafts_data ad
left join seats s
on ad.aircraft_code = s.aircraft_code
