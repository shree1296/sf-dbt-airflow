{{ config(
    materialized = 'incremental',
    unique_key = 'productline',
    tags = ['staging']
) }}

with source as (
    select
        productline,
        textdescription,
        htmldescription,
        image,
        loaded_date
    from {{ source('classicmodels', 'productlines') }}
    {% if is_incremental() %}
        where loaded_date > (select max(loaded_date) from {{ this }})
    {% endif %}
),

transformed as (
    select
        productline                             as productline,
        trim(textdescription)                  as text_description,
        trim(htmldescription)                  as html_description,
        image,
        loaded_date
    from source
)

select * from transformed
