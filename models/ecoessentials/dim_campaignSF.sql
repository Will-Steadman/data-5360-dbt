SELECT DISTINCT
    CAMPAIGNID AS CAMPAIGNSF_KEY,
    CAMPAIGNID AS CAMPAIGN_ID,
    CAMPAIGNNAME AS CAMPAIGN_NAME
FROM {{ source('ecoessentials_marketing', 'marketing_emails') }}