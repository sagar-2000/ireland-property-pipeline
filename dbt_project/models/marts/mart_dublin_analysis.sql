with dublin as (
    select * from {{ ref('stg_property_prices') }}
    where county = 'Dublin'
      and is_not_full_market_price = false
),

with_median as (
    select
        regexp_extract(eircode, r'^(D\d{1,2})') as dublin_postcode,
        sale_year,
        sale_year_float,
        price_eur,
        percentile_cont(price_eur, 0.5) over (
            partition by regexp_extract(eircode, r'^(D\d{1,2})'), sale_year
        ) as median_price
    from dublin
    where eircode is not null
),

aggregated as (
    select
        dublin_postcode,
        sale_year,
        any_value(sale_year_float)        as sale_year_float,
        count(*)                          as total_sales,
        round(avg(price_eur), 2)          as avg_price,
        round(any_value(median_price), 2) as median_price
    from with_median
    where dublin_postcode is not null
    group by dublin_postcode, sale_year
)

select * from aggregated
order by sale_year, avg_price desc
