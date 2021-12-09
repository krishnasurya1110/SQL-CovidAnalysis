/* Analysis - based on each country and not continent
Query - written only for countries */ 

SELECT * FROM CovidAnalysis..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3, 4

SELECT * FROM CovidAnalysis..CovidVaccinations
WHERE continent IS NOT NULL
ORDER BY 3, 4






