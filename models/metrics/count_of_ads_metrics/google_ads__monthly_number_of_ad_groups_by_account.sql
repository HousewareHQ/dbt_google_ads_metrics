-- depends of {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select *
from {{ metrics.calculate(
  metric('google_ads__monthly_number_of_ad_groups_by_account'),
  grain = 'month',
  dimensions = ['account_name'],
  secondary_calculations = []
) }}
