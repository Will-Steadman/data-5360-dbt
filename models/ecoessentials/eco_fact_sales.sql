{{ config(alias='fact_sales') }}

SELECT
    u.USER_KEY,
    d.DATE_KEY,
    p.PRODUCT_KEY,
    c.CAMPAIGNPM_KEY,

    ol.ORDER_ID,
    ol.QUANTITY,

    (ol.QUANTITY * p.PRICE) AS LINE_TOTAL,

    ol.DISCOUNT,

    ol.PRICE_AFTER_DISCOUNT AS LINE_TOTAL_AFTER_DISCOUNT

FROM {{ source('ecoessentials_transactional', 'ORDER_LINE') }} ol

INNER JOIN {{ source('ecoessentials_transactional', 'orders') }} o
    ON ol.ORDER_ID = o.ORDER_ID

INNER JOIN {{ ref('dim_user') }} u
    ON TO_VARCHAR(o.CUSTOMER_ID) = u.CUSTOMER_ID

INNER JOIN {{ ref('eco_dim_date') }} d
    ON d.DATE = CAST(o.ORDER_TIMESTAMP AS DATE)

INNER JOIN {{ ref('dim_product') }} p
    ON ol.PRODUCT_ID = p.PRODUCT_ID

LEFT JOIN {{ ref('dim_campaignPM') }} c
    ON ol.CAMPAIGN_ID = c.CAMPAIGN_ID