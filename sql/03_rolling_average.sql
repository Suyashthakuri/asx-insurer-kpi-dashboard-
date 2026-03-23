-- ============================================================
-- Query 3: Rolling 4-Quarter Average (Trend Smoothing)
-- Skills demonstrated: AVG() OVER with ROWS BETWEEN frame,
--                      window function frame specification,
--                      trend vs. smoothed value comparison
-- Used in: Power BI Page 3 (KPI Trends — smoothed line chart)
-- ============================================================

SELECT
    c.company_name,
    c.asx_ticker,
    p.period_label,
    p.year,
    p.quarter,
    m.metric_name,

    f.actual_value,

    -- Rolling 4-quarter average (current + 3 prior quarters)
    ROUND(
        AVG(f.actual_value) OVER (
            PARTITION BY c.company_id, m.metric_id
            ORDER BY p.year, p.quarter
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        ),
        1
    ) AS rolling_4q_avg,

    -- Deviation from rolling average (shows if current period is an outlier)
    ROUND(
        f.actual_value -
        AVG(f.actual_value) OVER (
            PARTITION BY c.company_id, m.metric_id
            ORDER BY p.year, p.quarter
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        ),
        1
    ) AS vs_rolling_avg,

    -- Count of periods in the window (useful for early periods < 4 quarters)
    COUNT(f.actual_value) OVER (
        PARTITION BY c.company_id, m.metric_id
        ORDER BY p.year, p.quarter
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ) AS periods_in_window

FROM fact_financials f
JOIN dim_company c ON f.company_id = c.company_id
JOIN dim_period  p ON f.period_id  = p.period_id
JOIN dim_metric  m ON f.metric_id  = m.metric_id

-- Focus on the two most important KPIs for this view
WHERE m.metric_name IN (
    'Combined Operating Ratio',
    'Gross Written Premium',
    'Insurance Profit'
)

ORDER BY c.company_name, m.metric_name, p.year, p.quarter;
