USE UAE_AI_Analytics;

-- Monthly Active Users: how many distinct users touched the platform each month
SELECT
    d.year as year,
    d.month_num,
    d.month_name,
    COUNT(DISTINCT f.user_key) AS mau
FROM gold.fact_ai_usage f
JOIN gold.dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month_num, d.month_name
ORDER BY d.year, d.month_num


-- yearly active users

SELECT
    d.year AS year,
    COUNT(DISTINCT f.user_key) AS yearly_active_users
FROM gold.fact_ai_usage f
JOIN gold.dim_date d ON f.date_key = d.date_key
GROUP BY d.year
ORDER BY d.year;