-- depends of {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select *
from {{ metrics.calculate(
  metric('google_ads__monthly_cost_per_conversion_by_ad'),
  grain = 'month',
  dimensions = ['ad_name'],
  secondary_calculations = []
) }}
