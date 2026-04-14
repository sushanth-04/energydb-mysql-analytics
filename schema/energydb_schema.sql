-- =========================================
-- Database Initialization
-- =========================================

-- CREATE DATABASE ENERGYDB;
USE ENERGYDB;


-- =========================================
-- Table: country (Master Table)
-- =========================================

CREATE TABLE country (
    CID VARCHAR(10) PRIMARY KEY,
    Country VARCHAR(100) UNIQUE
);


-- =========================================
-- Table: emission_3 (Emissions Data)
-- =========================================

CREATE TABLE emission_3 (
    country VARCHAR(100),
    energy_type VARCHAR(50),
    year INT,
    emission DOUBLE,
    per_capita_emission DOUBLE,
    FOREIGN KEY (country) REFERENCES country(Country)
);


-- =========================================
-- Table: population (Population Data)
-- =========================================

CREATE TABLE population (
    countries VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (countries) REFERENCES country(Country)
);


-- =========================================
-- Table: production (Energy Production)
-- =========================================

CREATE TABLE production (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    production DOUBLE,
    FOREIGN KEY (country) REFERENCES country(Country)
);


-- =========================================
-- Table: gdp_3 (GDP Data)
-- =========================================

CREATE TABLE gdp_3 (
    Country VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (Country) REFERENCES country(Country)
);


-- =========================================
-- Table: consumption (Energy Consumption)
-- =========================================

CREATE TABLE consumption (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    consumption DOUBLE,
    FOREIGN KEY (country) REFERENCES country(Country)
);


-- =========================================
-- Data Verification Queries
-- =========================================

SELECT * FROM country;
SELECT * FROM emission_3;
SELECT * FROM population;
SELECT * FROM production;
SELECT * FROM gdp_3;
SELECT * FROM consumption;


-- =========================================
-- Foreign Key Constraints (Explicit Naming)
-- =========================================

-- country (1) → (many) emission_3
ALTER TABLE emission_3
ADD CONSTRAINT fk_emission_country
FOREIGN KEY (country) REFERENCES country(Country);

-- country (1) → (many) population
ALTER TABLE population
ADD CONSTRAINT fk_population_country
FOREIGN KEY (countries) REFERENCES country(Country);

-- country (1) → (many) production
ALTER TABLE production
ADD CONSTRAINT fk_production_country
FOREIGN KEY (country) REFERENCES country(Country);

-- country (1) → (many) consumption
ALTER TABLE consumption
ADD CONSTRAINT fk_consumption_country
FOREIGN KEY (country) REFERENCES country(Country);

-- country (1) → (many) gdp_3
ALTER TABLE gdp_3
ADD CONSTRAINT fk_gdp_country
FOREIGN KEY (Country) REFERENCES country(Country);