USE UAE_AI_Analytics;

WITH daily AS (
    SELECT d.year, d.month_num, d.full_date,
           COUNT(DISTINCT f.user_key) AS dau
    FROM gold.fact_ai_usage f
    JOIN gold.dim_date d ON f.date_key = d.date_key
    GROUP BY d.year, d.month_num, d.full_date
),
monthly AS (
    SELECT d.year, d.month_num,
           COUNT(DISTINCT f.user_key) AS mau
    FROM gold.fact_ai_usage f
    JOIN gold.dim_date d ON f.date_key = d.date_key
    GROUP BY d.year, d.month_num
)
SELECT
    m.year, m.month_num, m.mau,
    AVG(d.dau * 1.0) AS avg_dau,
    AVG(d.dau * 1.0) / m.mau * 100 AS dau_mau_ratio_pct
FROM monthly m
JOIN daily d ON m.year = d.year AND m.month_num = d.month_num
GROUP BY m.year, m.month_num, m.mau
ORDER BY m.year, m.month_num;