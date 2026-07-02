USE UAE_AI_Analytics;

-- Avg satisfaction score, overall and by tool
SELECT
    t.tool_name,
    AVG(f.satisfaction_score * 1.0) AS avg_satisfaction
FROM gold.fact_ai_usage f
JOIN gold.dim_ai_tools t ON f.tool_key = t.tool_key
WHERE f.satisfaction_score IS NOT NULL
GROUP BY t.tool_name
ORDER BY avg_satisfaction DESC;

SELECT * FROM gold.dim_ai_tools;