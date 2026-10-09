{{ config(
    indexes=[{'columns': ['airport_code'], 'unique': True}],
    post_hook="insert into {{this}} (airport_code, airport_name_english, airport_name_russian, city_english, city_russian, timezone) values ('-1','NA','NA','NA','NA','NA')"
) }}

with airports_data as(
  select a.*
      ,{{ dbt_run_time() }} as dbt_run_time
from {{source('stg','airports_data')}} a
)

select ad.airport_code
	  ,{{ json_value('ad.airport_name', 'en') }} as airport_name_english
	  ,{{ json_value('ad.airport_name', 'ru') }} as airport_name_russian
	  ,{{ json_value('ad.city', 'en') }} as city_english
	  ,{{ json_value('ad.city', 'ru') }} as city_russian
	  ,ad.coordinates
	  ,ad.timezone
    ,ad.dbt_run_time
	  ,ad.last_update
from airports_data ad
