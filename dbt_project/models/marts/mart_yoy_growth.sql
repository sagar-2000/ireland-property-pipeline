with county_yearly as (
    select
        county,
        sale_year,
        avg_price,
        median_price,
        total_sales
    from {{ ref('mart_county_trends') }}
),

with_lag as (
    select
        county,
        sale_year,
        avg_price,
        median_price,
        total_sales,
        lag(avg_price) over (partition by county order by sale_year)     as prev_year_avg_price,
        lag(total_sales) over (partition by county order by sale_year)   as prev_year_sales
    from county_yearly
),

with_growth as (
    select
        county,
        sale_year,
        avg_price,
        median_price,
        total_sales,
        prev_year_avg_price,
        round(
            safe_divide(avg_price - prev_year_avg_price, prev_year_avg_price) * 100,
            2
        )                                                                as yoy_price_growth_pct,
        round(
            safe_divide(total_sales - prev_year_sales, prev_year_sales) * 100,
            2
        )                                                                as yoy_sales_growth_pct
    from with_lag
)

select * from with_growth
order by county, sale_year
