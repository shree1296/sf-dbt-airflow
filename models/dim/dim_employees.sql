{{ config(
    materialized = 'table',
    tags = ['dim']
) }}

with employees as (
    select
        employee_number          as employee_id,
        first_name,
        last_name,
        email,
        extension,
        job_title,
        office_code,
        reports_to,
        loaded_date
    from {{ ref('stg_employees') }}
)

select * from employees
