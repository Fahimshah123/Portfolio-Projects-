select * 
from [portfolio project]..CovidDeaths
order by 3,4
-- select *
-- From [portfolio project]..CovidVaccinations
-- order by 3,4 

SELECT Location, date, total_cases, total_deaths, population
FROM [portfolio project]..CovidDeaths
ORDER BY 1,2

-- looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country 
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [portfolio project]..CovidDeaths
WHERE [location] like '%desh%'
AND continent is not NULL
ORDER BY 1,2

-- Looking at total cases vs population
-- shows what percentage of population got covid

SELECT Location, date,population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM [portfolio project]..CovidDeaths
WHERE continent is not NULL
-- WHERE [location] like '%desh%'
ORDER BY 1,2

-- Looking at country with Highest infection rate compare to population

SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS PercentPopulationInfected
FROM [portfolio project]..CovidDeaths
WHERE continent is not NULL
-- WHERE [location] like '%desh%'
GROUP BY [location], population
ORDER BY PercentPopulationInfected DESC

-- this is showing countries with highest death count per population

SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS PercentPopulationInfected
FROM [portfolio project]..CovidDeaths
WHERE continent is not NULL
-- WHERE [location] like '%desh%'
GROUP BY [location], population
ORDER BY PercentPopulationInfected DESC

-- showing countries with highest death count per population

 SELECT Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM [portfolio project]..CovidDeaths
-- WHERE [location] like '%desh%'
WHERE continent is not NULL
GROUP BY [location]
ORDER BY TotalDeathCount DESC

-- Lets brack things down by continent

SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM [portfolio project]..CovidDeaths
-- WHERE [location] like '%desh%'
WHERE continent is not NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC
-- Showing contintents with the highest death count per population


-- Global Numbers
 
SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM [portfolio project]..CovidDeaths
-- WHERE [location] like '%desh%'
WHERE continent is not NULL
-- Group by 
ORDER BY 1,2

-- Use CTE 

with PopvsVac (continent,Location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT  dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION by dea.Location) AS RollingPeopleVaccinated
FROM [portfolio project]..CovidDeaths dea
JOIN [portfolio project]..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date 
WHERE dea.continent is not NULL
-- ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac


 -- Using Temp Table to perform Calculation on Partition By in previous query
DROP TABLE if EXISTS #PercentPopulationVaccinated
 create table #PercentPopulationVaccinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )

 insert into #PercentPopulationVaccinated
 SELECT  dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION by dea.Location) AS RollingPeopleVaccinated
FROM [portfolio project]..CovidDeaths dea
JOIN [portfolio project]..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date 
WHERE dea.continent is not NULL
-- ORDER BY 2,3
select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


-- creating view to store data for vitualzations
CREATE VIEW PercentPopulationVaccinated AS
SELECT  dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION by dea.Location) AS RollingPeopleVaccinated
FROM [portfolio project]..CovidDeaths dea
JOIN [portfolio project]..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date 
WHERE dea.continent is not NULL
-- ORDER BY 2,3

select *
from PercentPopulationVaccinated