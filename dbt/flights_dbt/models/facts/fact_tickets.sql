{{ config(
    materialized='incremental',
    unique_key='ticket_no',
    indexes=[
        {'columns': ['ticket_no'], 'unique': True}
       ,{'columns': ['book_ref']}
       ,{'columns': ['date_key']}
    ]
) }}

with bookings as(
  select *
  from {{source('stg','bookings')}} b
)
,tickets as(
  select t.*
        ,{{ dbt_run_time() }} as dbt_run_time
  from {{source('stg','tickets')}} t
)

select t.ticket_no
  	  ,t.book_ref
  	  ,{{ date_key('b.book_date') }} as date_key
  	  ,b.book_date
  	  ,b.total_amount
  	  ,t.passenger_id
  	  ,t.passenger_name
  	  ,{{ json_value('t.contact_data', 'phone') }} as phone
  	  ,{{ json_value('t.contact_data', 'email') }} as email
  	  ,t.last_update as last_update_tickets
      ,t.dbt_run_time
from tickets t
left join bookings b
on b.book_ref = t.book_ref
where 1=1
{% if is_incremental() %}
and t.last_update > (select coalesce(max(last_update_tickets),'1900-01-01') from {{ this }})
{% endif %}
