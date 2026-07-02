USE UAE_AI_Analytics;

-- Revenue grouped by plan_type (pulled in from dim_users via user_key)
SELECT
    COALESCE(u.plan_type,'Unknown') as plan_type,
    SUM(s.amount_paid) AS total_revenue,
    COUNT(DISTINCT s.user_key) AS paying_users
FROM gold.fact_subscriptions s
JOIN gold.dim_users u ON s.user_key = u.user_key
WHERE s.status IN ('ACTIVE', 'CANCELLED')
GROUP BY u.plan_type
ORDER BY total_revenue DESC;