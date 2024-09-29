select *
from PortfolioProject..coviddeaths
order by 3,4


SELECT *
FROM PortfolioProject..covidvaccinations
ORDER BY 3,4

-- select Data that we are going to be using

select location, date,total_cases,new_cases,total_deaths,population
from PortfolioProject..coviddeaths
order by 1,2


-- this shows the likelyhood of dying if you get covid in your country


select location, date, total_cases, total_deaths, 
       (total_deaths / NULLIF(total_cases, 0)) * 100 as deathpercentage
from PortfolioProject..coviddeaths
where location like '%Tanz%'
order by 1, 2;

--looking at total cases vs population
-- shows what percentage of population got covid

select location, date, total_cases, population, 
      (total_deaths / NULLIF(population, 0)) * 100 as covidpercentage
from PortfolioProject..coviddeaths
where location like '%Tanz%'
order by 1, 2;

 looking at countries with highest infection rate compared to population

select location, population, max(total_cases) as highestinfectioncount,
       max(total_cases / NULLIF(population, 0)) * 100 as percentagepopulationinfected
from PortfolioProject..coviddeaths
--where location like '%Tanz%'
group by population,location
order by percentagepopulationinfected desc

showing countries with highest death count per population

select location, max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..coviddeaths
where continent is not null
group by location
order by TotalDeathCount desc

-breaking things down by continent

select continent, max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc;


select location, max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..coviddeaths
where continent is not null
group by location
order by TotalDeathCount desc;

---showing the continent with the highest death count

select continent, max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc;


global numbers


select date, sum(new_cases), sum(cast(new_deaths as int)), 
sum(cast(new_deaths as int))/sum(nullif(new_cases,0)) * 100 as deathpercentage
from PortfolioProject..coviddeaths
--where location like '%Tanz%'
where continent is not null
group by date
order by 1, 2;


looking at total population vs vaccination

select dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(TRY_CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) AS rollingpeoplevaccinated
from PortfolioProject..coviddeaths dea
join  PortfolioProject..covidvaccinations vac
   on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3;


--USE CTE

with popVSvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(TRY_CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) AS rollingpeoplevaccinated
from PortfolioProject..coviddeaths dea
join  PortfolioProject..covidvaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--)
select *,(rollingpeoplevaccinated/population)*100
from popvsvac
order by 1,2;

---TEMP TABLE

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




 Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

select *
from PercentPopulationVaccinated
