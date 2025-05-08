{{
    config(
        materialized = 'view',
        tags = ['staging']
    )
}}

with source as(
    select
        productcode,
        productname,
        productline,
        productscale,
        productvendor,
        productdescription,
        quantityinstock,
        buyprice,
        msrp,
        loaded_date
    from {{source('classicmodels','products')}}
),
transformed as(
    select
        productcode,
        trim(productname) as product_name,
        trim(productline) as product_line,
        trim(productscale) as product_scale,
        trim(productvendor) as product_vendor,
        trim(productdescription) as product_description,
        quantityinstock as quantity_in_stock,
        buyprice as buy_price,
        msrp,
        loaded_date
    from source
)
select * from transformed