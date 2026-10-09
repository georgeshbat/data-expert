{% macro duration_hours(start_col, end_col) %}

    round((extract(epoch from {{ end_col }} - {{ start_col }}) / (60*60))::numeric, 2)

{% endmacro %}
