SELECT
    PRODUCT_ID AS PRODUCT_KEY,
    PRODUCT_ID,
    PRODUCT_TYPE,
    PRODUCT_NAME,
    PRICE
FROM {{ source('ecoessentials_transactional', 'PRODUCT') }}