with base as (
    select * from {{ ref('stg_property_prices') }}
    where is_not_full_market_price = false
),

with_median as (
    select
        county,
        sale_year,
        sale_year_float,
        price_eur,
        percentile_cont(price_eur, 0.5) over (partition by county, sale_year) as median_price
    from base
),

aggregated as (
    select
        county,
        sale_year,
        any_value(sale_year_float)        as sale_year_float,
        count(*)                          as total_sales,
        round(avg(price_eur), 2)          as avg_price,
        round(any_value(median_price), 2) as median_price,
        round(min(price_eur), 2)          as min_price,
        round(max(price_eur), 2)          as max_price
    from with_median
    group by county, sale_year
),

with_yoy as (
    select
        county,
        sale_year,
        sale_year_float,
        avg_price,
        median_price,
        total_sales,
        min_price,
        max_price,
        lag(avg_price) over (partition by county order by sale_year) as prev_year_avg_price,
        lag(total_sales) over (partition by county order by sale_year) as prev_year_sales
    from aggregated
)

select
    county,
    sale_year,
    sale_year_float,
    total_sales,
    avg_price,
    median_price,
    min_price,
    max_price,
    prev_year_avg_price,
    round(
        safe_divide(avg_price - prev_year_avg_price, prev_year_avg_price) * 100,
        2
    )                                                                as yoy_price_growth_pct,
    round(
        safe_divide(total_sales - prev_year_sales, prev_year_sales) * 100,
        2
    )                                                                as yoy_sales_growth_pct
from with_yoy
order by county, sale_year
