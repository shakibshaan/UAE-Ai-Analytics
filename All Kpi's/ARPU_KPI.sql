USE UAE_AI_Analytics;

-- Average Revenue Per User: MRR spread across however many distinct users paid that month
SELECT
    d.year,
    d.month_num,
    d.month_name,
    SUM(s.amount_paid) * 1.0 / COUNT(DISTINCT s.user_key) AS arpu
FROM gold.fact_subscriptions s
JOIN gold.dim_date d ON s.date_key = d.date_key
WHERE s.status IN ('ACTIVE', 'CANCELLED')
GROUP BY d.year, d.month_num, d.month_name
ORDER BY d.year, d.month_num;


-- Average Revenue Per User: YRR spread across however many distinct users paid that month
SELECT
    d.year,
    SUM(s.amount_paid) * 1.0 / COUNT(DISTINCT s.user_key) AS arpu
FROM gold.fact_subscriptions s
JOIN gold.dim_date d ON s.date_key = d.date_key
WHERE s.status IN ('ACTIVE', 'CANCELLED')
GROUP BY d.year
ORDER BY d.year;

