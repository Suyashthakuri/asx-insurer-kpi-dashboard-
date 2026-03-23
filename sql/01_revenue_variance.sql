-- ============================================================
-- Query 1: Revenue vs. Budget Variance by Company and Quarter
-- Skills demonstrated: multi-table JOINs, calculated columns,
--                      CASE WHEN logic, variance analysis
-- Used in: Power BI Page 2 (Revenue & Variance Detail)
-- ============================================================

SELECT
    c.company_name,
    c.asx_ticker,
    p.period_label,
    p.year,
    p.quarter,
    m.metric_name,
    m.metric_category,
    m.unit,

    f.actual_value,
    f.budget_value,

    -- Absolute variance (positive = above budget)
    ROUND(f.actual_value - f.budget_value, 1)
        AS variance_abs,

    -- Percentage variance
    ROUND(
        (f.actual_value - f.budget_value)
        / f.budget_value * 100, 2
    ) AS variance_pct,

    -- KPI traffic-light status
    CASE
        WHEN (f.actual_value - f.budget_value)
             / f.budget_value >=  0.05 THEN 'Above target'
        WHEN (f.actual_value - f.budget_value)
             / f.budget_value >=  0    THEN 'On target'
        WHEN (f.actual_value - f.budget_value)
             / f.budget_value >= -0.05 THEN 'Within 5%'
        ELSE                               'Below target'
    END AS kpi_status

FROM fact_financials f
JOIN dim_company  c ON f.company_id = c.company_id
JOIN dim_period   p ON f.period_id  = p.period_id
JOIN dim_metric   m ON f.metric_id  = m.metric_id

WHERE m.metric_category IN ('Revenue', 'Profitability')

ORDER BY c.company_name, p.year, p.quarter, m.metric_name;
