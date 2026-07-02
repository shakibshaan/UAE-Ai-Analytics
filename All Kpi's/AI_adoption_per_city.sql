
--  AI Adoption by Emirate

SELECT
    COALESCE(u.city, 'Ras Al Khaimah')        AS city,
    COUNT(DISTINCT f.user_key) AS unique_users,
    COUNT(f.usage_key) AS total_sessions,
    AVG(f.satisfaction_score * 1.0) AS avg_satisfaction,
    DENSE_RANK() OVER (ORDER BY COUNT(f.usage_key) DESC) AS adoption_rank
FROM gold.fact_ai_usage f
JOIN gold.dim_users u ON f.user_key = u.user_key
GROUP BY u.city
ORDER BY total_sessions DESC;