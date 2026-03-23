-- ============================================================
-- Query 2: Year-on-Year Growth Using Window Functions
-- Skills demonstrated: CTEs (WITH clause), LAG() window function,
--                      PARTITION BY, year-on-year calculation
-- Used in: Power BI Page 3 (KPI Trends)
-- ============================================================

WITH base AS (
    SELECT
        c.company_name,
        c.asx_ticker,
        p.year,
        p.quarter,
        p.period_label,
        m.metric_name,
        m.metric_category,
        m.unit,
        m.higher_is_better,
        f.actual_value,

        -- LAG gets the value from the previous row in the partition
        -- Partitioned by company + metric, ordered by time
        LAG(f.actual_value) OVER (
            PARTITION BY c.company_id, m.metric_id
            ORDER BY p.year, p.quarter
        ) AS prior_period_value

    FROM fact_financials f
    JOIN dim_company c ON f.company_id = c.company_id
    JOIN dim_period  p ON f.period_id  = p.period_id
    JOIN dim_metric  m ON f.metric_id  = m.metric_id
)
SELECT
    company_name,
    asx_ticker,
    period_label,
    year,
    quarter,
    metric_name,
    metric_category,
    unit,
    higher_is_better,
    actual_value,
    prior_period_value,

    -- YoY growth percentage
    ROUND(
        (actual_value - prior_period_value)
        / prior_period_value * 100,
        1
    ) AS yoy_growth_pct,

    -- Direction label for visuals
    CASE
        WHEN actual_value > prior_period_value
             AND higher_is_better = 1  THEN 'Improved'
        WHEN actual_value < prior_period_value
             AND higher_is_better = 0  THEN 'Improved'
        WHEN actual_value = prior_period_value THEN 'Flat'
        ELSE                                        'Declined'
    END AS performance_direction

FROM base
WHERE prior_period_value IS NOT NULL

ORDER BY company_name, metric_name, year, quarter;
