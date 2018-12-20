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
-- select * from sf_opportunities where id = '0061Y00000mOSMfQAO';
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
	, b.fund
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
order by a.closedate;

/****
-- namekey temp table
if (object_id('tempdb..#namekeys') is not null) begin drop table #namekeys end;
create table #namekeys (
	id int,
	namekey nvarchar(255),
	date date,
	amount float
); 
insert into #namekeys (id, namekey, date, amount)
	select b.QBID as id, rtrim(b.QBKeyName1) as namekey, a.date, floor(a.credit) as amount
	from opportunities a
	inner join qb_namekeys b on a.id = b.qbid
	where b.QBKeyName1 != '' 
	union
	select b.QBID as id, rtrim(b.QBKeyName2) as namekey, a.date, floor(a.credit) as amount
	from opportunities a
	inner join qb_namekeys b on a.id = b.qbid
	where b.QBKeyName2 != ''
	union
	select b.QBID as id, rtrim(b.QBKeyName3) as namekey, a.date, floor(a.credit) as amount
	from opportunities a
	inner join qb_namekeys b on a.id = b.qbid
	where b.QBKeyName3 != ''
	union
	select b.QBID as id, rtrim(b.QBKeyName4) as namekey, a.date, floor(a.credit) as amount
	from opportunities a
	inner join qb_namekeys b on a.id = b.qbid
	where b.QBKeyName4 != ''

select * from #namekeys where id = 564 order by namekey;
select * from qb_namekeys order by qbkeyname1;
****/

-- get QB Oppportunities in SF
-- 2795
/****
select * from qb_namekeys where qbkeyname1 like '%CalvinHagood%' order by qbkeyname1;
select * from #namekeys where namekey like '%Hagood%';
select * from opportunities where id = 1650;
select id, date, credit, namekey from opportunities where namekey like '%Gavila%' order by date;--CalvinandElizabethHagood
select id, closedate, amount, namekey from sf_opportunities where name like '%Gavila%' order by closedate; --CalvinHagood
select date, credit, namekey from opportunities where name like '%Gavila%';
select closedate, amount, namekey from sf_opportunities where name like '%Merkel%'; --9
***/
/*****
if (object_id('tempdb..#qbids') is not null) begin drop table #qbids end;
select a.*
--into #qbids 
from sf_opportunities a
inner join #namekeys b on a.namekey = b.namekey 
	--and a.date = b.closedate 
	--and a.amount = b.amount
where 1 = 1
	and a.namekey = 'AaronGavila'
order by a.namekey;
--select * from #qbids;
****/
-- 3728
if (object_id('tempdb..#qbsf0') is not null) begin drop table #qbsf0 end;
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
	, b.fund as QBFund
	, c.Id as SFFundId
into #qbsf0
from sf_opportunities a
inner join opportunities b on a.namekey = b.namekey
inner join sf_funds c on b.fund = c.name
where 1 = 1
	and a.closedate = b.date
	and a.closedate >= '2018-01-01'
	and a.closedate < '2018-10-01'
	and a.amount = floor(b.credit)
order by a.closedate;
-- display records
--select * from #qbsf0 where sfnamekey = 'CharlesHunter' order by SFCloseDate;
--select * from #qbsf0 where sfid = '0061Y00000mOXoBQAW';

if (object_id('tempdb..#qbsf1') is not null) begin drop table #qbsf1 end;
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
	, b.fund as QBFund
	, d.Id as SFFundId
into #qbsf1
from sf_opportunities a
inner join qb_namekeys c on a.namekey = c.qbkeyname1
inner join opportunities b on c.qbid = b.id
inner join sf_funds d on b.fund = d.name
where 1 = 1
	and a.closedate = b.date
	and a.closedate >= '2018-01-01'
	and a.closedate < '2018-10-01'
	and a.amount = floor(b.credit)
order by a.closedate;
--select * from #qbsf1 where sfnamekey = 'CharlesHunter' order by SFCloseDate;
--select * from sf_opportunities where id = '0061Y00000mOXoBQAW';
--select * from qb_namekeys where qbkeyname1 like '%ConniesCarwashNewMiniStorage%'
--select * from qb_namekeys where qbkeyname2 like '%ConniesCarwashNewMiniStorage%'
--select * from qb_namekeys where qbkeyname3 like '%ConniesCarwashNewMiniStorage%'
--select * from qb_namekeys where qbkeyname4 like '%ConniesCarwashNewMiniStorage%'

if (object_id('tempdb..#qbsf2') is not null) begin drop table #qbsf2 end;
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
	, b.fund as QBFund
	, d.Id as SFFundId
into #qbsf2
from sf_opportunities a
inner join qb_namekeys c on a.namekey = c.qbkeyname2
inner join opportunities b on c.qbid = b.id
inner join sf_funds d on b.fund = d.name
where 1 = 1
	and a.closedate = b.date
	and a.closedate >= '2018-01-01'
	and a.closedate < '2018-10-01'
	and a.amount = floor(b.credit)
order by a.closedate;
--select * from #qbsf2 where sfnamekey = 'CharlesHunter' order by SFCloseDate;
--select * from #qbsf2 where sfid = '0061Y00000mOXoBQAW';

if (object_id('tempdb..#qbsf3') is not null) begin drop table #qbsf3 end;
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
	, b.fund as QBFund
	, d.Id as SFFundId
into #qbsf3
from sf_opportunities a
inner join qb_namekeys c on a.namekey = c.qbkeyname3
inner join opportunities b on c.qbid = b.id
inner join sf_funds d on b.fund = d.name
where 1 = 1
	and a.closedate = b.date
	and a.closedate >= '2018-01-01'
	and a.closedate < '2018-10-01'
	and a.amount = floor(b.credit)
order by a.closedate;
--select * from #qbsf3 where sfnamekey = 'CharlesHunter' order by SFCloseDate;
--select * from #qbsf3 where sfid = '0061Y00000mOXoBQAW';

if (object_id('tempdb..#qbsf4') is not null) begin drop table #qbsf4 end;
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
	, b.fund as QBFund
	, d.Id as SFFundId
into #qbsf4
from sf_opportunities a
inner join qb_namekeys c on a.namekey = c.qbkeyname4
inner join opportunities b on c.qbid = b.id
inner join sf_funds d on b.fund = d.name
where 1 = 1
	and a.closedate = b.date
	and a.closedate >= '2018-01-01'
	and a.closedate < '2018-10-01'
	and a.amount = floor(b.credit)
order by a.closedate;
--select * from #qbsf4 where sfnamekey = 'CharlesHunter' order by SFCloseDate;
--select * from #qbsf4 where sfid = '0061Y00000mOXoBQAW';

if (object_id('tempdb..#qbsf') is not null) begin drop table #qbsf end;
select * into #qbsf from (
	select * from #qbsf0
	union
	select * from #qbsf1
	union
	select * from #qbsf2
	union
	select * from #qbsf3
	union
	select * from #qbsf4
) u;
--select * from #qbsf order by sfclosedate; -- 4942

-- test queries
-- select * from #qbsf where sfid = '0061Y00000l2fjdQAA';
-- select * from sf_opportunities where id = '0061Y00000l2fjdQAA';
-- select * from sf_opportunities where namekey = 'WaylonWalker';
-- select * from qb_namekeys where qbkeyname1 = 'WaylonWalker';
-- select * from opportunities where name like '%Waylon%';
-- select * from opportunities where namekey = 'BarryRouch' order by date;
-- select * from sf_opportunities where namekey = 'BarryRouch';
/**
--1490
select a.* 
from mlf_donations_reconciled a
left join #qbsf b on a.sfid = b.sfid
where b.sfid is null
order by a.date;
select * from sf_opportunities where id = '0061Y00000mOXoBQAW';
select * from mlf_donations_reconciled where sfid = '0061Y00000mOXoBQAW';
select * from #qbsf where sfid = '0061Y00000mOXoBQAW';
**/

-- check for dupes
/****
select SFID, count(*) as count
from #qbsf
group by SFID
having (count(*) > 1);
****/

-- get Sf Oppportunities not in QB
-- 5659
--select count(*) from sf_opportunities;--10309
--select count(*) from #qbsf;            --3728
--select count(*) from opportunities;    --7751
-- 6658
select a.id
	, a.name
	, a.namekey
	, a.amount
	, a.closedate
	, a.CampaignId 
	, a.stayclassy__Anonymous_Donor__c
	, a.Designation__c
--into #sfnotqb1
from sf_opportunities a
left join #qbsf b on a.id = b.sfid
where 1 = 1 
	and a.closedate >= '2018-01-01'
	and a.closedate < '2018-10-01'
	and a.id not in (select SFID from #qbsf)
	and b.sfid is null
order by a.namekey;
--select * from #sfnotqb1 order by namekey;

-- get QB Opportunities not in SF
-- 4115
select a.id
	, a.name
	, a.namekey
	, a.credit
	, a.date
	, a.type
	, a.fund
	, c.Id
from opportunities a
left join #qbsf b on a.id = b.qbid
inner join sf_funds c on a.fund = c.name
where 1 = 1
	and a.date >= '2018-01-01'
	and a.date < '2018-10-01'
	and b.qbid is null
	and a.id not in (select QBID from #qbsf)
order by a.namekey;