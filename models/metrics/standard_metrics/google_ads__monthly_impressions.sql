-- depends of {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select *
from {{ metrics.calculate(
  metric('google_ads__monthly_impressions'),
  grain = 'month',
  dimensions = [],
  secondary_calculations = []
) }}
