USE UAE_AI_Analytics;


-- Tool ranking with NPS proxy from fact_feedback
WITH tool_sessions AS (
    SELECT
        f.tool_key,
        COUNT(f.usage_key)               AS session_count,
        AVG(f.satisfaction_score * 1.0)  AS avg_satisfaction,
        DENSE_RANK() OVER (ORDER BY COUNT(f.usage_key) DESC) AS session_rank
    FROM gold.fact_ai_usage f
    GROUP BY f.tool_key
),
tool_feedback AS (
    SELECT
        fb.tool_key,
        COUNT(*) AS feedback_count,
        AVG(fb.rating * 1.0) AS avg_rating,
        SUM(CASE WHEN fb.rating >= 4 THEN 1.0 ELSE 0 END) * 100 / COUNT(*)
            - SUM(CASE WHEN fb.rating <= 2 THEN 1.0 ELSE 0 END) * 100 / COUNT(*)
            AS nps_proxy,
        SUM(CASE WHEN fb.would_recommend = 'YES' THEN 1 ELSE 0 END) * 100.0
            / COUNT(*)  AS recommend_rate_pct
    FROM gold.fact_feedback fb
    GROUP BY fb.tool_key
)
SELECT
    t.tool_name,
    t.category,
    ts.session_count,
    ts.session_rank,
    ts.avg_satisfaction,
    tf.avg_rating,
    tf.nps_proxy,
    tf.recommend_rate_pct,
    tf.feedback_count
FROM tool_sessions ts
JOIN gold.dim_ai_tools t  ON ts.tool_key = t.tool_key
LEFT JOIN tool_feedback tf ON ts.tool_key = tf.tool_key
ORDER BY ts.session_count DESC;
