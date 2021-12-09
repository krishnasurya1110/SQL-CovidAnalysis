-- COVID_19 vaccinations analysis

SELECT * FROM CovidAnalysis..CovidVaccinations
WHERE continent IS NOT NULL
ORDER BY 3, 4;

-- Combining deaths and vaccinations tables

SELECT *
FROM CovidAnalysis..CovidDeaths d
JOIN CovidAnalysis..CovidVaccinations v
     ON d.location = v.location
	 AND d.date = v.date;

-- Rolling vaccinations in each country over time

SELECT
	  d.continent, d.location, d.date, d.population,
	  v.new_vaccinations, 
	  SUM(CONVERT(BIGINT, v.new_vaccinations)) OVER (PARTITION BY d.location
													 ORDER BY d.location, d.date) RollingPeopleVaccianted
FROM CovidAnalysis..CovidDeaths d
JOIN CovidAnalysis..CovidVaccinations v
	 ON d.location = v.location
	 AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY 1, 2, 3;

-- Creating CTE, Temp table and VIEWS for the query above

-- Creating a CTE for Population vs Vaccinations

WITH PopvsVacc (Continent, Location, Date, Population, NewVaccinations, RollingPeopleVaccinated)
AS
(
SELECT
	  d.continent, d.location, d.date, d.population,
	  v.new_vaccinations, 
	  SUM(CONVERT(BIGINT, v.new_vaccinations)) OVER (PARTITION BY d.location
													 ORDER BY d.location, d.date) RollingPeopleVaccianted
FROM CovidAnalysis..CovidDeaths d
JOIN CovidAnalysis..CovidVaccinations v
	 ON d.location = v.location
	 AND d.date = v.date
WHERE d.continent IS NOT NULL
)
SELECT *, ROUND(RollingPeopleVaccinated/ Population * 100, 2) 
FROM PopvsVacc;

-- Creating a temp table for the above
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
NewVaccinations numeric,
RollingPeopleVaccinated numeric
)

-- Inserting values into the temp table

INSERT INTO #PercentPopulationVaccinated
SELECT
	  d.continent, d.location, d.date, d.population,
	  v.new_vaccinations, 
	  SUM(CONVERT(BIGINT, v.new_vaccinations)) OVER (PARTITION BY d.location
													 ORDER BY d.location, d.date) RollingPeopleVaccianted
FROM CovidAnalysis..CovidDeaths d
JOIN CovidAnalysis..CovidVaccinations v
	 ON d.location = v.location
	 AND d.date = v.date
WHERE d.continent IS NOT NULL

-- Creating a view to store data for future references

CREATE VIEW PercentPopulationVaccinated AS
SELECT
	  d.continent, d.location, d.date, d.population,
	  v.new_vaccinations, 
	  SUM(CONVERT(BIGINT, v.new_vaccinations)) OVER (PARTITION BY d.location
													 ORDER BY d.location, d.date) RollingPeopleVaccianted
FROM CovidAnalysis..CovidDeaths d
JOIN CovidAnalysis..CovidVaccinations v
	 ON d.location = v.location
	 AND d.date = v.date
WHERE d.continent IS NOT NULL

