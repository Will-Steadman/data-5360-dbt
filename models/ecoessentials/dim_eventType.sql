SELECT DISTINCT
    EVENTTYPE AS EVENTTYPE_KEY,
    EVENTTYPE AS EVENT_TYPE
FROM {{ source('ecoessentials_marketing', 'marketing_emails') }}