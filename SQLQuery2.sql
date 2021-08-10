select *
from ProjectPortfolio..[Covid Deats]
where continent is not null 
order by 3,4

--select *
--from ProjectPortfolio..[covid-Vaccination]
--order by 3,4
-- select the data that we are going to be using--

select location,date,total_cases, total_deaths, population
from ProjectPortfolio..[Covid Deats]

order by 1,2

--looking at total cases versus total death.
-- shows likelihood of dying if you contract covid in your country

select location,date,total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as deatpercentae
from ProjectPortfolio..[Covid Deats]
where location like '%somalia%'
order by 1,2

--looking at total cases versus population 
--shows what percentae of population got covid

select location, date, population, total_cases, (total_cases/population)*100 as deatpercentae
from ProjectPortfolio..[Covid Deats]
where location like '%somalia%'
order by 1,2

--looking at total cases versus population of every country
select location, date, population, total_cases, (total_cases/population)*100 as percentofpopulationinfected
from ProjectPortfolio..[Covid Deats]
order by 1,2


 --looking at the countries with  highest infection rate compared to population 

select location, population, MAX(cast (total_cases as int)) as topcountry, Max((total_cases/population))*100 as percentofpopulationinfected
from ProjectPortfolio..[Covid Deats]
--where location like '%somalia%'
group by population, location
order by percentofpopulationinfected desc

--looking at the countries with  highest Death rate compared to population

select location, population, MAX(cast (total_deaths as int)) as topcountry, Max((total_deaths/population))*100 as deathratepercentage
from ProjectPortfolio..[Covid Deats]
--where location like '%somalia%'
group by population, location
order by deathratepercentage desc


--looking at the countries with  highest Death rate

select location, population, MAX(cast (total_deaths as int)) as TotalDeaths
from ProjectPortfolio..[Covid Deats]
--where location like '%somalia%'
group by location, population
order by TotalDeaths desc


-- showing countries with highest death count per population

select location, population, MAX(total_deaths) as Totaldeathcount
from ProjectPortfolio..[Covid Deats]
--where location like '%somalia%'
where continent is not null
group by location, population
order by Totaldeathcount desc 

--let's break down things by continent 

select continent, MAX(total_deaths) as Totaldeathcount
from ProjectPortfolio..[Covid Deats]
--where location like '%somalia%'
where continent is not null
group by continent
order by Totaldeathcount desc

--showing continents with the highest death count per population

select location, MAX(cast (total_deaths) )as Totaldeathcount
from ProjectPortfolio..[Covid Deats]
--where location like '%somalia%'
where continent is null
group by location
order by Totaldeathcount desc

--GLOBAL NUMBERS

select sum(new_cases)as TotalCases, sum(cast(total_deaths as int))as TotoalDeaths,sum(cast(total_deaths as int))/sum(total_cases)*100 as deatpercentae
from ProjectPortfolio..[Covid Deats]
--where location like '%somalia%'
where continent is not null
--group by date 
order by 1,2

-- looking total population vs vaccination

select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(convert(int,vac.new_vaccinations))
OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from projectportfolio..[Covid Deats] dea
join projectportfolio..[covid-Vaccination] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE
with popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(convert(int,vac.new_vaccinations))
OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from projectportfolio..[Covid Deats] dea
join projectportfolio..[covid-Vaccination] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from popvsvac


--TEMP TABLE
DROP TABLE IF EXISTS #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)
insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(convert(int,vac.new_vaccinations))
OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from projectportfolio..[Covid Deats] dea
join projectportfolio..[covid-Vaccination] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #percentpopulationvaccinated


-- Creating view to store data for later visulaisations

create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum (convert(int,vac.new_vaccinations))
OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from projectportfolio..[Covid Deats] dea
join projectportfolio..[covid-Vaccination] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3









