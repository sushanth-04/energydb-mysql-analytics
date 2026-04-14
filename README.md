# ⚡ ENERGYDB — Global Energy & Emissions Analytics (MySQL)

![MySQL](https://img.shields.io/badge/MySQL-Database-4479A1?logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Advanced%20Queries-orange)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![Countries](https://img.shields.io/badge/Coverage-230%2B%20Countries-blue)

> Relational MySQL database analyzing global energy, emissions, GDP & population data across 230+ countries — 19 advanced SQL queries with window functions.

---

## 📌 Project Overview

**ENERGYDB** is a structured relational database project built in MySQL, designed to analyze global trends across energy consumption, CO₂ emissions, GDP, and population for **230+ countries**.

The project covers full schema design, foreign key relationships, and 19 analytical queries using advanced SQL concepts including LAG, window functions, NULLIF, and scalar subqueries.

Built as part of my **Data Science Certification at [Innomatics Research Labs](https://www.innomatics.in/)**, Hyderabad.

---

## 🎯 Objectives

- Design a normalized relational schema for multi-dimensional global data
- Establish entity relationships using primary & foreign keys
- Write advanced SQL queries to derive meaningful global insights
- Analyze relationships between energy use, emissions, GDP & population
- Demonstrate industry-level SQL proficiency beyond basic SELECT statements

---

## 📂 Dataset Information

| Attribute | Details |
|---|---|
| Source | World Bank / Our World in Data (Public Datasets) |
| Coverage | 230+ countries |
| Time Span | Multi-year historical data |
| Domain | Energy, Environment, Economics, Demographics |

**Tables in the Schema:**
- `countries` — Country master data (name, region, income group)
- `energy` — Energy consumption metrics per country per year
- `emissions` — CO₂ and greenhouse gas emissions data
- `gdp` — GDP and GDP per capita figures
- `population` — Annual population data

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| MySQL 8.x | Database engine |
| MySQL Workbench | Schema design & query execution |
| SQL | Data definition, manipulation & analysis |

---

## 🗄️ Schema Design

```
countries (PK: country_id)
    │
    ├──── energy      (FK: country_id)
    ├──── emissions   (FK: country_id)
    ├──── gdp         (FK: country_id)
    └──── population  (FK: country_id)
```

All tables reference `countries` via foreign key, ensuring referential integrity across the dataset.

---

## 🔍 SQL Concepts Demonstrated

| Concept | Used In |
|---|---|
| `Window Functions` | Ranking countries by energy consumption per year |
| `LAG()` | Year-over-year emissions change analysis |
| `NULLIF()` | Safe division to avoid divide-by-zero errors |
| `Scalar Subqueries` | Comparing countries against global averages |
| `GROUP BY + HAVING` | Filtering aggregated results |
| `JOINs (INNER, LEFT)` | Combining data across multiple tables |
| `CTEs` | Breaking down complex multi-step queries |
| `ORDER BY + LIMIT` | Top-N country rankings |

---

## 📊 Sample Analytical Queries (19 Total)

```sql
-- 1. Top 10 countries by CO₂ emissions (latest year)
-- 2. Year-over-year emissions change using LAG()
-- 3. Energy consumption per capita by region
-- 4. Countries where GDP grew but emissions dropped
-- 5. Global average energy use vs country comparison (scalar subquery)
-- 6. Rank countries by renewable energy share using RANK()
-- 7. Emission intensity (emissions per unit GDP) using NULLIF()
-- ... and 12 more
```

> Full query file: `queries/analysis_queries.sql`

---

## 📁 Repository Structure

```
energydb-mysql-analytics/
│
├── schema/
│   └── energydb_schema.sql         # CREATE TABLE statements + FK setup
│
├── data/
│   └── *.csv files               # CSV files for countries, energy, emissions, gdp, population
│
├── queries/
│   └── analysis_queries.sql        # All 19 analytical SQL queries
│
├── presentation/
│   └── energydb_presentation.pptx   # Project presentation slides
│
│── ER_diagram.png                    # Entity-Relationship diagram of the schema
│
└── README.md
```


## 📊 Key Insights

- The **top 5 emitters** account for over 60% of global CO₂ output
- Several **low-GDP countries** show disproportionately high energy intensity
- **Renewable energy share** correlates strongly with higher income groups
- Countries with strong GDP growth post-2010 show diverging emissions trends — some decoupled, others didn't
- **Population size alone** is a weak predictor of per-capita energy use

---

## 🙏 Acknowledgements

This project was completed as part of my **Data Science Certification Program** at **[Innomatics Research Labs](https://www.innomatics.in/)**, Hyderabad. Thank you to the mentors for pushing beyond basic SQL into real database engineering principles.

---

## 🙋 About Me

**Venkata Sai Sushanth Bongarala**
Graduated in B.Tech — Computer Science (AI & ML)
📍 Hyderabad, India

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](https://linkedin.com/in/bvssushanth)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?logo=github)](https://github.com/sushanth-04)