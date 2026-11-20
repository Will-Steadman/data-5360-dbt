WITH customers AS (

    SELECT
        TO_VARCHAR(CUSTOMER_ID) AS CUSTOMER_ID,
        CUSTOMER_FIRST_NAME,
        CUSTOMER_LAST_NAME,
        CUSTOMER_EMAIL,
        CUSTOMER_PHONE,
        CUSTOMER_ADDRESS,
        CUSTOMER_CITY,
        CUSTOMER_STATE,
        CUSTOMER_ZIP,
        CUSTOMER_COUNTRY
    FROM {{ source('ecoessentials_transactional', 'CUSTOMER') }}

),

marketing_users AS (

    SELECT
        SUBSCRIBERFIRSTNAME,
        SUBSCRIBERLASTNAME,

        MAX(
            CASE
                WHEN TO_VARCHAR(CUSTOMERID) = 'NULL' THEN NULL
                ELSE TO_VARCHAR(CUSTOMERID)
            END
        ) AS CUSTOMERID,

        MAX(
            CASE
                WHEN TO_VARCHAR(SUBSCRIBERID) = 'NULL' THEN NULL
                ELSE TO_VARCHAR(SUBSCRIBERID)
            END
        ) AS SUBSCRIBERID,

        MAX(
            CASE
                WHEN SUBSCRIBEREMAIL = 'NULL' THEN NULL
                ELSE SUBSCRIBEREMAIL
            END
        ) AS SUBSCRIBEREMAIL

    FROM {{ source('ecoessentials_marketing', 'marketing_emails') }}

    GROUP BY
        SUBSCRIBERFIRSTNAME,
        SUBSCRIBERLASTNAME

)

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'COALESCE(c.CUSTOMER_FIRST_NAME, m.SUBSCRIBERFIRSTNAME)',
        'COALESCE(c.CUSTOMER_LAST_NAME, m.SUBSCRIBERLASTNAME)'
    ]) }} AS USER_KEY,

    COALESCE(
        c.CUSTOMER_ID,
        m.CUSTOMERID
    ) AS CUSTOMER_ID,

    m.SUBSCRIBERID AS SUBSCRIBER_ID,

    COALESCE(
        c.CUSTOMER_FIRST_NAME,
        m.SUBSCRIBERFIRSTNAME
    ) AS FIRST_NAME,

    COALESCE(
        c.CUSTOMER_LAST_NAME,
        m.SUBSCRIBERLASTNAME
    ) AS LAST_NAME,

    COALESCE(
        c.CUSTOMER_EMAIL,
        m.SUBSCRIBEREMAIL
    ) AS EMAIL,

    c.CUSTOMER_PHONE AS PHONE,
    c.CUSTOMER_ADDRESS AS ADDRESS,
    c.CUSTOMER_CITY AS CITY,
    c.CUSTOMER_STATE AS STATE,
    c.CUSTOMER_ZIP AS ZIP,
    c.CUSTOMER_COUNTRY AS COUNTRY

FROM customers c

FULL OUTER JOIN marketing_users m
    ON c.CUSTOMER_FIRST_NAME = m.SUBSCRIBERFIRSTNAME
    AND c.CUSTOMER_LAST_NAME = m.SUBSCRIBERLASTNAME