# 🇦🇪 UAE AI Usage Analytics — Data Warehouse Portfolio Project

> A complete, end-to-end data engineering project demonstrating core data warehouse competencies using **Microsoft SQL Server**, **Medallion Architecture**, and **Tableau**. Built as a portfolio piece focused on the UAE AI adoption market.

---

## 📌 Project Overview

This project ingests, cleans, and models synthetic-but-realistic AI usage data representing the UAE market — covering users, AI tools, usage logs, subscriptions, and feedback. The goal is to demonstrate production-quality data engineering thinking: handling messy source data, applying layered transformations, making honest design decisions, and surfacing business insights through a dimensional model and dashboards.

---

## 🏗️ Architecture — Medallion Layers

```
Raw CSV Files
     │
     ▼
┌─────────────┐
│   BRONZE    │  Raw ingestion — data loaded as-is from CSV sources
└─────────────┘
     │
     ▼
┌─────────────┐
│   SILVER    │  Cleaned & standardised — nulls handled, strings stripped,
│             │  business rules applied, derived fields added
└─────────────┘
     │
     ▼
┌─────────────┐
│    GOLD     │  Dimensional model — fact and dimension tables ready
│             │  for analytics and Tableau dashboards
└─────────────┘
```

---

## 📂 Source Datasets

Five synthetic CSV datasets intentionally generated with real-world data quality issues:

| Dataset | Description |
|---|---|
| `users.csv` | UAE user demographics and registration data |
| `ai_tools.csv` | AI tool catalogue (names, categories, vendors) |
| `ai_usage_logs.csv` | Individual usage events — the core fact source |
| `subscriptions.csv` | Subscription tier and payment data per user |
| `feedback.csv` | User satisfaction ratings and free-text feedback |

---

## 🔄 Layer Details

### Bronze
- Direct load from CSV into SQL Server staging tables
- No transformation — preserves source data exactly as received
- Serves as the audit trail and re-processable source of truth

### Silver
Stored procedure: `silver.load_silver`

Cleaning operations applied across all five tables:
- Null handling and default value substitution
- Carriage return / line feed stripping (`CHAR(13)`, `CHAR(10)`)
- CASE statement normalisation (conditions ordered most-specific to least-specific)
- CTE-based derived field computation (e.g. usage duration, age bands)
- Explicit table/alias prefixing to resolve ambiguous column references
- Data type casting and standardisation

### Gold
Stored procedure: `gold.load_gold`

Dimensional model tables:

| Table | Type | Description |
|---|---|---|
| `dim_users` | Dimension | Cleaned user attributes |
| `dim_ai_tools` | Dimension | AI tool reference data |
| `dim_date` | Dimension | Date spine for time-series analysis |
| `dim_subscriptions` | Dimension | Subscription tiers |
| `fact_ai_usage` | Fact | Core usage events with all foreign keys |

**Design decision:** `prompt_category` is stored as a plain `VARCHAR` on `fact_ai_usage` rather than as a separate `dim_prompt_category` table. This was a deliberate, defensible choice — a dimension table with no join relationships adds complexity without value.

---

## 📊 KPIs & Analytics (In Progress)

25+ KPIs planned across four domains:

- **Adoption** — active users, tool penetration, new user growth
- **Engagement** — session frequency, prompt volume, feature usage
- **Monetisation** — subscription conversion, revenue by tier, churn
- **Satisfaction** — NPS proxy, feedback sentiment, ratings by tool

---

## 🛠️ Tech Stack

| Component | Technology |
|---|---|
| Database | Microsoft SQL Server |
| Transformation | T-SQL Stored Procedures |
| Architecture | Medallion (Bronze / Silver / Gold) |
| Dashboards | Tableau |
| Version Control | Git / GitHub |
| Documentation | Markdown + Word (docx) |

---

## 🚧 Current Status

| Layer | Status |
|---|---|
| Bronze ingestion | ✅ Complete |
| Silver cleaning (`silver.load_silver`) | ✅ Complete |
| Gold dimensional model — table DDL | ✅ Complete |
| Gold load procedure (`gold.load_gold`) | ✅ Complete |
| KPI query development | 🔄 In Progress |
| Tableau dashboards | 🔄 In Progress |
| Quarantine / data quality layer | 📋 Planned |
| GitHub documentation & README polish | 📋 Planned |

---

## 💡 Key Design Decisions & Learnings

This project was built with the principle that **honest, defensible design choices matter more than technically "complete" but misleading ones**. Notable examples:

- Dropped `dim_prompt_category` rather than maintaining an unjoined dimension for appearances
- Explicit column disambiguation throughout Silver joins rather than relying on implicit resolution
- CASE conditions ordered from most-specific to least-specific to prevent logic short-circuit bugs
- CTEs used to reference derived columns within the same SELECT scope — avoiding repeated computation

SQL debugging patterns resolved during the build:
- `CREATE OR ALTER PROCEDURE` syntax (vs legacy `CREATE PROCEDURE`)
- Removing parentheses from `DATETIME` type declarations
- `CHAR(13)`/`CHAR(10)` stripping from all string fields
- Ambiguous column names resolved via explicit table/alias prefixes

---

## 📁 Repository Structure

```
├── datasets/              # Raw CSV source files
├── sql/
│   ├── bronze/            # Bronze layer DDL and load scripts
│   ├── silver/            # Silver layer DDL and stored procedure
│   ├── gold/              # Gold layer DDL and stored procedure
│   └── kpis/              # KPI queries (in progress)
├── tableau/               # Tableau workbook(s)
├── docs/                  # Project implementation guide and notes
└── README.md
```

---

## 👤 About

Built by **Shakib** as a data engineering portfolio project. The focus is on demonstrating end-to-end warehouse design, SQL engineering discipline, and the kind of practical decision-making that comes up in real data team environments.

---

*Work in progress — check back as KPI queries and Tableau dashboards are added.*
