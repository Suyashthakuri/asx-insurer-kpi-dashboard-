# ASX General Insurer KPI Dashboard
### End-to-end management reporting dashboard built with SQL, Power BI, and DAX

---

## What this project demonstrates

This dashboard replicates the core reporting workflow of a financial services analyst role in Sydney — extracting and transforming data using SQL, modelling a star schema in Power BI, writing DAX measures for KPI tracking and variance analysis, and designing an executive-ready management report.

**Skills demonstrated:**
- Star schema data modelling (fact table + 3 dimension tables)
- SQL: multi-table JOINs, CTEs, window functions (LAG, RANK, ROW_NUMBER, AVG OVER)
- DAX: variance measures, rolling averages, KPI status logic, conditional formatting
- Power BI: drill-through pages, bookmarks, slicers, conditional formatting
- Financial services domain knowledge: insurance KPIs (COR, GWP, Loss Ratio)

---

## Business problem this solves

Finance teams at general insurers need a single view of Gross Written Premium, Combined Operating Ratio, and Insurance Profit vs. budget — across multiple entities and reporting periods.

This dashboard replaces manual Excel consolidation with an automated, drill-through management report designed for non-technical stakeholders (e.g. CFO, Board).

---

## Companies covered

| Company | ASX Ticker | Sector |
|---|---|---|
| QBE Insurance Group | QBE | General Insurance |
| Insurance Australia Group | IAG | General Insurance |
| Suncorp Group | SUN | General Insurance |

**Data: 8 quarters (Q1 2023 – Q4 2024) × 3 companies × 8 metrics = 192 data points**

---

## Metrics tracked

| Metric | Category | Direction |
|---|---|---|
| Gross Written Premium | Revenue | Higher is better |
| Insurance Profit | Profitability | Higher is better |
| Combined Operating Ratio | Efficiency | Lower is better |
| Net Earned Premium | Revenue | Higher is better |
| Net Claims Expense | Claims | Lower is better |
| Investment Income | Revenue | Higher is better |
| Expense Ratio | Efficiency | Lower is better |
| Loss Ratio | Claims | Lower is better |

> **COR note:** Combined Operating Ratio = Loss Ratio + Expense Ratio. COR < 100% means the insurer is profitable on underwriting alone. This is the single most important metric for any general insurer.

---

## Data model — star schema

```
        dim_company
             |
             | (many-to-one)
             |
fact_financials ——— dim_period
             |
             | (many-to-one)
             |
        dim_metric
```

**Why star schema?** Star schemas enable faster DAX calculations because Power BI can push filter context through single-direction relationships. Flat tables require more complex DAX and perform worse. This is the standard approach in enterprise BI environments.

---

## SQL queries

| File | What it does | SQL skills |
|---|---|---|
| 01_revenue_variance.sql | Revenue vs. budget with traffic-light status | JOINs, CASE WHEN, calculated columns |
| 02_yoy_growth.sql | Year-on-year growth calculation | CTE, LAG() window function |
| 03_rolling_average.sql | Rolling 4-quarter trend smoothing | AVG() OVER with ROWS BETWEEN frame |
| 04_company_ranking.sql | Performance ranking across companies | RANK(), conditional ordering |
| 05_executive_snapshot.sql | Latest quarter summary per company | CTE + ROW_NUMBER() latest-record pattern |

**Key technical decision:** Window functions (LAG, ROW_NUMBER, AVG OVER) were used in SQL rather than DAX for pre-aggregation, reducing Power BI model complexity and improving dashboard performance.

---

## DAX measures

| Measure | Purpose |
|---|---|
| Total Actual | Base aggregation |
| Total Budget | Base aggregation |
| Variance $ | Absolute variance vs. budget |
| Variance % | Percentage variance vs. budget |
| Variance % Label | Formatted label with +/- sign |
| YoY Growth % | Year-on-year growth |
| YoY Growth Label | Formatted label with ▲/▼ arrow |
| Rolling 4Q Avg | 4-quarter rolling average |
| KPI Status | Traffic-light text label |
| KPI Colour | Hex colour for conditional formatting |
| COR Value | Combined Operating Ratio specific |
| COR Status | COR performance band |

---

## Dashboard pages

**Page 1 — Executive Summary**
4 KPI cards (GWP, Insurance Profit, COR, Investment Income) with vs-budget variance and YoY growth. Conditional formatting: green = above target, amber = within 5%, red = below target. Company and period slicers. Written commentary block.

**Page 2 — Revenue & Variance Detail**
Clustered bar chart: actual vs. budget by quarter. Variance waterfall chart. Conditional formatting table showing variance % per company per period. Drill-through to company deep-dive.

**Page 3 — KPI Trends**
Rolling 4Q average line chart for GWP and COR. YoY growth % cards. Scatter plot: COR (x-axis) vs. Insurance Profit (y-axis) — shows the relationship between underwriting efficiency and profitability, a key insight for insurance analysts.

**Page 4 — Company Deep-Dive** (drill-through)
All 8 metrics for selected company. Actual, budget, variance %, prior year, YoY change. Sparkline trends. Bookmark toggle: Latest Quarter vs. Full Year view.

---

## Repository structure

```
asx-insurer-kpi-dashboard/
├── README.md
├── data/
│   └── asx_insurer_dataset.xlsx      # Star schema dataset (4 tables)
├── sql/
│   ├── 01_revenue_variance.sql
│   ├── 02_yoy_growth.sql
│   ├── 03_rolling_average.sql
│   ├── 04_company_ranking.sql
│   ├── 05_executive_snapshot.sql
│   └── DAX_measures.txt              # All Power BI DAX measures
├── powerbi/
│   └── ASX_Insurer_KPI_Dashboard.pbix
└── screenshots/
    ├── 01_executive_summary.png
    ├── 02_variance_detail.png
    ├── 03_kpi_trends.png
    └── 04_company_deepdive.png
```

---

## Tools used

- **Microsoft Excel** — dataset creation and formatting
- **SQLite + DB Browser for SQLite** — SQL query development and testing
- **Power BI Desktop** — data modelling, DAX, dashboard design
- **DAX** — KPI measures, variance calculations, conditional formatting

---

## How to run

1. Clone this repo
2. Open `data/asx_insurer_dataset.xlsx` to review the source data
3. Open DB Browser for SQLite, import the 4 sheets as tables, run any `.sql` file
4. Open `powerbi/ASX_Insurer_KPI_Dashboard.pbix` in Power BI Desktop
5. If data refresh fails, re-point the data source to your local `asx_insurer_dataset.xlsx`

---

*Built as part of a reporting analytics portfolio targeting financial services analyst roles in Sydney, Australia.*
