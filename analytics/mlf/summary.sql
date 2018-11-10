use mlf;

set nocount on

--select * from opportunities where namekey = 'DrewDavis' order by credit; -- 5259
--select id, amount, closedate from sf_opportunities where namekey = 'DrewDavis'order by amount;
--select count(*) from sf_opportunities; -- 112,790
--select count(*) from opportunities; -- 5,259
-- QB/SF Oppportunities -- 3,596
-- SF Oppportunities not in QB -- 95,498
-- QB Opportunities not in SF -- 2,326
-- select * from opportunities order by date, name, credit;
-- select * from sf_opportunities where namekey like '%AGlimmerofHopeFoundation%';
--select type, count(*)
--from opportunities 
--group by type
--order by count(*);
--select top 100 * from opportunities where type = 'General Journal';

-- get QB Oppportunities
-- 7751
select b.id
	, b.name
	, b.namekey
	, b.credit
	, b.debit
	, b.date
	, b.type
from opportunities b
--where b.type in ('Sales Receipt','General Journal')
order by b.namekey
	, b.date;

-- get SF Opportunities
-- 10309
select a.id
	, a.name
	, a.namekey
	, a.amount
	, a.closedate
	, a.stayclassy__Anonymous_Donor__c
	, a.CampaignId
from sf_opportunities a
where a.closedate >= '2018-01-01'
	and a.closedate < '2018-10-01'
order by a.namekey
	, a.closedate;

-- namekey temp table
if (object_id('tempdb..#namekeys') is not null) begin drop table #namekeys end;
select * into #namekeys from (
	select b.QBID, b.QBKeyName1 as namekey
	from opportunities a
	inner join qb_namekeys b on a.id = b.qbid
	where b.QBKeyName1 != ''
	union
	select b.QBID, b.QBKeyName2 as namekey
	from opportunities a
	inner join qb_namekeys b on a.id = b.qbid
	where b.QBKeyName2 != ''
	union
	select b.QBID, b.QBKeyName3 as namekey
	from opportunities a
	inner join qb_namekeys b on a.id = b.qbid
	where b.QBKeyName3 != ''
	union
	select b.QBID, b.QBKeyName4 as namekey
	from opportunities a
	inner join qb_namekeys b on a.id = b.qbid
	where b.QBKeyName4 != ''
) nk;
--select * from #namekeys

-- get QB Oppportunities in SF
-- 2795

if (object_id('tempdb..#qbsf') is not null) begin drop table #qbsf end;
select a.id as SFID
	, a.name as SFName
	, a.namekey as SFNameKey
	, a.amount as SFAmount
	, a.closedate as SFCloseDate
	, a.CampaignId as SFCampaignId
	, a.stayclassy__Anonymous_Donor__c as SFClassyAnonymous
	, a.Designation__c as SFDesignation
	, b.id as QBID
	, b.name as QBName
	, b.namekey as QBNameKey
	, b.credit as QBCredit
	, b.date as QBDate
	, b.type as QBType
into #qbsf
from sf_opportunities a
inner join #namekeys c on a.namekey = c.namekey
inner join opportunities b on c.qbid = b.id
where 1 = 1
	and a.closedate = b.date
	and a.closedate >= '2018-01-01'
	and a.closedate < '2018-10-01'
	and a.amount = b.credit
order by a.closedate;
		
-- display records
select * from #qbsf order by QBID;

-- test queries
-- select * from #qbsf where sfid = '0061Y00000l2fjdQAA';
-- select * from sf_opportunities where id = '0061Y00000l2fjdQAA';
-- select * from qb_namekeys where qbkeyname1 = 'WaylonWalker';
-- select * from opportunities where name like '%Waylon%';
-- select * from opportunities where namekey = 'BarryRouch' order by date;
-- select * from sf_opportunities where namekey = 'BarryRouch';
-- check for dupes
/****
select SFID, count(*) as count
from #qbsf
group by SFID
having (count(*) > 1);
****/

-- get Sf Oppportunities not in QB
-- 5659
select a.id
	, a.name
	, a.namekey
	, a.amount
	, a.closedate
	, a.CampaignId 
	, a.stayclassy__Anonymous_Donor__c
	, a.Designation__c
from sf_opportunities a
left join opportunities b on a.namekey = b.namekey
where 1 = 1
	and a.closedate >= '2018-01-01'
	and a.closedate < '2018-10-01'
	and b.namekey is null
	and a.id not in (select SFID from #qbsf)
order by a.namekey;

-- get QB Opportunities not in SF
-- 3488
select b.id
	, b.name
	, b.namekey
	, b.credit
	, b.date
	, b.type
from sf_opportunities a
right join opportunities b on a.namekey = b.namekey
where 1 = 1
	--and a.closedate >= '2018-01-01'
	--and a.closedate <= '2018-06-30'
	and a.namekey is null
	and b.id not in (select QBID from #qbsf)
order by b.namekey;