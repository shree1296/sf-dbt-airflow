-- models/staging/stg_order_details.sql

{{ config(
    materialized = 'view',
    tags = ['staging']
) }}

with source as (
    select
        ordernumber,
        productcode,
        quantityordered,
        priceeach,
        orderlinenumber,
        loaded_date
    from {{ source('classicmodels', 'orderdetails') }}
),

transformed as (
    select
        ordernumber             as order_number,
        productcode             as product_code,
        quantityordered         as quantity_ordered,
        priceeach               as price_each,
        orderlinenumber         as order_line_number,
        loaded_date
    from source
)

select * from transformed
