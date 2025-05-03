-- models/stg/stg_offices.sql

{{
    config(
        materialized = 'view',
        tags = ['staging']
    )
}}

WITH source_data AS (
    SELECT
        OFFICECODE,
        CITY,
        PHONE,
        ADDRESSLINE1,
        ADDRESSLINE2,
        STATE,
        COUNTRY,
        POSTALCODE,
        TERRITORY,
        LOADED_DATE
    FROM {{ source('classicmodels', 'offices') }}
    WHERE LOADED_DATE IS NOT NULL -- Filtering out records with null loaded date
),
transformed as(

SELECT
    OFFICECODE as office_code,
    CITY,
    PHONE,
    ADDRESSLINE1,
    ADDRESSLINE2,
    STATE,
    COUNTRY,
    POSTALCODE as postal_code,
    TERRITORY,
    LOADED_DATE,
FROM source_data
)
select * from transformed
