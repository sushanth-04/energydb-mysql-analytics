-- =========================================
-- General & Comparative Analysis
-- =========================================

-- What is the total emission per country for the most recent year available?
SELECT country, SUM(emission) AS total_emission
FROM emission_3
WHERE year = (SELECT MAX(year) FROM emission_3)
GROUP BY country
ORDER BY total_emission DESC
LIMIT 10;

-- What are the top 5 countries by GDP in the most recent year?
SELECT Country, GDP
FROM (
    SELECT Country, Value AS GDP,
           RANK() OVER (ORDER BY Value DESC) AS rnk
    FROM gdp_3
    WHERE year = (SELECT MAX(year) FROM gdp_3)
) t
WHERE rnk <= 5;

-- Compare energy production and consumption by country and year.
WITH aggregated AS (
    SELECT 
        p.country,
        p.year,
        p.energy,
        SUM(p.production) AS total_production,
        SUM(c.consumption) AS total_consumption
    FROM production p
    INNER JOIN consumption c
        ON p.country = c.country
       AND p.year = c.year
       AND p.energy = c.energy
    GROUP BY p.country, p.year, p.energy
)
SELECT 
    country,
    year,
    energy,
    total_production - total_consumption AS surplus_deficit,
    CASE 
        WHEN total_production > total_consumption THEN 'Surplus'
        WHEN total_production < total_consumption THEN 'Deficit'
        ELSE 'Balanced'
    END AS status
FROM aggregated
ORDER BY country, year;

-- Which energy types contribute most to emissions across all countries?
SELECT 
    energy_type,
    SUM(emission) AS total_emission
FROM emission_3
GROUP BY energy_type
ORDER BY total_emission DESC;


-- =========================================
-- Trend Analysis Over Time
-- =========================================

-- How have global emissions changed year over year?
SELECT year,
       SUM(emission) AS total_emission,
       SUM(emission) - LAG(SUM(emission)) OVER (ORDER BY year) AS yearly_change
FROM emission_3
GROUP BY year
ORDER BY year;

-- What is the trend in GDP for each country over the given years?
SELECT Country, year, Value AS GDP,
       Value - LAG(Value) OVER (PARTITION BY Country ORDER BY year) AS growth
FROM gdp_3
ORDER BY Value DESC, year;

-- How has population growth affected total emissions in each country?
SELECT e.country, e.year,
       SUM(e.emission) AS emission,
       p.Value AS population,
       SUM(e.emission)/p.Value AS emission_per_capita
FROM emission_3 e
JOIN population p
  ON e.country = p.countries AND e.year = p.year
GROUP BY e.country, e.year, p.Value
ORDER BY p.Value DESC;

-- Has energy consumption increased or decreased over the years for major economies?
SELECT country, year,
       SUM(consumption) AS total_consumption,
       SUM(consumption) - LAG(SUM(consumption)) 
           OVER (PARTITION BY country ORDER BY year) AS yearly_change
FROM consumption
GROUP BY country, year;

-- What is the average yearly change in emissions per capita for each country?
SELECT 
    country,
    ROUND(AVG(per_capita_emission), 6)  AS avg_per_capita_emission,
    ROUND(
        (MAX(per_capita_emission) - MIN(per_capita_emission)) 
        / NULLIF(COUNT(DISTINCT year) - 1, 0)
    , 6) AS avg_yearly_change
FROM emission_3
GROUP BY country
ORDER BY avg_yearly_change DESC;


-- =========================================
-- Ratio & Per Capita Analysis
-- =========================================

-- What is the emission-to-GDP ratio for each country by year?
SELECT e.country, e.year,
       SUM(e.emission)/g.Value AS ratio
FROM emission_3 e
JOIN gdp_3 g
  ON e.country = g.Country AND e.year = g.year
GROUP BY e.country, e.year, g.Value;

-- What is the energy consumption per capita for each country over the last decade?
SELECT c.country, c.year,
       SUM(c.consumption)/p.Value AS consumption_per_capita
FROM consumption c
JOIN population p
  ON c.country = p.countries AND c.year = p.year
GROUP BY c.country, c.year, p.Value;

-- How does energy production per capita vary across countries?
SELECT pr.country, pr.year,
       SUM(pr.production)/p.Value AS production_per_capita
FROM production pr
JOIN population p
  ON pr.country = p.countries AND pr.year = p.year
GROUP BY pr.country, pr.year, p.Value;

-- Which countries have the highest energy consumption relative to GDP?
SELECT country, year, ratio
FROM (
    SELECT c.country, c.year,
           SUM(c.consumption)/g.Value AS ratio,
           DENSE_RANK() OVER (ORDER BY SUM(c.consumption)/g.Value DESC) AS rnk
    FROM consumption c
    JOIN gdp_3 g
      ON c.country = g.Country AND c.year = g.year
    GROUP BY c.country, c.year, g.Value
) t
WHERE rnk <= 10;

-- What is the correlation between GDP growth and energy production growth?
SELECT 
    g.Country,
    g.year,
    g.Value AS gdp,
    g.Value - LAG(g.Value) OVER (PARTITION BY g.Country ORDER BY g.year) AS gdp_growth,
    SUM(p.production) AS total_production,
    SUM(p.production) - LAG(SUM(p.production)) 
		OVER (PARTITION BY g.Country ORDER BY g.year) AS production_growth
FROM gdp_3 g
JOIN production p 
    ON g.Country = p.country 
    AND g.year   = p.year
GROUP BY g.Country, g.year, g.Value
ORDER BY g.Country, g.year;

-- =========================================
-- Global Comparisons
-- =========================================

-- What are the top 10 countries by population and how do their emissions compare?
SELECT countries, population
FROM (
    SELECT countries, Value AS population,
           RANK() OVER (ORDER BY Value DESC) AS rnk
    FROM population
    WHERE year = (SELECT MAX(year) FROM population)
) t
WHERE rnk <= 10;

-- Which countries have improved (reduced) their per capita emissions the most over the last decade?
SELECT 
    country,
    MIN(per_capita_emission) AS earliest_per_capita,
    MAX(per_capita_emission) AS latest_per_capita,
    MIN(per_capita_emission) - MAX(per_capita_emission) AS reduction
FROM emission_3
WHERE year >= (SELECT MAX(year) FROM emission_3) - 10
GROUP BY country
ORDER BY reduction DESC
LIMIT 20;

-- What is the global share (%) of emissions by country?
SELECT country,
       SUM(emission) AS total_emission,
       SUM(emission) * 100.0 /
       SUM(SUM(emission)) OVER () AS percentage_share
FROM emission_3
GROUP BY country
ORDER BY percentage_share DESC;

-- What is the global average GDP, emission, and population by year?
SELECT e.year,
       AVG(e.emission) AS avg_emission,
       AVG(g.Value) AS avg_gdp,
       AVG(p.Value) AS avg_population
FROM emission_3 e
JOIN gdp_3 g ON e.country = g.Country AND e.year = g.year
JOIN population p ON e.country = p.countries AND e.year = p.year
GROUP BY e.year;