USE UAE-UAE_AI_Analytics;

-- Avg Session Duration by Tool (ranked)
SELECT
    t.tool_name,
    t.category,
    COUNT(f.usage_key)                    AS total_sessions,
    AVG(f.session_duration_minutes * 1.0) AS avg_duration_mins,
    AVG(f.prompts_per_session * 1.0)      AS avg_prompts,
    AVG(f.satisfaction_score * 1.0)       AS avg_satisfaction,
    AVG(f.tokens_used * 1.0)              AS avg_tokens,
    DENSE_RANK() OVER (ORDER BY COUNT(f.usage_key) DESC) AS popularity_rank
FROM gold.fact_ai_usage f
JOIN gold.dim_ai_tools t ON f.tool_key = t.tool_key
GROUP BY t.tool_name, t.category
ORDER BY total_sessions DESC;

-- Power User identification
WITH user_month AS (
    SELECT
        f.user_key,
        d.year, d.month_num,
        COUNT(f.usage_key)                    AS session_count,
        AVG(f.prompts_per_session * 1.0)      AS avg_prompts
    FROM gold.fact_ai_usage f
    JOIN gold.dim_date d ON f.date_key = d.date_key
    GROUP BY f.user_key, d.year, d.month_num
)
SELECT
    year, month_num,
    COUNT(*) AS total_active_users,
    SUM(CASE WHEN session_count > 5 AND avg_prompts > 10 THEN 1 ELSE 0 END) AS power_users,
    SUM(CASE WHEN session_count > 5 AND avg_prompts > 10 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*) AS power_user_pct
FROM user_month
GROUP BY year, month_num
ORDER BY year, month_num;
