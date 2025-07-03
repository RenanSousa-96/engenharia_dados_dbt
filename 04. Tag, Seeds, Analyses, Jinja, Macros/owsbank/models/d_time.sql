{{ config(materialized='table', tags = ['dim'])}}

with cleaned_d_time as (
    select
        time_id,
        {% if target.type == 'postgres' %}
            action_timestamp:: timestamp
        {% elif target.type == 'bigquery' -%}
            timestamp(action_timestamp)
        {%- else -%}
            action_timestamp
        {%- endif -%}
        as action_timestamp
    from {{ source('postgres', 'd_time') }}
)

SELECT
    time_id,
    action_timestamp,
    {% for part in ['year', 'month', 'week', 'day', 'dayofweek'] -%}
    EXTRACT({{part | upper }} FROM action_timestamp) as action_{{part}},
    {% endfor -%}

    -- fazendo a chave com hashtag, o jinja retira no sql final
    {#
    /*date_part('year', action_timestamp) as action_year,
    date_part('month', action_timestamp) as action_month,
    date_part('week', action_timestamp) as action_week,
    --date_part('dow', action_timestamp) as action_weekday,
    to_char(action_timestamp, 'Day') as action_weekday
    date_part('day', action_timestamp) as action_day
    */
    -#}
FROM cleaned_d_time
{{ limit_lines_dev() }}
