{{ config(
    materialized = 'table',
    tags = ['dimension']
) }}

with source as (
    select
        customernumber,
        customername,
        contactlastname,
        contactfirstname,
        phone,
        addressline1,
        addressline2,
        city,
        state,
        postalcode,
        country,
        salesrepemployeenumber,
        creditlimit,
        loaded_date
    from {{ source('classicmodels', 'customers') }}
),

transformed as (
    select
        customernumber                 as customer_id,
        customername                   as customer_name,
        contactlastname                as contact_last_name,
        contactfirstname               as contact_first_name,
        phone,
        addressline1,
        addressline2,
        city,
        state,
        postalcode,
        country,
        salesrepemployeenumber         as sales_rep_employee_id,
        creditlimit                    as credit_limit,
        loaded_date
    from source
)

select * from transformed
