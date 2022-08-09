# Google Ads Metrics dbt Package ([Docs](https://housewarehq.github.io/))

# 📣 What does this dbt package do?
This package provides pre-built metrics for Google ads data from [Fivetran's connector](https://fivetran.com/docs/applications/google-ads). It uses data in the format described by [this ERD](https://docs.google.com/presentation/d/1f16zOPxwT1AXoOcNkvwT82ApKqU1yhtJ04f-73M91nw/edit).

This package enables you to access commonly used metrics on top of Google Ads Data

## Metrics

This package contains transformed models built on top of [google_ads_source package](https://github.com/fivetran/dbt_google_ads_source). A dependency on the source packages is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`.

The metrics offered by this package are described below.
Note that some metrics contain extended metrics for segmentation based on adgroups, campaigns, and accounts.

| **metric**                          | **description**                                                                                                                                                                                                                              |
|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| google_ads__monthly_ads    | Number of ads running monthly                
| google_ads__monthly_adgroups      | Number of ad groups running monthly                         
| google_ads__monthly_campaigns    | Number of campaigns running monthly
| google_ads__monthly_accounts    | Number of accounts running monthly
| google_ads__monthly_impressions    | Total monthly impressions received across all ads
| google_ads__monthly_ad_clicks    |        Total monthly clicks received across all ads                                                             |
| google_ads__monthly_ad_conversions   |        Total monthly conversions received across all ads as measured by Google Ads                                                            |
| google_ads__monthly_ad_conversion_value   |        Total monthly conversion value received across all ads as measured by Google Ads                                                            |
| google_ads__monthly_ad_spend    |  Total monthly spend across all ads                                     |
| google_ads__monthly_cost_per_click    | Monthly cost per ad click                                                         |
| google_ads__monthly_cost_per_impression   | Monthly cost per ad impression.               |
| google_ads__monthly_click_through_rate   | Monthly rate of users clicking on ad after viewing.|     
| google_ads__monthly_cost_per_conversion   | Monthly cost per ad conversion.|   
| google_ads__monthly_roas   | Monthly return on ad spend.|   
| google_ads__monthly_avg_cost_per_click    | Monthly average cost per ad click across all ads reported at a campaign level                                                        |
| google_ads__monthly_avg_cost_per_impression   | Monthly average cost per ad impression across all ads reported at a campaign level               |
| google_ads__monthly_avg_click_through_rate   | Monthly average click-through rate across all ads reported at a campaign level|     
| google_ads__monthly_avg_cost_per_conversion   | Monthly average cost per conversion across all ads reported at a campaign level|   
| google_ads__monthly_avg_roas   | Monthly average return on ad spend across all ads reported at a campaign level|   

### Notes
Please refer to the following notes regarding nuances related to the data available from the package:
- The latest attributes for account, campaign, adgroup and ad (like `name`, `status`) are being fetched from the Fivetran source tables. To change this, you can edit the `dbt_project.yml` file:
```yml
# dbt_project.yml

...
config-version: 2

vars:
  is_most_recent_record: 'FALSE'
```

- The calculation of monthly ratio metrics is done at an aggregate level. For example, the `Monthly Cost per Click` metric for `campaigns` is calculated as `Total Spend` (across all campaigns) / `Total Clicks` (across all campaigns)
- The calculation for average ratio metrics is done by taking the average of the ad-level ratio metrics at the campaign level. For example, the `Monthly Average Cost per Click` metric is calculated as Avg (Total Spend per Ad) / Avg (Total clicks per Ad) ; this number is reported per campaign

# 🎯 How do I use the dbt package?
## Step 1: Prerequisites
To use this dbt package, you must have the following:
- At least one Fivetran Google Ads connector syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, or **PostgreSQL** destination.


## Step 2: Install the package

Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - git: "https://github.com/HousewareHQ/dbt_google_ads_metrics.git"
    revision: v0.1.0
```

## Step 3: Define database and schema variables

By default, this package will look for your Google Ads data in the `fivetran_google_ads` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Google Ads data is, please add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
  google_ads_database: your_database_name
  google_ads_schema: your_schema_name
```

For additional configurations for the source models, please visit the [Google Ads source package](https://github.com/fivetran/dbt_google_ads_source).

## (Optional) Step 4: Change build schema
By default this package will build the Google Ads staging models within a schema titled (<target_schema> + `_stg_google_ads`) and the Google Ads metrics within the target schema with the suffix `google_ads__` in your target database. If this is not where you would like your modeled Google Ads data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
  google_ads_metrics:
    +schema: my_new_schema_name # leave blank for just the target_schema
  google_ads_source:
    +schema: my_new_schema_name # leave blank for just the target_schema
```


# 🗄 Which warehouses are supported?
This package has been tested on Snowflake.


# 🙌 Can I contribute?

Additional contributions to this package are very welcome! Please create issues
or open PRs against `main`. Check out
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657)
on the best workflow for contributing to a package.


# 🏪 Are there any resources available?
- Provide [feedback](https://airtable.com/shrPHxTmfkjq3P6Eh) on what you'd like to see next
- Have questions, feedback, or need help? Email us at nipun@houseware.io
- Check out [Houseware's blog](https://www.houseware.io/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
