{{ config(alias='dim_date') }}

WITH cte_date AS (
    {{ dbt_date.get_date_dimension("2020-01-01", "2030-12-31") }}
)

SELECT
    date_day AS DATE_KEY,
    date_day AS DATE,
    day_of_week,
    month_name AS MONTH,
    year_number AS YEAR
FROM cte_date