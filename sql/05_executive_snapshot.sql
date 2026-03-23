-- ============================================================
-- Query 5: Executive Snapshot — Latest Quarter Per Company
-- Skills demonstrated: CTE + ROW_NUMBER() for latest-record
--                      pattern (most common real-world SQL
--                      pattern in reporting analyst roles),
--                      multi-metric summary in one query
-- Used in: Power BI Page 1 (Executive Summary KPI cards)
-- ============================================================

WITH ranked AS (
    SELECT
        f.company_id,
        f.metric_id,
        f.actual_value,
        f.budget_value,
        f.prior_year_value,
        p.period_label,
        p.year,
        p.quarter,

        -- Number each row within company+metric, latest period = 1
        ROW_NUMBER() OVER (
            PARTITION BY f.company_id, f.metric_id
            ORDER BY p.year DESC, p.quarter DESC
        ) AS rn

    FROM fact_financials f
    JOIN dim_period p ON f.period_id = p.period_id
)
SELECT
    c.company_name,
    c.asx_ticker,
    c.market_cap_bn_aud,
    r.period_label          AS latest_period,
    m.metric_name,
    m.metric_category,
    m.unit,
    m.higher_is_better,

    r.actual_value,
    r.budget_value,
    r.prior_year_value,

    -- vs Budget
    ROUND(r.actual_value - r.budget_value, 1)
        AS vs_budget_abs,
    ROUND(
        (r.actual_value - r.budget_value)
        / r.budget_value * 100, 1
    ) AS vs_budget_pct,

    -- vs Prior Year
    ROUND(r.actual_value - r.prior_year_value, 1)
        AS vs_prior_year_abs,
    ROUND(
        (r.actual_value - r.prior_year_value)
        / r.prior_year_value * 100, 1
    ) AS vs_prior_year_pct,

    -- Executive status label
    CASE
        WHEN (r.actual_value - r.budget_value)
             / r.budget_value >=  0.05 THEN 'Above target'
        WHEN (r.actual_value - r.budget_value)
             / r.budget_value >=  0    THEN 'On target'
        WHEN (r.actual_value - r.budget_value)
             / r.budget_value >= -0.05 THEN 'Within 5%'
        ELSE                               'Below target'
    END AS kpi_status

FROM ranked r
JOIN dim_company c ON r.company_id = c.company_id
JOIN dim_metric  m ON r.metric_id  = m.metric_id

WHERE r.rn = 1   -- latest quarter only

ORDER BY m.metric_category, c.company_name;
