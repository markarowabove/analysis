use mlf;

/**
select substring(class, len(class) - charindex(':',reverse(class)) + 2,len(class)) from opportunities where id < 100;

select a.id, a.fund, b.id as sfid
from opportunities a 
inner join sf_funds b on a.fund = b.name
where a.class != '' 
order by a.id; -- 7751
**/

-- 7631
select a.class, a.fund, b.id, b.name
from opportunities a
inner join sf_funds b on a.fund = b.name
order by a.fund;

-- 2
--select * from opportunities where class = '';
select a.class, a.fund
from opportunities a
left join sf_funds b on a.fund = b.name
where b.name is null
order by a.fund;

-- 1
select distinct a.fund
from opportunities a
left join sf_funds b on a.fund = b.name
where b.name is null
order by a.fund;

