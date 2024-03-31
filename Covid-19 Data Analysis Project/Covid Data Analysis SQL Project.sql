SELECT *
FROM PortfolioProject..CovidDeaths
WHERE Continent IS NOT NULL
ORDER BY 3,4;

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4;



--Selecting data that going to be used

SELECT Location,Date,Total_cases,New_cases,Total_deaths,Population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2;

--Looking at Total Cases vs Total Deaths
--Show likelihood of dying if you contract covid in india

SELECT Location,Date,Total_cases,Total_deaths,(Total_deaths/Total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
Where location LIKE '%india%'
AND Continent IS NOT NULL
ORDER BY 1,2;

--Looking at Total Cases vs Population
--Show what percentage of population got covid

SELECT Location,Date,Population,Total_cases,(Total_cases/Population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--Where location LIKE '%india%'
ORDER BY 1,2;

--Looking at countries with highest infection rate compared to population

SELECT Location,Population,MAX(Total_cases) AS HighestInfectionCount,
MAX((Total_cases/Population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--Where location LIKE '%india%'
GROUP BY Location,Population
ORDER BY PercentPopulationInfected DESC;

--Showing countries with highest death count per population

SELECT Location,MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--Where location LIKE '%india%'
WHERE Continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;

--Let's break things down by continent

--Showing continents with highest death count per population

SELECT Continent,MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--Where location LIKE '%india%'
WHERE Continent IS NOT NULL
GROUP BY Continent
ORDER BY TotalDeathCount DESC;

--Global Numbers

SELECT SUM(New_cases),SUM(CAST(New_deaths AS INT)),
SUM(CAST(New_deaths AS INT))/SUM(New_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--Where location LIKE '%india%'
WHERE Continent IS NOT NULL
ORDER BY 1,2;

--Looking at total population vs vaccinations

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS RollingPeopleVaccinated,
--(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
ORDER BY 2,3;

--USING CTE

WITH Popvsvac (Continent,Location,Date,Population,New_vaccinations,RollingPeopleVaccinated)
AS
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
--ORDER BY 2,3
)

SELECT *,(RollingPeopleVaccinated/population)*100
FROM Popvsvac;

--TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME,
Population NUMERIC,
New_vaccinations NUMERIC,
RollingPeopleVaccinated NUMERIC
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent is NOT NULL
--ORDER BY 2,3

SELECT *
FROM #PercentPopulationVaccinated

--Creating view for later data visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated