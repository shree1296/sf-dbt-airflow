{{ config(
    materialized = 'table',
    tags = ['fct']
) }}

with orders as (
    select
        o.order_number,
        o.order_date,
        o.required_date,
        o.shipped_date,
        o.status,
        o.customer_number        as customer_id,
        c.sales_rep_employee_id  as sales_rep_id,
        o.loaded_date
    from {{ ref('stg_orders') }} o
    left join {{ ref('stg_customers') }} c
        on o.customer_number = c.customer_id
)

select * from orders
