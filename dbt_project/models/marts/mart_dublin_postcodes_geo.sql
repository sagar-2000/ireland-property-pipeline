with postcode_coords as (
    select * from unnest([
        struct('D01' as postcode, 53.3461 as lat, -6.2611 as lng),
        struct('D02', 53.3418, -6.2618),
        struct('D03', 53.3336, -6.2377),
        struct('D04', 53.3201, -6.2354),
        struct('D05', 53.3576, -6.2388),
        struct('D06', 53.3196, -6.2730),
        struct('D07', 53.3541, -6.2933),
        struct('D08', 53.3366, -6.2879),
        struct('D09', 53.3739, -6.2195),
        struct('D10', 53.3395, -6.3537),
        struct('D11', 53.3876, -6.2682),
        struct('D12', 53.3170, -6.3085),
        struct('D13', 53.3910, -6.2068),
        struct('D14', 53.3008, -6.2680),
        struct('D15', 53.3881, -6.3468),
        struct('D16', 53.2918, -6.2440),
        struct('D17', 53.3490, -6.1700),
        struct('D18', 53.2792, -6.2117),
        struct('D20', 53.3290, -6.3934),
        struct('D22', 53.3263, -6.3560),
        struct('D24', 53.2900, -6.3730),
        struct('D27', 53.3900, -6.1350)
    ])
),

dublin_stats as (
    select * from {{ ref('mart_dublin_analysis') }}
)

select
    d.dublin_postcode,
    d.sale_year,
    d.sale_year_float,
    d.total_sales,
    d.avg_price,
    d.median_price,
    c.lat,
    c.lng
from dublin_stats d
left join postcode_coords c
    on d.dublin_postcode = c.postcode
