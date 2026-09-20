SELECT * FROM Coviddeaths
ORDER BY 3, 4

SELECT * FROM CovidVaccinations
ORDER BY 3,4

SELECT
Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
ORDER BY 1, 2


-- Looking at Total Cases vs Total Deaths

SELECT
Location, 
date, 
total_cases, 
total_deaths, 
CAST(total_deaths AS float)/CAST(total_cases AS float) * 100 AS DeathPercentage
FROM CovidDeaths
WHERE location like '%states%'
ORDER BY 1, 2


-- Looking ar Total Cases vs Population

SELECT
Location, 
date,
population,
total_cases, 
total_deaths, 
CAST(total_cases AS float)/CAST(population AS float) * 100 AS PopulationPercentageInfected
FROM CovidDeaths
--WHERE location like '%states%'
ORDER BY 1, 2


-- Looking at Countries with Highest Infection Rate compared to Population

SELECT
Location, 
population,
MAX(total_cases) AS HighestInfectionCount,  
MAX(CAST(total_cases AS float))/MAX(CAST(population AS float)) * 100 AS PopulationPercentageInfected
FROM CovidDeaths
--WHERE location like '%states%'
GROUP BY location, population
ORDER BY PopulationPercentageInfected DESC


-- Showing Contiensts with highest Death Count

SELECT
continent, 
MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- Global Numbers

SELECT 
SUM(CAST(new_cases AS int)) AS total_cases,
SUM(CAST(new_deaths AS int)) AS total_deaths,
SUM(CAST(new_deaths AS float))/SUM(CAST(new_cases AS float))*100 AS DeathPercentage
FROM CovidDeaths
--WHERE location like ''%states%
WHERE continent is not null
--GROUP BY date
ORDER BY 1, 2


-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea
Join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
WHERE dea.continent is not null
ORDER BY 2, 3;


-- USE CTE

with PopvsVac --(contient, Location, Date, population, New_vaccinationss, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea
Join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
WHERE dea.continent is not null
--Order by 2, 3
)
SELECT 
*,
(RollingPeopleVaccinated/population)*100,
 MAX(RollingPeopleVaccinated) OVER (PARTITION BY location) AS MaximumVaccinated
FROM PopvsVac


-- USE TEMP TABLE

DROP TABLE IF exists #PercentPopulationVaccinated

CREATE Table #PercentPopulationVaccinated
(
Continet nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea
Join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
--WHERE dea.continent is not null
--ORDER BY 2, 3

SELECT 
*,
(RollingPeopleVaccinated/population)*100 AS RollingPeopleVaccinatedPercentage
FROM #PercentPopulationVaccinated


-- Creating View to store data for later visulaizations


DROP View IF exists PercentPopulationVaccinated

GO

CREATE View PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea
Join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
WHERE dea.continent is not null
--ORDER BY 2, 3

GO

SELECT * FROM PercentPopulationVaccinated
