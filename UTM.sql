-- Explore Data
SELECT *
FROM page_visits
LIMIT
10;

-- Distinct campaigns
SELECT COUNT(DISTINCT utm_campaign) AS 'num_campaigns'
FROM page_visits;

-- Distinct utm sources
SELECT COUNT(DISTINCT utm_source) AS 'num_sources'
FROM page_visits;

-- Relation between utm campaign and utm source
SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

-- Pages found in the CoolTShirts website
SELECT DISTINCT page_name AS 'page_names'
FROM page_visits;

-- First touches each campaign is responsible for
WITH
    first_touch
    AS
    (
        SELECT user_id,
            MIN(timestamp) as first_touch_at
        FROM page_visits
        GROUP BY user_id
    )
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(utm_campaign) AS 'num_first_touches'
FROM first_touch ft
    JOIN page_visits pv
    ON ft.user_id = pv.user_id
        AND ft.first_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 5 DESC;

-- Last touches each campaign is responsible for 
WITH
    last_touch
    AS
    (
        SELECT user_id,
            MAX(timestamp) as last_touch_at
        FROM page_visits
        GROUP BY user_id
    )
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(utm_campaign) AS 'num_last_touches'
FROM last_touch lt
    JOIN page_visits pv
    ON lt.user_id = pv.user_id
        AND lt.last_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 5 DESC;


-- Number of visitors that make a purchase 
SELECT COUNT(DISTINCT user_id) AS 'num_purchases'
FROM page_visits
WHERE page_name = '4 - purchase';


-- Number of last touches on the purchase page each campaign is responsible for 
WITH
    last_touch
    AS
    (
        SELECT user_id,
            MAX(timestamp) as last_touch_at
        FROM page_visits
        WHERE page_name = '4 - purchase'
        GROUP BY user_id
    )
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(utm_campaign) AS 'num_last_touch_purchase_page'
FROM last_touch lt
    JOIN page_visits pv
    ON lt.user_id = pv.user_id
        AND lt.last_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 5 DESC;






















