use database portfolioproject;

select * from covidvaccination;

select * from coviddeaths where continent is not null;
-- Total cases vs total deaths
select location, date, total_cases, new_cases, total_deaths, population from coviddeaths order by 1,2;

select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercent, population from coviddeaths; 
-- Total cases vs population (percentage of population got covid)
select location, date, total_cases,population,(total_cases/population)*100 as AffectedPrecent  from coviddeaths;
-- Countries with highest infected rate 
select location, MAX(total_cases) as HIR, population, MAX((total_cases/population))*100 as HighestAffectedPrecent from coviddeaths 
group by location, population order by HighestAffectedPrecent desc;   

select location, MAX(total_cases) as HDR from coviddeaths where continent is not null 
group by location order by HDR desc;  
-- Continents with high death wrt population
select continent, MAX(total_cases) as HDR from coviddeaths where continent is not null 
group by continent order by HDR desc; 

select location, MAX(total_cases) as HDR from coviddeaths where continent is not null 
group by location order by HDR desc; 
-- Global numbers
select date,  sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as death_percentage from coviddeaths 
where continent is not null group by date;
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as death_percentage from coviddeaths 
where continent is not null;

-- Joining two tables(total population vs vaccination)
select * from coviddeaths dea join covidvaccination vac on dea.location = vac.location and dea.date = vac.date;
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations from coviddeaths dea join covidvaccination vac 
on dea.location = vac.location and dea.date = vac.date order by 1,2,3;
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over(partition by dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated from coviddeaths dea join covidvaccination vac 
on dea.location = vac.location and dea.date = vac.date where dea.continent is not null order by 1,2,3;
with PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as 
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over(partition by dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated from coviddeaths dea join covidvaccination vac 
on dea.location = vac.location and dea.date = vac.date where dea.continent is not null)
select *, (RollingPeopleVaccinated/population)*100 from PopvsVac;

-- Temp table
create view PercentPopulationVaccinated as

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over(partition by dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated from coviddeaths dea join covidvaccination vac 
on dea.location = vac.location and dea.date = vac.date where dea.continent is not null




















