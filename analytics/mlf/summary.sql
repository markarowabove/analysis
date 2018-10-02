use mlf;

set nocount on

--select * from opportunities where namekey = 'DrewDavis' order by credit; -- 5259
--select id, amount, closedate from sf_opportunities where namekey = 'DrewDavis'order by amount;
--select count(*) from sf_opportunities; -- 112,790
--select count(*) from opportunities; -- 5,259
-- QB/SF Oppportunities -- 3,596
-- SF Oppportunities not in QB -- 95,498
-- QB Opportunities not in SF -- 2,326
-- select * from opportunities where id = 4954;
-- select * from sf_opportunities where namekey like '%AGlimmerofHopeFoundation%';

-- get QB Oppportunities
select b.id
	, b.name
	, b.namekey
	, b.credit
	, b.debit
	, b.date
from opportunities b
order by b.namekey
	, b.date;

-- get SF Opportunities
select a.id
	, a.name
	, a.namekey
	, a.amount
	, a.closedate
from sf_opportunities a
order by a.namekey
	, a.closedate;

-- get QB Oppportunities in SF
-- 3,601
select a.id
	, a.name
	, a.namekey
	, a.amount
	, a.closedate
	, b.id
	, b.name
	, b.namekey
	, b.credit
	, b.debit
	, b.date
from sf_opportunities a
inner join opportunities b on a.namekey = b.namekey
where 1 = 1
	and a.closedate = b.date
order by a.namekey;

-- get Sf Oppportunities not in QB
-- 95,485
select a.id
	, a.name
	, a.amount
	, a.closedate
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
	, b.date
	, b.namekey
from sf_opportunities a
right join opportunities b on a.namekey = b.namekey
where 1 = 1
	and a.namekey is null
order by b.namekey;
