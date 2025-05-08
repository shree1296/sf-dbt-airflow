{{ config(
    materialized = 'table',
    tags = ['fct']
) }}

with payments as (
    select
        p.customer_id,
        p.check_number,
        p.payment_date,
        p.payment_amount,
        c.sales_rep_employee_id as sales_rep_id,
        p.loaded_date
    from {{ ref('stg_payments') }} p
    left join {{ ref('stg_customers') }} c
        on p.customer_id = c.customer_id
)

select * from payments
