# ASX General Insurer KPI Dashboard
### BI requirements, data model, and Power BI dashboard — QBE · IAG · Suncorp

---

## The Business Problem

Investment research analysts monitoring ASX-listed general insurers needed to replace a manual quarterly reporting process that consumed **3–4 hours per analyst per cycle** and produced inconsistent KPI calculations across reports.

**Solution:** A Power BI dashboard with a star schema data model, standardised KPI definitions, DAX measures, and 4-page drill-through report — reducing quarterly preparation time to under 30 minutes.

---

## Dashboard Overview

**4 pages covering the full analyst workflow:**

| Page | Purpose | Primary Audience |
|---|---|---|
| Executive Summary | Sector overview — COR trend, GWP growth, KPI scorecard | Investment Committee |
| Variance Analysis | QoQ and YoY variance — waterfall, driver breakdown | Research Analysts |
| KPI Trends | 8-quarter trend for all 9 KPIs with benchmark lines | Research Analysts |
| Company Deep-Dive | Single-company focus — accessed via drill-through | All users |

---

## Key KPIs Tracked

| KPI | Definition | Target |
|---|---|---|
| Combined Operating Ratio (COR) | Claims ratio + Expense ratio | Below 95% = excellent |
| Gross Written Premium (GWP) | Total premium income written | YoY growth positive |
| Claims Ratio | Net claims / Net earned premium | Below 65% |
| Expense Ratio | Total expenses / Net earned premium | Below 30% |
| Investment Return | Investment income / Avg invested assets | Above 3.5% |
| Return on Equity | NPAT / Avg shareholders equity | Above 12% |

---

## Repository Contents

### BI Specification Document (`ASX_Insurer_KPI_Dashboard_Specification.docx`)
6-section requirements and design document:
1. Business context — problem statement, objectives, stakeholders
2. KPI definitions — precise formulas, business rules, edge cases
3. Data model — star schema design, relationships, data sources
4. Dashboard layout — page-by-page visual specifications
5. DAX measures — all 9 calculated measures with full expressions
6. Testing — validation checks and user acceptance criteria

### SQL Queries (`analysis_queries.sql`)
5 analytical queries powering the dashboard:
- COR trend and variance analysis
- GWP growth with market share dynamics
- Claims ratio decomposition
- Peer comparison ranking
- Conditional formatting threshold evaluation

### Data Model (`data_model_schema.md`)
Complete star schema documentation including table structure, column definitions, and relationship diagram.

---

## Data Model — Star Schema

```
dim_company (3 rows)          dim_period (8 rows)
     │                              │
     └──────── fact_financials ─────┘
               (192 rows)
                    │
               dim_kpi (9 rows)
```

**Relationships:** All dimension tables connect to fact table via Many-to-One relationships. Single-direction filter propagation from dimensions to fact.

---

## DAX Measures (Key Examples)

```dax
-- Combined Operating Ratio
[COR — Current Quarter] =
DIVIDE([Claims Ratio] + [Expense Ratio], 1, 0)

-- YoY GWP Growth
[GWP Growth YoY %] =
VAR CurrentGWP = SUM(fact_financials[gwp])
VAR PriorYearGWP = CALCULATE(
    SUM(fact_financials[gwp]),
    SAMEPERIODLASTYEAR(dim_period[calendar_quarter])
)
RETURN DIVIDE(CurrentGWP - PriorYearGWP, PriorYearGWP, 0) * 100

-- RAG Status
[COR RAG Status] =
SWITCH(TRUE(),
    [COR — Current Quarter] < 95,  "Green",
    [COR — Current Quarter] < 100, "Amber",
    "Red"
)
```

---

## Skills Demonstrated

| Category | Skills |
|---|---|
| Power BI | Star schema design, DAX measures, drill-through, conditional formatting, slicers |
| SQL | COR analysis, variance queries, peer ranking, window functions |
| BI Analysis | Requirements gathering, KPI definition, stakeholder mapping |
| Business Writing | Specification documentation, acceptance criteria, data dictionary |
| Domain Knowledge | General insurance — COR, GWP, claims ratio, combined ratio |

---

*Part of a broader analytics portfolio — see also:*
- *[Brokerage Client Revenue & Churn Analysis](https://github.com/Suyashthakuri/brokerage-client-analytics)*
- *[FP&A Budget vs Actual Report](https://github.com/Suyashthakuri/fpa-budget-variance-fy2024)*
- *[Revenue & Margin Analysis](https://github.com/Suyashthakuri/revenue-margin-analysis-fy2024)*
