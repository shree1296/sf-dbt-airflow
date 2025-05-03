{{ config(
    materialized = 'table',
    tags = ['dim']
) }}

with offices as (
    select
        office_code,
        city,
        state,
        country,
        territory,
        phone,
        addressline1,
        addressline2,
        postal_code,
        loaded_date
    from {{ ref('stg_offices') }}
)

select * from offices
