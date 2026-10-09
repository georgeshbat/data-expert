{% macro dbt_run_time() %}

    '{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S") }}'::timestamp

{% endmacro %}
