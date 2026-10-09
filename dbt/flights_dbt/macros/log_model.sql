{% macro log_model(log_type) %}

    insert into shd.dbt_model_logs (model_name, log_type, event_time, row_count)
    select '{{ this.identifier }}'
          ,'{{ log_type }}'
          ,clock_timestamp()
          ,{% if log_type == 'run_end' %}(select count(*) from {{ this }}){% else %}null{% endif %}

{% endmacro %}
