-- ============================================================
-- Query 4: Company Performance Ranking Per Period
-- Skills demonstrated: RANK() window function, conditional
--                      ordering (higher_is_better logic),
--                      cross-company benchmarking
-- Used in: Power BI Page 3 (KPI Trends — company comparison)
-- ============================================================

SELECT
    p.period_label,
    p.year,
    p.quarter,
    c.company_name,
    c.asx_ticker,
    m.metric_name,
    m.metric_category,
    m.higher_is_better,
    f.actual_value,

    -- Rank companies within each period and metric
    -- Accounts for whether higher or lower is better
    RANK() OVER (
        PARTITION BY p.period_id, m.metric_id
        ORDER BY
            CASE
                WHEN m.higher_is_better = 1
                THEN  f.actual_value      -- rank high values first
                ELSE -f.actual_value      -- rank low values first (ratios)
            END DESC
    ) AS performance_rank,

    -- Percentile within each period/metric group
    ROUND(
        100.0 * (
            RANK() OVER (
                PARTITION BY p.period_id, m.metric_id
                ORDER BY
                    CASE WHEN m.higher_is_better = 1
                         THEN  f.actual_value
                         ELSE -f.actual_value
                    END DESC
            ) - 1
        ) / (COUNT(*) OVER (PARTITION BY p.period_id, m.metric_id) - 1),
        0
    ) AS percentile_rank

FROM fact_financials f
JOIN dim_company c ON f.company_id = c.company_id
JOIN dim_period  p ON f.period_id  = p.period_id
JOIN dim_metric  m ON f.metric_id  = m.metric_id

ORDER BY p.year, p.quarter, m.metric_name, performance_rank;
