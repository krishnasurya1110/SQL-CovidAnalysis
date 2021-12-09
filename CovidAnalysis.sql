/* Analysis - based on each country and not continent
Query - written only for countries */ 

SELECT * FROM CovidAnalysis..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3, 4;


-- Initial analysis with a specific set of columns
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidAnalysis..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Total cases vs Total Deaths
-- Likelihood of death if contracted COVID-19 in each country

SELECT 
	   Location, date,
	   total_cases, total_deaths,
	   ROUND((total_deaths / total_cases) * 100, 2) AS DeathPercentage
FROM CovidAnalysis..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Likelihood of death if contracted COVID-19 in India

SELECT 
	   Location, date,
	   total_cases, total_deaths,
	   ROUND((total_deaths / total_cases) * 100, 2) AS DeathPercentage
FROM CovidAnalysis..CovidDeaths
WHERE Location like '%india%'
ORDER BY 1, 2;

-- What percentage of the population contracted COVID-19

SELECT 
	   Location, date,
	   total_cases, population,
	   ROUND((total_cases / population) * 100, 2) AS InfectedPercentage
FROM CovidAnalysis..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Highest infection rate compared to population in each country

SELECT 
	  Location, Population,
	  MAX(total_cases) AS HighestInfected,
	  MAX(ROUND((total_cases / population) * 100, 2)) AS HighestInfectedPercentage
FROM CovidAnalysis..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY 4 DESC;

-- Highest mortality rate compared to population in each country

SELECT 
	  Location, Population,
	  MAX(total_deaths) AS DeathPercentage,
	  MAX(ROUND((total_deaths / population) * 100, 2)) AS HighestDeathPercentage
FROM CovidAnalysis..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY 4 DESC;

-- Countries with highest death count

SELECT Location, MAX(CAST(total_deaths AS INT)) AS TotalDeaths
FROM CovidAnalysis..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY 2 DESC;

-- Total deaths in each continent

SELECT Location, MAX(CAST(total_deaths AS INT)) AS TotalDeaths
FROM CovidAnalysis..CovidDeaths
WHERE (continent  IS NULL) AND (Location NOT LIKE '%income%')
GROUP BY Location
ORDER BY 2 DESC;

-- Global infected and death counts and percentage

SELECT
	  date,
	  SUM(new_cases) Cases,
	  SUM(CAST(new_deaths AS INT)) Deaths,
	  ROUND(SUM(CAST(new_deaths AS INT))/ SUM(new_cases) * 100, 2) AS DeathPercentage
FROM CovidAnalysis..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;

-- Global infected and death count and percentage till date

SELECT
	  SUM(new_cases) Cases,
	  SUM(CAST(new_deaths AS INT)) Deaths,
	  ROUND(SUM(CAST(new_deaths AS INT))/ SUM(new_cases) * 100, 2) AS DeathPercentage
FROM CovidAnalysis..CovidDeaths
WHERE continent IS NOT NULL;

-- From the above query, it can be seen that about 2% of the total population
-- has died due to the corona virus disease











