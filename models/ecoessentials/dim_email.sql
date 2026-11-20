SELECT DISTINCT
    EMAILID AS EMAIL_KEY,
    EMAILID,
    EMAILNAME
FROM {{ source('ecoessentials_marketing', 'marketing_emails') }}