USE UAE_AI_Analytics;

-- Session gap analysis using LAG() -- churn signal detection
WITH session_gaps AS (
    SELECT
        f.user_key,
        d.full_date                  AS session_date,
        LAG(d.full_date) OVER (
            PARTITION BY f.user_key
            ORDER BY d.full_date
        )                            AS prev_session_date,
        DATEDIFF(day,
            LAG(d.full_date) OVER (PARTITION BY f.user_key ORDER BY d.full_date),
            d.full_date
        )                            AS days_since_last_session
    FROM gold.fact_ai_usage f
    JOIN gold.dim_date d ON f.date_key = d.date_key
)
SELECT
    sg.user_key,
    COALESCE(u.city, 'Ras Al Khaimah') AS city,
    u.plan_type,
    u.age_group,
    MAX(sg.days_since_last_session)  AS max_gap_days,
    AVG(sg.days_since_last_session * 1.0) AS avg_gap_days,
    CASE
        WHEN MAX(sg.days_since_last_session) > 30 THEN 'High Risk'
        WHEN MAX(sg.days_since_last_session) > 14 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS churn_risk_segment
FROM session_gaps sg
JOIN gold.dim_users u ON sg.user_key = u.user_key
WHERE sg.days_since_last_session IS NOT NULL
GROUP BY sg.user_key, u.city, u.plan_type, u.age_group
ORDER BY max_gap_days DESC;
