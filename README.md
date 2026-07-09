<div align="center">

# UAE AI Market Analytics Data Warehouse

### End-to-End SQL Server Data Warehouse | Medallion Architecture | Star Schema | Executive KPIs

![SQL Server](https://img.shields.io/badge/Database-SQL%20Server-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white)
![T-SQL](https://img.shields.io/badge/Language-T--SQL-4479A1?style=flat-square)
![ETL](https://img.shields.io/badge/Pipeline-ETL-2E8B57?style=flat-square)
![Star Schema](https://img.shields.io/badge/Model-Star%20Schema-F4A300?style=flat-square)
![Medallion Architecture](https://img.shields.io/badge/Architecture-Medallion-8A2BE2?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-lightgrey?style=flat-square)

</div>

A synthetic-but-realistic Data Warehouse project simulating AI tool adoption across the UAE, built on Microsoft SQL Server using a Bronze → Silver → Gold Medallion Architecture. Raw, intentionally messy CSV extracts are ingested, cleaned, and modeled into a Star Schema, then queried with T-SQL window functions and stored procedures to produce twelve executive-level KPIs — active users, revenue, retention, satisfaction, and adoption metrics — with no BI tool in the loop.

<div align="center">
<sub>Architecture diagram placeholder — see <code>docs/images/architecture.png</code></sub>
</div>

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Medallion Architecture](#medallion-architecture)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
- [ETL Pipeline](#etl-pipeline)
- [Star Schema](#star-schema)
- [SQL Techniques](#sql-techniques)
- [KPIs](#kpis)
- [Business Insights](#business-insights)
- [Screenshots](#screenshots)
- [Engineering Decisions](#engineering-decisions)
- [Lessons Learned](#lessons-learned)
- [Future Improvements](#future-improvements)
- [Installation](#installation)
- [How to Run](#how-to-run)
- [License](#license)

---

## Overview

This project is a warehouse-only Data Engineering build: there is no dashboard or visualization layer by design. The goal was to demonstrate the engineering skills that sit underneath any BI tool — schema design, ETL orchestration, data cleaning at scale, and KPI logic written directly in SQL — rather than to produce another Power BI portfolio piece.

**What was built.** Five synthetic CSV sources (users, AI tools, usage logs, subscriptions, feedback) are loaded through three progressively refined layers and exposed as a dimensional model with twelve KPIs computed entirely in T-SQL.

**Who it's for.** Recruiters and hiring managers evaluating data engineering fundamentals, and engineers who want to see how a warehouse is reasoned about end to end — including the decisions that got reversed along the way.

**Why Medallion Architecture.** Separating raw ingestion (Bronze), cleaning and conformance (Silver), and business-ready modeling (Gold) keeps each stage auditable and independently re-runnable, which mirrors how production warehouses are actually structured.

**Why SQL Server.** SSMS and T-SQL are the most common enterprise stack for on-prem and hybrid data warehousing, and the project intentionally leans on native T-SQL features — window functions, CTEs, stored procedures — instead of delegating logic to an external tool.

**Why Star Schema.** A conformed dimensional model (three fact tables around shared `dim_users`, `dim_ai_tools`, and `dim_date` dimensions) keeps grain explicit and makes every KPI traceable to a specific join path, which matters as much for interviews as it does for production maintainability.

**Why synthetic data.** Using generated data removes any licensing or privacy concern while still requiring realistic messiness — duplicates, nulls, inconsistent casing, orphaned foreign keys — so the cleaning logic in Silver has real problems to solve rather than trivial ones.

---

## Architecture

```mermaid
flowchart LR
    A[CSV Sources] --> B[Bronze Layer]
    B --> C[Silver Layer]
    C --> D[Gold Layer]
    D --> E[Business KPIs]

    style A fill:#3a3a3a,stroke:#888,color:#fff
    style B fill:#7a4a1e,stroke:#c97b2e,color:#fff
    style C fill:#4a4a4a,stroke:#999,color:#fff
    style D fill:#7a6a1e,stroke:#c9a92e,color:#fff
    style E fill:#1e5a4a,stroke:#2ec9a9,color:#fff
```

| Layer | Role |
|---|---|
| **CSV Sources** | Five raw extracts: `users.csv`, `ai_tools.csv`, `usage_logs.csv`, `subscriptions.csv`, `feedback.csv` |
| **Bronze** | Raw ingestion with source fidelity preserved — no transformations |
| **Silver** | Cleaning, standardization, and business-rule validation via `silver.load_silver` |
| **Gold** | Star schema (3 fact + 3 dimension tables) via `gold.load_gold` |
| **Business KPIs** | Twelve KPIs computed directly against Gold with T-SQL window functions and CTEs |

---

## Medallion Architecture

<details>
<summary><strong>Bronze Layer</strong></summary>

**Purpose.** Land raw data exactly as received, preserving full source fidelity for traceability and reprocessing.

**Responsibilities**
- Bulk import of all five CSV sources
- Raw landing tables with source-matching column types
- No cleaning, joins, or business logic

**Engineering Tasks**
- Bulk CSV import routines
- Landing table DDL per source
- Row-count validation against source files

**Output.** Five raw, unmodified landing tables — the audit trail for everything downstream.

</details>

<details>
<summary><strong>Silver Layer</strong></summary>

**Purpose.** Convert raw, messy Bronze data into clean, conformed tables ready for dimensional modeling.

**Responsibilities**
- Deduplication
- Null handling and default substitution
- Data type conversion
- String standardization (casing, trimming, category normalization)
- Business rule validation
- Referential integrity checks against related tables

**Cleaning Steps**
- Duplicate removal on natural keys
- Standardizing city, plan, and category text values
- Casting inconsistent date/numeric strings to proper types
- Flagging and resolving orphaned foreign keys

**Transformations, Validation & Tooling.** All logic lives in a single `silver.load_silver` stored procedure, using CTEs for staged cleaning steps and window functions (`ROW_NUMBER()`) for deduplication.

**Output.** Five clean, conformed Silver tables — one per source, structurally close to Bronze but business-rule valid.

</details>

<details>
<summary><strong>Gold Layer</strong></summary>

**Purpose.** Present business-ready analytics through a dimensional model that downstream KPI queries and (in principle) BI tools can consume directly.

**Star Schema**
- **Fact Tables:** `fact_ai_usage`, `fact_subscriptions`, `fact_feedback`
- **Dimension Tables:** `dim_users`, `dim_ai_tools`, `dim_date`

**Business Layer.** A `gold.load_gold` stored procedure populates all six tables from Silver, assigning surrogate keys and enforcing grain per fact table.

**KPIs & Reporting.** Twelve KPIs are computed directly against Gold — no reporting layer or semantic model sits between the warehouse and the numbers.

</details>

---

## Technology Stack

| Category | Technology |
|---|---|
| Database | Microsoft SQL Server |
| Language | T-SQL |
| Architecture | Medallion (Bronze / Silver / Gold) |
| Modeling | Star Schema (Kimball-style dimensional model) |
| ETL | Stored procedures (`silver.load_silver`, `gold.load_gold`) |
| Development Environment | SQL Server Management Studio (SSMS) |
| Version Control | Git / GitHub |
| Documentation | Markdown, Mermaid |

---

## Project Structure

```
uae-ai-market-analytics-dw/
│
├── bronze/
│   └── ddl_bronze.sql              # Raw landing table definitions
│
├── silver/
│   └── proc_load_silver.sql        # silver.load_silver stored procedure
│
├── gold/
│   └── proc_load_gold.sql          # gold.load_gold stored procedure + view/table DDL
│
├── kpi_scripts/
│   ├── MAU_YAU_KPI.sql
│   ├── MMR_kpi.sql
│   ├── ARPU_KPI.sql
│   ├── DAU_MAU_Stickiness_Ratio.sql
│   ├── AVG_Satisfaction.sql
│   ├── AI_adoption_per_city.sql
│   ├── REVENUE_BY_PLAN_TYPE.sql
│   ├── GenAI_vs_Productivity_Tool_Split.sql
│   └── monthly_churn_rate.sql
│
├── datasets/
│   ├── users.csv
│   ├── ai_tools.csv
│   ├── usage_logs.csv
│   ├── subscriptions.csv
│   └── feedback.csv
│
├── docs/
│   └── images/                     # Architecture, star schema, and KPI screenshots
│
└── README.md
```

| Folder | Contents |
|---|---|
| `bronze/` | DDL for raw landing tables |
| `silver/` | Cleaning stored procedure |
| `gold/` | Dimensional model DDL and load procedure |
| `kpi_scripts/` | All twelve standalone KPI queries |
| `datasets/` | Synthetic source CSVs |
| `docs/images/` | Diagrams and screenshots referenced in this README |

---

## ETL Pipeline

**Bronze Ingestion.** CSVs are bulk-loaded into landing tables with no transformation, preserving exact source values — including the duplicates, nulls, and inconsistent formatting that Silver is responsible for resolving.

**Silver Cleaning.** `silver.load_silver` handles:
- Duplicate removal via `ROW_NUMBER()` partitioned on natural keys
- Null handling with explicit business defaults (e.g. unresolved cities coalesced rather than dropped)
- Data type conversion (string dates → `DATE`, string amounts → `DECIMAL`)
- String standardization across city, plan, and category fields
- Business rule validation (e.g. rejecting non-positive session durations)
- Referential integrity checks against related Silver tables

**Gold Aggregation.** `gold.load_gold` builds the dimensional model:
- Surrogate keys generated per dimension
- Fact tables populated at defined grain (one row per usage session, per subscription event, per feedback entry)
- Foreign keys resolved against dimension surrogate keys, not natural keys

Throughout both procedures, CTEs stage intermediate logic, window functions handle deduplication and ranking, and `MERGE`/`INSERT` patterns keep the load procedures idempotent for re-runs.

---

## Star Schema

```mermaid
erDiagram
    DIM_USERS ||--o{ FACT_AI_USAGE : has
    DIM_AI_TOOLS ||--o{ FACT_AI_USAGE : used_in
    DIM_DATE ||--o{ FACT_AI_USAGE : occurred_on

    DIM_USERS ||--o{ FACT_SUBSCRIPTIONS : holds
    DIM_DATE ||--o{ FACT_SUBSCRIPTIONS : billed_on

    DIM_USERS ||--o{ FACT_FEEDBACK : submits
    DIM_AI_TOOLS ||--o{ FACT_FEEDBACK : rated
    DIM_DATE ||--o{ FACT_FEEDBACK : submitted_on

    DIM_USERS {
        int user_key PK
        string user_id
        string city
        string plan_type
    }
    DIM_AI_TOOLS {
        int tool_key PK
        string tool_id
        string tool_name
        string category
    }
    DIM_DATE {
        int date_key PK
        date full_date
        int year
        int month_num
        string month_name
    }
    FACT_AI_USAGE {
        int usage_key PK
        int date_key FK
        int user_key FK
        int tool_key FK
        int session_duration
        string prompt_category
        int satisfaction_score
    }
    FACT_SUBSCRIPTIONS {
        int subscription_key PK
        int date_key FK
        int user_key FK
        string status
        decimal amount_paid
    }
    FACT_FEEDBACK {
        int feedback_key PK
        int date_key FK
        int user_key FK
        int tool_key FK
        int satisfaction_score
    }
```

**Fact tables** carry the measures — session duration, revenue, satisfaction score — at their own grain, one row per event.

**Dimension tables** describe the "who, what, when" shared across facts: `dim_users`, `dim_ai_tools`, `dim_date`.

**Surrogate keys** (`*_key` columns) decouple the warehouse from source-system identifiers, which keeps joins cheap and insulates Gold from upstream ID changes.

**Relationships** are enforced as standard star-schema foreign keys — every fact table joins outward to dimensions, never fact-to-fact.

> **Note on `prompt_category`.** An earlier design included a `dim_prompt_category` dimension. It was dropped in favor of a plain `prompt_category` column directly on `fact_ai_usage` — seven or so category values didn't justify a separate dimension, and collapsing it removed a join without losing any analytical capability. See [Engineering Decisions](#engineering-decisions).

---

## SQL Techniques

| Technique | Purpose | Used For |
|---|---|---|
| Stored Procedures | Encapsulate repeatable ETL logic | `silver.load_silver`, `gold.load_gold` |
| CTEs | Stage intermediate transformations | Deduplication, churn calculation, stickiness ratio |
| Window Functions | Rank and deduplicate without collapsing rows | `ROW_NUMBER()`, `DENSE_RANK()`, `AVG() OVER()` |
| `ROW_NUMBER()` | Deduplicate on natural keys | Silver cleaning logic |
| `DENSE_RANK()` | Rank cities by adoption without gaps | Adoption by City KPI |
| Aggregate Functions | Summarize measures | `SUM()`, `AVG()`, `COUNT()` across all KPIs |
| `CASE` | Conditional bucketing | Churn status classification |
| `GROUP BY` | Roll up to reporting grain | Every KPI query |
| `INNER JOIN` | Fact-to-dimension joins where match is required | Revenue, satisfaction, adoption KPIs |
| `LEFT JOIN` / `COALESCE` | Preserve unmatched rows with fallback values | City adoption, plan-type revenue |
| Window Aggregates (`SUM() OVER()`) | Compute percentage-of-total without a self-join | GenAI vs. productivity split |
| Surrogate Keys | Decouple warehouse from source IDs | All Gold dimension tables |

---

## KPIs

Twelve KPIs are computed directly against the Gold layer, grouped into two thematic sets. Every query below is a standalone `.sql` script in `kpi_scripts/`.

### Executive Overview

| KPI | Method | Sample Result |
|---|---|---|
| Monthly / Yearly Active Users | `COUNT(DISTINCT user_key)` grouped by month and year | 2,935+ annual active users |
| Monthly / Annual Recurring Revenue | `SUM(amount_paid)` on `ACTIVE`/`CANCELLED` subscriptions | $38.34K peak annual revenue |
| ARPU | Revenue ÷ distinct paying users, monthly and yearly | Computed per period |
| Revenue by Plan Type | `SUM(amount_paid)` grouped by `plan_type` via `dim_users` | Highest-revenue plan surfaced per period |
| Customer Satisfaction | `AVG(satisfaction_score)` by tool | 2.8 / 5 highest tool average |
| Monthly Churn Rate | Cancelled subscriptions ÷ total subscriptions per period | Tracked month over month |

### Engagement & Retention

| KPI | Method | Sample Result |
|---|---|---|
| DAU / MAU Stickiness | Average daily actives ÷ monthly actives, per month | ~4% stickiness ratio |
| AI Adoption by City | `COUNT(DISTINCT user_key)` and session count, `DENSE_RANK()` by sessions | Dubai leads adoption |
| Top AI Categories | Session count and share of total sessions by prompt category | Text Generation ≈ 20.2% of sessions |
| Top Rated AI Tools | `AVG(satisfaction_score)` ranked by tool | Highest-rated tool per period |
| Session Volume | Total logged sessions per tool/city | Cross-referenced with adoption |
| Cohort Retention | User activity persistence across periods | Derived from usage and subscription facts |

<details>
<summary>View a representative KPI query — Monthly Churn Rate</summary>

```sql
WITH month_status AS (
    SELECT
        s.user_key,
        d_end.year * 100 + d_end.month_num AS end_ym,
        s.status
    FROM gold.fact_subscriptions s
    JOIN gold.dim_date d_end ON s.date_key = d_end.date_key
)
SELECT
    end_ym AS churn_month,
    COUNT(CASE WHEN status = 'CANCELLED' THEN 1 END) AS churned,
    COUNT(*) AS total_at_period_start,
    COUNT(CASE WHEN status = 'CANCELLED' THEN 1 END) * 100.0
        / NULLIF(COUNT(*), 0) AS churn_rate_pct
FROM month_status
GROUP BY end_ym
ORDER BY end_ym;
```

</details>

---

## Business Insights

- Dubai recorded the highest user adoption among tracked cities.
- Text Generation represented the largest usage category, at roughly 20.2% of total sessions.
- The top-rated AI tool reached an average satisfaction score of 2.8 out of 5.
- Annual revenue peaked at approximately $38.34K.
- DAU/MAU stickiness held around 4%, suggesting daily engagement is a small slice of the monthly active base.

---

## Screenshots

| Artifact | Location |
|---|---|
| Architecture Diagram | `docs/images/architecture.png` |
| Star Schema | `docs/images/star_schema.png` |
| SQL Scripts | `docs/images/sql_scripts.png` |
| KPI Outputs | `docs/images/kpi_outputs.png` |

---

## Engineering Decisions

**Designing the Medallion layers.** Deciding what belongs in Silver versus Gold took a few iterations — early versions pushed some business rule validation into Gold before it was moved back to Silver, where it belongs conceptually.

**Dropping `dim_prompt_category`.** The original model had a separate dimension for prompt categories. With only a handful of distinct values, the extra join added complexity without adding analytical value, so it was collapsed into a plain `prompt_category` column on `fact_ai_usage`. Documenting this reversal openly, rather than presenting only the final state, better reflects how the design decision was actually made.

**Building reusable stored procedures.** Both `silver.load_silver` and `gold.load_gold` are written to be safely re-run, which surfaced real debugging work — ambiguous column names after joins, `CASE` statement ordering bugs, and CTE structuring issues that had to be resolved before the procedures were reliable.

**Surrogate key generation.** Assigning surrogate keys in Gold while preserving natural keys for traceability required deciding how far back into Bronze/Silver the natural key needed to be threaded.

**Modeling the Star Schema.** Settling on three fact tables at three distinct grains (usage session, subscription event, feedback entry) rather than one wide fact table kept each table's meaning unambiguous.

---

## Lessons Learned

- **Data Warehousing.** Layered architecture makes debugging tractable — a bad KPI result can be traced back one layer at a time instead of re-auditing the whole pipeline.
- **Dimensional Modeling.** Grain decisions made early in Gold design ripple through every downstream KPI query; getting them right up front avoids rework.
- **ETL Design.** Idempotent stored procedures are worth the extra design time — re-running a load without side effects is what makes iterative development possible.
- **SQL Development.** Window functions replaced several would-be self-joins, simplifying both the readability and performance of key queries.
- **Business Analytics.** Translating a schema into recruiter-relevant KPIs required thinking about the business question first, then the query — not the reverse.
- **Documentation.** Writing up reversed decisions (like the dropped dimension) turned out to be more useful to a reader than only documenting the final state.
- **Version Control.** Structuring commits around layer boundaries (Bronze, Silver, Gold, KPIs) made the project history easier to follow than one large commit per session.

---

## Future Improvements

- Power BI dashboard layer
- Tableau dashboard layer
- Incremental loading (currently full reload per run)
- SSIS-based orchestration
- Azure Data Factory pipeline migration
- Automated data quality monitoring
- Scheduled/automated job execution
- CI/CD for stored procedure deployment
- Containerization with Docker
- Cloud deployment (Azure SQL / Synapse)

---

## Installation

**Requirements**
- Microsoft SQL Server (2019+ recommended)
- SQL Server Management Studio (SSMS)
- The five source CSVs in `datasets/`

**Setup**
1. Restore or create the `UAE_AI_Analytics` database.
2. Run the Bronze DDL scripts to create landing tables.
3. Bulk-import the CSVs into their corresponding Bronze tables.

---

## How to Run

1. Execute `bronze/ddl_bronze.sql` to create raw landing tables.
2. Bulk-load the five CSVs from `datasets/` into Bronze.
3. Run `EXEC silver.load_silver;` to clean and conform the data.
4. Run `EXEC gold.load_gold;` to populate the star schema.
5. Execute any script in `kpi_scripts/` against the `UAE_AI_Analytics` database to generate a KPI.

```sql
USE UAE_AI_Analytics;
EXEC silver.load_silver;
EXEC gold.load_gold;
```

---

## License

This project is licensed under the MIT License.

