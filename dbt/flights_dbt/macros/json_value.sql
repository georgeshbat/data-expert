{% macro json_value(column, key) %}

    ({{ column }} ->> '{{ key }}')

{% endmacro %}
