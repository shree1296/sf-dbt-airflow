{{ config(
    materialized = 'table',
    tags = ['fct']
) }}

with order_items as (
    select
        od.order_number,
        od.product_code,
        od.order_line_number,
        od.quantity_ordered,
        od.price_each,
        od.quantity_ordered * od.price_each as total_price,
        od.loaded_date
    from {{ ref('stg_order_details') }} od
)

select * from order_items
