{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
) }}

WITH cte_date AS (
    {{ dbt_date.get_date_dimension("1990-01-01", "2050-12-31") }}
)

SELECT
    date_day AS date_key,
    date_day AS date_id,
    day_of_week,
    month_name AS month,
    quarter_of_year AS quarter,
    year_number AS year
FROM cte_date