-- Cohort retention analysis
WITH first_session AS (
    -- Step 1: Find each user's first session month (cohort assignment)
    SELECT
        f.user_key,
        MIN(d.year * 100 + d.month_num) AS cohort_ym
    FROM gold.fact_ai_usage f
    JOIN gold.dim_date d ON f.date_key = d.date_key
    GROUP BY f.user_key
),
user_activity AS (
    -- Step 2: All months each user was active
    SELECT DISTINCT
        f.user_key,
        d.year * 100 + d.month_num AS activity_ym
    FROM gold.fact_ai_usage f
    JOIN gold.dim_date d ON f.date_key = d.date_key
),
cohort_data AS (
    -- Step 3: Join to calculate months since cohort start
    SELECT
        fs.cohort_ym,
        ua.activity_ym,
        COUNT(DISTINCT ua.user_key)                         AS active_users,
        (ua.activity_ym / 100 * 12 + ua.activity_ym % 100)
        - (fs.cohort_ym / 100 * 12 + fs.cohort_ym % 100)  AS months_since_start
    FROM first_session fs
    JOIN user_activity ua ON fs.user_key = ua.user_key
    GROUP BY fs.cohort_ym, ua.activity_ym,
        (ua.activity_ym/100*12+ua.activity_ym%100)-(fs.cohort_ym/100*12+fs.cohort_ym%100)
),
cohort_sizes AS (
    -- Step 4: Get the cohort size (Month 0 users)
    SELECT cohort_ym, active_users AS cohort_size
    FROM cohort_data
    WHERE months_since_start = 0
)
-- Step 5: Calculate retention percentage
SELECT
    cd.cohort_ym,
    cd.months_since_start,
    cd.active_users,
    cs.cohort_size,
    cd.active_users * 100.0 / cs.cohort_size AS retention_pct
FROM cohort_data cd
JOIN cohort_sizes cs ON cd.cohort_ym = cs.cohort_ym
ORDER BY cd.cohort_ym, cd.months_since_start;
