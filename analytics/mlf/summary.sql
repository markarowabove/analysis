use mlf;

set nocount on

--select * from opportunities where namekey = 'DrewDavis' order by credit; -- 5259
--select id, amount, closedate from sf_opportunities where namekey = 'DrewDavis'order by amount;

-- get QB Oppportunities in SF
-- 3,596
select a.id
	, a.name
	, a.namekey
	, b.id
	, b.name
	, b.namekey
from sf_opportunities a
inner join opportunities b on a.namekey = b.namekey
where 1 = 1
	and a.closedate = b.date
--	and a.namekey = 'DrewDavis'
order by a.namekey;

-- get Sf Oppportunities not in QB
-- 95,498
select a.id
	, a.name
	, a.amount
	, a.namekey
from sf_opportunities a
left join opportunities b on a.namekey = b.namekey
where 1 = 1
	and b.namekey is null
order by a.namekey;

-- get QB Opportunities not in SF
-- 2,326
select b.id
	, b.name
	, b.credit
	, b.namekey
from sf_opportunities a
right join opportunities b on a.namekey = b.namekey
where 1 = 1
	and a.namekey is null
order by b.namekey;
