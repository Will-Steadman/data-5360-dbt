{{ config(alias='fact_marketing') }}

SELECT
    u.USER_KEY,
    e.EMAIL_KEY,
    et.EVENTTYPE_KEY,
    c.CAMPAIGNSF_KEY,

    ds.DATE_KEY AS DATESENT_KEY,
    de.DATE_KEY AS DATEEVENT_KEY,

    m.EMAILEVENTID AS EMAIL_EVENT_ID,

    DATEDIFF(
        'minute',
        CAST(m.SENDTIMESTAMP AS TIMESTAMP),
        CAST(m.EVENTTIMESTAMP AS TIMESTAMP)
    ) AS SEND_TO_EVENT_MINUTES

FROM {{ source('ecoessentials_marketing', 'marketing_emails') }} m

INNER JOIN {{ ref('dim_user') }} u
    ON m.SUBSCRIBERFIRSTNAME = u.FIRST_NAME
    AND m.SUBSCRIBERLASTNAME = u.LAST_NAME

INNER JOIN {{ ref('dim_email') }} e
    ON m.EMAILID = e.EMAILID

INNER JOIN {{ ref('dim_eventType') }} et
    ON m.EVENTTYPE = et.EVENT_TYPE

INNER JOIN {{ ref('dim_campaignSF') }} c
    ON m.CAMPAIGNID = c.CAMPAIGN_ID

INNER JOIN {{ ref('eco_dim_date') }} ds
    ON ds.DATE = CAST(m.SENDTIMESTAMP AS DATE)

INNER JOIN {{ ref('eco_dim_date') }} de
    ON de.DATE = CAST(m.EVENTTIMESTAMP AS DATE)