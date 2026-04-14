-- =========================================
-- General & Comparative Analysis
-- =========================================

-- What is the total emission per country for the most recent year available?
SELECT 
    country,
    SUM(emission) AS total_emission
FROM emission_3
WHERE year = (SELECT MAX(year) FROM emission_3)
GROUP BY country
ORDER BY total_emission DESC;

-- What are the top 5 countries by GDP in the most recent year?
SELECT 
    Country,
    Value AS gdp
FROM gdp_3
WHERE year = (SELECT MAX(year) FROM gdp_3)
ORDER BY gdp DESC
LIMIT 5;

-- Compare energy production and consumption by country and year.
SELECT 
    p.country,
    p.year,
    p.energy,
    SUM(p.production) AS total_production,
    SUM(c.consumption) AS total_consumption,
    SUM(p.production) - SUM(c.consumption) AS surplus_deficit
FROM production p
JOIN consumption c 
    ON p.country = c.country 
    AND p.year   = c.year 
    AND p.energy = c.energy
GROUP BY p.country, p.year, p.energy
ORDER BY p.country, p.year;

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
SELECT 
    year,
    SUM(emission) AS total_emission,
    SUM(emission) - LAG(SUM(emission)) OVER (ORDER BY year) AS yoy_change
FROM emission_3
GROUP BY year
ORDER BY year;

-- What is the trend in GDP for each country over the given years?
SELECT
	Country,
    year,
    value AS total_gdp,
    value - LAG(value) OVER (PARTITION BY Country ORDER BY year) AS yoy_gdp_change
FROM gdp_3
ORDER BY Country, year;

-- How has population growth affected total emissions in each country?
-- 7. How population growth affected total emissions per country
SELECT 
    e.country,
    e.year,
    SUM(e.emission) AS total_emission,
    p.Value AS population_thousands,
    ROUND(SUM(e.emission) / NULLIF(p.Value, 0), 6) AS emission_per_thousand_people
FROM emission_3 e
JOIN population p 
    ON e.country = p.countries 
    AND e.year   = p.year
GROUP BY e.country, e.year, p.Value
ORDER BY e.country, e.year;

-- Has energy consumption increased or decreased over the years for major economies?
SELECT 
    c.country,
    c.year,
    ROUND(SUM(c.consumption), 2) AS total_consumption,
    ROUND(SUM(c.consumption) - LAG(SUM(c.consumption)) OVER (PARTITION BY c.country ORDER BY year), 2) AS change_in_consumption
FROM consumption c
WHERE c.country IN (
    SELECT Country FROM gdp_3
    WHERE year = (SELECT MAX(year) FROM gdp_3)
    ORDER BY Value DESC
    -- LIMIT 10
)
GROUP BY c.country, c.year
ORDER BY c.country, c.year;

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
SELECT 
    e.country,
    e.year,
    SUM(e.emission) AS total_emission,
    g.Value AS gdp,
    ROUND(SUM(e.emission) / NULLIF(g.Value, 0), 6) AS emission_per_gdp_unit
FROM emission_3 e
JOIN gdp_3 g 
    ON e.country = g.Country 
    AND e.year   = g.year
GROUP BY e.country, e.year, g.Value
ORDER BY emission_per_gdp_unit DESC;

-- What is the energy consumption per capita for each country over the last decade?
SELECT 
    c.country,
    c.year,
    SUM(c.consumption) AS total_consumption,
    p.Value AS population_thousands,
    ROUND(SUM(c.consumption) / NULLIF(p.Value, 0), 6) AS consumption_per_capita
FROM consumption c
JOIN population p 
    ON c.country = p.countries 
    AND c.year   = p.year
WHERE c.year >= (SELECT MAX(year) FROM consumption) - 10
GROUP BY c.country, c.year, p.Value
ORDER BY c.country, c.year;

-- How does energy production per capita vary across countries?
SELECT 
    p.country,
    p.year,
    SUM(p.production) AS total_production,
    pop.Value AS population_thousands,
    ROUND(SUM(p.production) / NULLIF(pop.Value, 0), 6) AS production_per_capita
FROM production p
JOIN population pop 
    ON p.country = pop.countries 
    AND p.year   = pop.year
GROUP BY p.country, p.year, pop.Value
ORDER BY production_per_capita DESC;

-- Which countries have the highest energy consumption relative to GDP?
SELECT 
    c.country,
    c.year,
    SUM(c.consumption) AS total_consumption,
    g.Value AS gdp,
    ROUND(SUM(c.consumption) / NULLIF(g.Value, 0), 6) AS consumption_per_gdp_unit
FROM consumption c
JOIN gdp_3 g
    ON c.country = g.country 
    AND c.year   = g.year
GROUP BY c.country, c.year, g.Value
ORDER BY consumption_per_gdp_unit DESC
LIMIT 20;

-- What is the correlation between GDP growth and energy production growth?
SELECT 
    g.Country,
    g.year,
    g.Value AS gdp,
    g.Value - LAG(g.Value) OVER (PARTITION BY g.Country ORDER BY g.year) AS gdp_growth,
    SUM(p.production) AS total_production,
    SUM(p.production) - LAG(SUM(p.production)) OVER (PARTITION BY g.Country ORDER BY g.year) AS production_growth
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
SELECT 
    p.countries,
    p.year,
    p.Value AS population_thousands,
    SUM(e.emission) AS total_emission
FROM population p
JOIN emission_3 e 
    ON p.countries = e.country 
    AND p.year     = e.year
WHERE p.year = (SELECT MAX(year) FROM population)
GROUP BY p.countries, p.year, p.Value
ORDER BY p.Value DESC
LIMIT 10;

-- Which countries have improved (reduced) their per capita emissions the most over the last decade?
SELECT 
    country,
    ROUND(MIN(per_capita_emission), 4) AS earliest_per_capita,
    ROUND(MAX(per_capita_emission), 4) AS latest_per_capita,
    ROUND(MIN(per_capita_emission) - MAX(per_capita_emission), 4) AS reduction
FROM emission_3
WHERE year >= (SELECT MAX(year) FROM emission_3) - 10
GROUP BY country
HAVING reduction > 0
ORDER BY reduction DESC
LIMIT 20;

-- What is the global share (%) of emissions by country?
SELECT 
    country,
    SUM(emission) AS total_emission,
    ROUND(SUM(emission) * 100.0 / SUM(SUM(emission)) OVER (), 2) AS emission_share_pct
FROM emission_3
WHERE year = (SELECT MAX(year) FROM emission_3)
GROUP BY country
ORDER BY emission_share_pct DESC;

-- What is the global average GDP, emission, and population by year?
SELECT 
    g.year,
    ROUND(AVG(g.Value), 4) AS avg_gdp,
    ROUND(AVG(e.total_emission), 4) AS avg_emission,
    ROUND(AVG(p.Value), 4) AS avg_population_thousands
FROM gdp_3 g
JOIN (
    SELECT country, year, SUM(emission) AS total_emission
    FROM emission_3
    GROUP BY country, year
) e ON g.Country = e.country AND g.year = e.year
JOIN population p 
    ON g.Country = p.countries 
    AND g.year   = p.year
GROUP BY g.year
ORDER BY g.year;