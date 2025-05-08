-- models/staging/stg_orders.sql

{{ config(
    materialized = 'view',
    tags = ['staging']
) }}

with source as (
    select
        ordernumber,
        orderdate,
        requireddate,
        shippeddate,
        status,
        comments,
        customernumber,
        loaded_date
    from {{ source('classicmodels', 'orders') }}
),

transformed as (
    select
        ordernumber                  as order_number,
        orderdate                   as order_date,
        requireddate                as required_date,
        shippeddate                 as shipped_date,
        lower(trim(status))         as status,
        comments,
        customernumber              as customer_number,
        loaded_date
    from source
)

select * from transformed
