{% snapshot tabela_snapshot %}

{{
    config(
      target_database='postgres',
      target_schema='snapshots',
      unique_key='id',

      strategy='timestamp',
      updated_at='dia', --campo de datastamp da tabela
    )
}}

select * from {{ ref('tabela') }}

{% endsnapshot %}
