-- models/stg/stg_employees.sql

{{
    config(
        materialized = 'view',
        tags = ['staging']
    )
}}

WITH source_data AS (
    SELECT
        EMPLOYEENUMBER,
        LASTNAME,
        FIRSTNAME,
        EXTENSION,
        EMAIL,
        OFFICECODE,
        REPORTSTO,
        JOBTITLE,
        LOADED_DATE
    FROM {{ source('classicmodels', 'employees') }}
    WHERE LOADED_DATE IS NOT NULL -- Filtering out records with null loaded date
),
transformed as (
    SELECT
        EMPLOYEENUMBER as employee_number,
        LASTNAME as last_name,
        FIRSTNAME as first_name,
        EXTENSION,
        EMAIL,
        OFFICECODE as office_code,
        REPORTSTO as reports_to,
        JOBTITLE as job_title,
        LOADED_DATE
    FROM source_data
)
select * from transformed
