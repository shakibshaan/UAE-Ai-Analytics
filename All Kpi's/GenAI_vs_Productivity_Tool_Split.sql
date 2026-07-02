USE UAE_AI_Analytics;


SELECT
    t.category_name,
    COUNT(f.usage_key) AS session_count,
    COUNT(f.usage_key) * 100.0 / SUM(COUNT(f.usage_key)) OVER () AS pct_of_total
FROM gold.fact_ai_usage f
JOIN gold.dim_prompt_category t 
    ON f.category_key = t.category_key
WHERE t.category_name IS NOT NULL
GROUP BY t.category_name
ORDER BY session_count DESC;


