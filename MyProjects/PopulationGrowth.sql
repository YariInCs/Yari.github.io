select *
from population_and_demography;

select
min(Year),
max(Year) 
from population_and_demography;
SET sql_mode = CONCAT(@@sql_mode, ',ANSI_QUOTES');

ALTER TABLE population_and_demography RENAME COLUMN "Country name" TO country_name;
ALTER TABLE population_and_demography RENAME COLUMN "Year" TO population_year;
ALTER TABLE population_and_demography RENAME COLUMN "Population of children under the age of 1" TO population_children_under_1;
ALTER TABLE population_and_demography RENAME COLUMN "Population of children under the age of 5" TO population_children_under_5;
ALTER TABLE population_and_demography RENAME COLUMN "Population of children under the age of 15" TO population_children_under_15;
ALTER TABLE population_and_demography RENAME COLUMN "Population under the age of 25" TO population_under_25;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 15 to 64 years" TO population_15_to_64;
ALTER TABLE population_and_demography RENAME COLUMN "Population older than 15 years" TO population_older_15;
ALTER TABLE population_and_demography RENAME COLUMN "Population older than 18 years" TO population_older_18;
ALTER TABLE population_and_demography RENAME COLUMN "Population at age 1" TO population_at_1;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 1 to 4 years" TO population_1_to_4;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 5 to 9 years" TO population_5_to_9;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 10 to 14 years" TO population_10_to_14;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 15 to 19 years" TO population_15_to_19;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 20 to 29 years" TO population_20_to_29;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 30 to 39 years" TO population_30_to_39;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 40 to 49 years" TO population_40_to_49;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 50 to 59 years" TO population_50_to_59;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 60 to 69 years" TO population_60_to_69;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 70 to 79 years" TO population_70_to_79;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 80 to 89 years" TO population_80_to_89;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 90 to 99 years" TO population_90_to_99;
ALTER TABLE population_and_demography RENAME COLUMN "Population older than 100 years" TO population_100_above;

-- what is the population over 90 in every country?

select *
From population_and_demography;
select
country_name,
count(*)
From population_and_demography
group by country_name
order by country_name ASC;

-- which country had the biggest growth?


select distinct country_name
from population_and_demography
where country_name like '%(UN)';
alter table population_and_demography
add column record_type VARCHAR(100);

update population_and_demography
set record_type = 'Continent'
where country_name like '%(UN)';

select distinct country_name
from population_and_demography
where record_type is null;

UPDATE population_and_demography
SET record_type = 'Category'
WHERE country_name IN (
'High-income countries',
'Land-locked developing countries (LLDC)',
'Least developed countries',
'Less developed regions',
'Less developed regions, excluding China',
'Less developed regions, excluding least developed countries',
'Low-income countries',
'Lower-middle-income countries',
'More developed regions',
'Small island developing states (SIDS)',
'Upper-middle-income countries',
'World'
);
UPDATE population_and_demography
SET record_type = 'Country'
WHERE record_type is null;

select
country_name,
population_year,
population_90_to_99 + population_100_above as pop_90_above
from population_and_demography
where population_year = 2021
and record_type = 'Country'
order by country_name;

select *
from population_and_demography
where record_type = 'Country';

select
country_name,
population_2020,
population_2021,
population_2021 - population_2020 AS pop_growth_number,
round(cast((population_2021 - population_2020) as decimal)/ population_2020 * 100, 2) as pop_growth_pctc
from (	
	select
	p.country_name,
		( 	SELECT p1.population
			from population_and_demography p1
			where p1.country_name = p.country_name
			and p1.population_year = 2020
	)AS population_2020,
	( SELECT p1.population
	from population_and_demography p1
	where p1.country_name = p.country_name
	and p1.population_year = 2021
	)AS population_2021
	from population_and_demography p
	where p.record_type = 'Country'
	and p.population_year = 2021
    ) s
    order by pop_growth_number desc;
    
    -- Which single country has the highest population decline in the the last year?
    
    select *
from population_and_demography
where record_type = 'Country';

select
country_name,
population_2020,
population_2021,
population_2021 - population_2020 AS pop_growth_number,
round(cast((population_2021 - population_2020) as decimal)/ population_2020 * 100, 2) as pop_growth_pctc
from (	
	select
	p.country_name,
		( 	SELECT p1.population
			from population_and_demography p1
			where p1.country_name = p.country_name
			and p1.population_year = 2020
	)AS population_2020,
	( SELECT p1.population
	from population_and_demography p1
	where p1.country_name = p.country_name
	and p1.population_year = 2021
	)AS population_2021
	from population_and_demography p
	where p.record_type = 'Country'
	and p.population_year = 2021
    ) s
    order by pop_growth_number ASC
    LIMIT 1;
    
-- Top 10 countries with the highest population growth in the last 10 years?

select
country_name,
population_2011,
population_2021,
population_2021 - population_2011 AS pop_growth_number
from (	
	select
	p.country_name,
		( 	SELECT p1.population
			from population_and_demography p1
			where p1.country_name = p.country_name
			and p1.population_year = 2011
	)AS population_2011,
	( SELECT p1.population
	from population_and_demography p1
	where p1.country_name = p.country_name
	and p1.population_year = 2021
	)AS population_2021
	from population_and_demography p
	where p.record_type = 'Country'
	and p.population_year = 2021
    ) s
    order by pop_growth_number desc
    LIMIT 10;

-- Which country has the highest percentage growth since the first year recorded?

CREATE VIEW population_by_year as
select
country_name,
population_1950,
population_2011,
population_2020,
population_2021
from (	
	select
	p.country_name,
		( 	SELECT p1.population
			from population_and_demography p1
			where p1.country_name = p.country_name
			and p1.population_year = 1950
	)AS population_1950,
    ( 	SELECT p1.population
			from population_and_demography p1
			where p1.country_name = p.country_name
			and p1.population_year = 2011
	)AS population_2011,
    ( 	SELECT p1.population
			from population_and_demography p1
			where p1.country_name = p.country_name
			and p1.population_year = 2020
	)AS population_2020,
	( SELECT p1.population
	from population_and_demography p1
	where p1.country_name = p.country_name
	and p1.population_year = 2021
	)AS population_2021
	from population_and_demography p
	where p.record_type = 'Country'
	and p.population_year = 2021
    ) s;
    
select
country_name,
population_1950,
population_2021,
round(cast((population_2021 - population_1950) as decimal)/ population_1950 * 100, 2) as pop_growth_pct
from population_by_year
order by pop_growth_pct desc;

-- Which country has the highest population afed 1 as a percantage of their overall population?

select
country_name,
population,
population_at_1,
round(cast(population_at_1 as decimal)/ population * 100, 2) as pop_retio
from population_and_demography
where record_type = 'country'
and population_year = 2021
order by pop_retio desc;

-- What is the population of each continent in each year, and how much has it changed in each year?

select
country_name,
population_year,
population,
lag(population, 1) over(
	partition by country_name
	order by population_year asc
)as population_change
from population_and_demography
where record_type = 'continent'
order by country_name asc, population_year asc;