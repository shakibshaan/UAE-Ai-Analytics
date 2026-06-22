USE UAE_AI_Analytics;

-- small mess up here forgt to check the city null; in this case there shouldn be any null values primarily any othershould have been  "unknown///"
-- so I replaced the NULL with "Ras Al Khaimah" shouldve been this city instead of NULL
-- AI adoption and spend by UAE city
SELECT
    COALESCE(u.city, 'Ras Al Khaimah')        AS city,
    COUNT(DISTINCT f.user_key)         AS unique_users,
    COUNT(f.usage_key)                 AS total_sessions,
    AVG(f.session_duration_minutes*1.0)AS avg_session_mins,
    AVG(f.satisfaction_score * 1.0)    AS avg_satisfaction,
    COALESCE(SUM(s.amount_paid), 0)    AS total_revenue_aed,
    COALESCE(SUM(s.amount_paid),0)
        / NULLIF(COUNT(DISTINCT f.user_key),0) AS arpu_aed,
    DENSE_RANK() OVER (ORDER BY COUNT(f.usage_key) DESC) AS adoption_rank
FROM gold.fact_ai_usage f
JOIN gold.dim_users u          ON f.user_key = u.user_key
LEFT JOIN gold.fact_subscriptions s ON f.user_key = s.user_key
GROUP BY u.city
ORDER BY total_sessions DESC;

