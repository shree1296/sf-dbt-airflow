{{ config(
    materialized = 'table',
    tags = ['dim']
) }}

with products as (
    select
        p.productcode             as product_id,
        p.product_name,
        p.product_line,
        p.product_scale,
        p.product_vendor,
        p.product_description,
        p.quantity_in_stock,
        p.buy_price,
        p.msrp,
        pl.text_description       as product_line_description,
        p.loaded_date
    from {{ ref('stg_products') }} p
    left join {{ ref('stg_productlines') }} pl
        on p.product_line = pl.productline
)

select * from products
