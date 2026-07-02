USE UAE_AI_Analytics;

-- Monthly Recurring Revenue: total amount paid by ACTIVE/CANCELLED subs, grouped by start month
SELECT
    d.year,
    d.month_num,
    d.month_name,
    SUM(s.amount_paid) AS mrr
FROM gold.fact_subscriptions s
JOIN gold.dim_date d ON s.date_key = d.date_key
WHERE s.status IN ('ACTIVE', 'CANCELLED')
GROUP BY d.year, d.month_num, d.month_name
ORDER BY d.year, d.month_num;

-- Monthly Recurring Revenue: total amount paid by ACTIVE/CANCELLED subs, grouped by start month
SELECT
    d.year,
    SUM(s.amount_paid) AS yrr
FROM gold.fact_subscriptions s
JOIN gold.dim_date d ON s.date_key = d.date_key
WHERE s.status IN ('ACTIVE', 'CANCELLED')
GROUP BY d.year
ORDER BY d.year;


