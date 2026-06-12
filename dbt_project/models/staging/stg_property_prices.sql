with source as (
    select * from {{ source('raw', 'property_price_register') }}
),

cleaned as (
    select
        parse_date('%d/%m/%Y', date_of_sale)                          as sale_date,
        trim(address)                                                  as address,
        initcap(trim(county))                                          as county,
        nullif(trim(eircode), '')                                      as eircode,

        cast(
            regexp_replace(
                regexp_replace(price, r'[€,]', ''),
                r'\s+', ''
            ) as numeric
        )                                                              as price_eur,

        case
            when lower(not_full_market_price) = 'yes' then true
            else false
        end                                                            as is_not_full_market_price,

        case
            when lower(vat_exclusive) = 'yes' then true
            else false
        end                                                            as is_vat_exclusive,

        trim(description_of_property)                                  as property_description,
        trim(property_size_description)                                as property_size,

        extract(year from parse_date('%d/%m/%Y', date_of_sale))        as sale_year,
        cast(extract(year from parse_date('%d/%m/%Y', date_of_sale)) as float64) as sale_year_float,
        extract(month from parse_date('%d/%m/%Y', date_of_sale))       as sale_month

    from source
    where price is not null
      and county is not null
      and date_of_sale is not null
)

select * from cleaned
