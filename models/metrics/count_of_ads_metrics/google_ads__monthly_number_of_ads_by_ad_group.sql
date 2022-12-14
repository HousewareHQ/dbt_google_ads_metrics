-- depends of {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select *
from {{ metrics.calculate(
  metric('google_ads__monthly_number_of_ads_by_ad_group'),
  grain = 'month',
  dimensions = ['ad_group_name'],
  secondary_calculations = []
) }}
