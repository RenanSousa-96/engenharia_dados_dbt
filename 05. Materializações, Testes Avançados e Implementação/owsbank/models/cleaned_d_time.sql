--{{
--    config(
--        materialized='ephemeral'
--    )
--}}

{{
    config(
        materialized='incremental'
    )
}}

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


{% if is_incremental() %}
where event_time >= (select coalesce(max(event_time),'1900-01-01') from {{ this }} )
{% endif %}
