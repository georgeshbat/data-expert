{% macro date_key(column) %}

    to_char({{ column }}, 'yyyymmdd')::int

{% endmacro %}
