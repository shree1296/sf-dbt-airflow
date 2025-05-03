create or replace view CLASSICMODELS.staging.dim_date as

-- models/dim/dim_date.sql
with rawdata as (
    -- Generate a large sequence of numbers using cross joins.
    -- This is a technique to generate a large range of numbers for creating a date spine.
    with p as (
        select 0 as generated_number
        union all select 1
    ),
    unioned as (
        select
            p0.generated_number * power(2, 0) +
            p1.generated_number * power(2, 1) +
            p2.generated_number * power(2, 2) +
            p3.generated_number * power(2, 3) +
            p4.generated_number * power(2, 4) +
            p5.generated_number * power(2, 5) +
            p6.generated_number * power(2, 6) +
            p7.generated_number * power(2, 7) +
            p8.generated_number * power(2, 8) +
            p9.generated_number * power(2, 9) +
            p10.generated_number * power(2, 10) +
            p11.generated_number * power(2, 11) +
            p12.generated_number * power(2, 12) +
            p13.generated_number * power(2, 13) + 1 as generated_number
        from
            p as p0 cross join p as p1 cross join p as p2 cross join p as p3
            cross join p as p4 cross join p as p5 cross join p as p6 cross join p as p7
            cross join p as p8 cross join p as p9 cross join p as p10 cross join p as p11
            cross join p as p12 cross join p as p13
    )
    -- Select only the first 11322 generated numbers to avoid unnecessary growth.
    select *
    from unioned
    where generated_number <= 11322
),

all_periods as (
    -- Generate a date range by adding days to a starting date (2000-01-01).
    -- We use `row_number()` to generate an incremental day number for creating the date range.
    select dateadd(
        day,
        row_number() over (order by generated_number) - 1,  -- Row number starts at 1, so subtract 1 to align with the start date
        cast('2000-01-01' as date)
    ) as date_day
    from rawdata
),

filtered as (
    -- Filter the dates to ensure we only include dates up to 2030-12-31
    select date_day
    from all_periods
    where date_day <= cast('2030-12-31' as date)
),

date_dim as (
    -- This is the final date dimension that will be returned.
    select
        filtered.date_day as date,  -- Date column (in date format)
        extract(year from filtered.date_day) as year,  -- Year part of the date
        extract(quarter from filtered.date_day) as quarter,  -- Quarter of the year (1-4)
        extract(month from filtered.date_day) as month,  -- Month part of the date (1-12)
        lpad(cast(extract(month from filtered.date_day) as string), 2, '0') as month_padded,  -- Padded month (01-12)
        extract(day from filtered.date_day) as day,  -- Day part of the date (1-31)
        to_char(filtered.date_day, 'Day') as day_name,  -- Name of the day (e.g., Monday, Tuesday, etc.)
        to_char(filtered.date_day, 'YYYY-MM') as year_month,  -- Year and month in YYYY-MM format
        to_char(filtered.date_day, 'YYYY-MM-DD') as full_date,  -- Full date in YYYY-MM-DD format
        case
            when extract(dow from filtered.date_day) in (0, 6) then 'Weekend'  -- If the day of the week is Saturday or Sunday
            else 'Weekday'  -- Otherwise, it's a weekday
        end as day_type  -- Classification of day as 'Weekend' or 'Weekday'
)

-- Return the final date dimension data.
select * from date_dim