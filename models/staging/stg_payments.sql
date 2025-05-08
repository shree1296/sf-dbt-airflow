{{ config(
    materialized = 'view',
    tags = ['staging']
) }}

with source as (
    select
        customernumber,
        checknumber,
        paymentdate,
        amount,
        loaded_date
    from {{ source('classicmodels', 'payments') }}
),

transformed as (
    select
        cast(customernumber as integer)        as customer_id,
        checknumber                            as check_number,
        cast(paymentdate as date)              as payment_date,
        cast(amount as number(10,2))           as payment_amount,
        loaded_date
    from source
)

select * from transformed
