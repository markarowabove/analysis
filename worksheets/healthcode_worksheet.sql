use healthcode;

truncate constituents;

UPDATE constituents SET birthdate = STR_TO_DATE(birthdate_text, '%c/%e/%Y');

drop table if exists multipleevent_ids;
create temporary table multipleevent_ids engine=memory as (
select 
	consid, 
	count(*) as dupes 
from 
	events 
where consid != 167
group by 
	consid 
having 
	(
		count(*) > 1
	) 
order by 
	dupes desc
);

update 
#select birthdate from 
constituents
set birthdate = Null
where birthdate = '0000-00-00';

select a.consid as id, year(b.birthdate) from multipleevent_ids a
inner join constituents b on a.consid = b.id;

drop table if exists birthdates;
create temporary table birthdates engine=memory as (
select b.id,
  case
    when datediff(now(), b.birthdate) / 365.25 > 50 then '51 & over'
    when datediff(now(), b.birthdate) / 365.25 > 30 then '31 - 50'
    when datediff(now(), b.birthdate) / 365.25 > 19 then '20 - 30'
    else 'under 20'
  end as agegroup
from multipleevent_ids a
inner join constituents b on a.consid = b.id
);

select avg(datediff(now(), b.birthdate) / 365.25) as ageavg
from constituents b
inner join events a on b.id = a.consid
where a.level = 'Gold';


-- age group
select agegroup, count(*) as agecount
from birthdates 
group by agegroup 
order by agecount desc;

-- gender
select gender, count(*) as gendercount
from constituents
where gender <> '' and gender is not null
group by gender;

-- country
select country, count(*) as countrycount
from constituents
where country <> '' and country is not null
group by country;

-- US states
select state, count(*) as statecount
from constituents
where country = 'US'
group by state
order by state;

-- US cities
select city, state, count(*) as citycount
from constituents
where country = 'US' 
	and (state <> '' and state is not null)
    and (city <> '' and city is not null)
group by city, state
order by city;

select count(*) from constituents 
where gender = '' or gender is null;

select a.consid
from events a
where a.consid != 167
group by a.consid 
having (count(*) > 1);

select id, state
from constituents
where country = 'US'
and state is null
order by state;

update constituents 
set state = null
where state = 'None';

update constituents 
set state = 'TX'
where state = 'Texas';

select *
from constituents
where id = 35980;

update constituents
set state = 'MO'
where id = 35980;

select a.consid, a.event
from events a
where a.consid != 167
group by a.consid, a.event
having (count(*) > 1);

select count(*) from events a
inner join constituents b on a.consid = b.id
where a.level in ('Gold','Platinum');

select a.id, b.email, count(a.id) as dupecount
from orgs a 
inner join constituents b on a.id = b.id
group by a.id, b.email
having (count(a.id) > 4);
