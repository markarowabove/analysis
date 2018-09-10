use fww;

-- alter table queries
alter table sources alter column C4_Date_Joined__c date;
alter table sources alter column C3_Date_Joined__c date;
alter table sources alter column CreatedDate date;
alter table sources add JoinedDate date;
alter table sources alter column total_combined_credits_lifetime__c float not null;
alter table sources alter column total_hard_credits_lifetime__c float not null;
alter table sources alter column total_soft_credits_lifetime__c float not null;
--================== UPDATE QUERIES ===============
update sources set C4_Date_Joined__c = null where C4_Date_Joined__c = '1900-01-01';
update sources set C3_Date_Joined__c = null where C3_Date_Joined__c = '1900-01-01';
-- populate the JoinedDate column
--select count(*) from sources where CreatedDate is null; -- 0
--select count(*) from sources where C3_Date_Joined__c is null and C4_Date_Joined__c is not null; -- 42,689
--select count(*) from sources where C3_Date_Joined__c is not null and C4_Date_Joined__c is null; -- 1,706,450
--select count(*) from sources where C3_Date_Joined__c is null and C4_Date_Joined__c is null; -- 252.748
-- find earliest date between these three dates: CreatedDate, C3_Date_Joined__c, C4_Date_Joined__c
update sources
set 
JoinedDate =
		case
			when CreatedDate < C3_Date_Joined__c and CreatedDate < C4_Date_Joined__c and C3_Date_Joined__c < C4_Date_Joined__c then CreatedDate
			when CreatedDate < C4_Date_Joined__c and CreatedDate < C3_Date_Joined__c and C4_Date_Joined__c < C3_Date_Joined__c then CreatedDate
			when C3_Date_Joined__c < CreatedDate and C3_Date_Joined__c < C4_Date_Joined__c and CreatedDate < C4_Date_Joined__c then C3_Date_Joined__c
			when C3_Date_Joined__c < C4_Date_Joined__c and C3_Date_Joined__c < CreatedDate and C4_Date_Joined__c < CreatedDate then C3_Date_Joined__c
			when C4_Date_Joined__c < CreatedDate and C4_Date_Joined__c < C3_Date_Joined__c and CreatedDate < C3_Date_Joined__c then C4_Date_Joined__c
			when C4_Date_Joined__c < C3_Date_Joined__c and C4_Date_Joined__c < CreatedDate and C3_Date_Joined__c < CreatedDate then C4_Date_Joined__c
			else CreatedDate
		end
where 1 = 1
	and CreatedDate is not null
	and C3_Date_Joined__c is not null
	and C4_Date_Joined__c is not null;

update sources set 
--select CreatedDate, C4_Date_Joined__c,
JoinedDate =
		case
			when CreatedDate < C4_Date_Joined__c then CreatedDate
			when C4_Date_Joined__c < CreatedDate then C4_Date_Joined__c
			else CreatedDate
		end
--from sources
where 1 = 1
	and CreatedDate is not null
	and C3_Date_Joined__c is null
	and C4_Date_Joined__c is not null;

update sources set 
--select CreatedDate, C4_Date_Joined__c,
JoinedDate =
		case
			when CreatedDate < C3_Date_Joined__c then CreatedDate
			when C3_Date_Joined__c < CreatedDate then C3_Date_Joined__c
			else CreatedDate
		end
--from sources
where 1 = 1
	and CreatedDate is not null
	and C3_Date_Joined__c is not null
	and C4_Date_Joined__c is null;

update sources set 
--select CreatedDate, C4_Date_Joined__c,
JoinedDate = CreatedDate
--from sources
where 1 = 1
	and CreatedDate is not null
	and C3_Date_Joined__c is null
	and C4_Date_Joined__c is null;
--================== UPDATE QUERIES ===============

-- this should be zero
select count(*) from sources where JoinedDate is null;
-- make sure JoinedDate is the least recent date
select JoinedDate, CreatedDate, C3_Date_Joined__c, C4_Date_Joined__c 
from sources
where 1 = 1
	and (JoinedDate <= CreatedDate 
	or JoinedDate <= C3_Date_Joined__c 
	or JoinedDate <= C4_Date_Joined__c);

-- sources
select count(*) from sources where JoinedDate is not null;

-- dupe check
select id, count(*) as dupes
from sources
group by id
having (count(*) > 1);

-- source code channel summary
-- Origin_Source_Code_Channel__c	count
-- n/a	2450679
-- List Growth	73529
-- Online Organizing	14191
-- Organic (default)	4067
-- FWW Website	1010
-- Distributed Organizing	615
-- Online Advertising	486
-- FWA Website	334
-- Social Media	266
-- Offline	213
-- Integrated channels	14
select Origin_Source_Code_Channel__c, count(*) as count
from sources
group by Origin_Source_Code_Channel__c
order by count(*) desc;

-- source code type summary
--44
-- top 10
-- Origin_Source_Code_Type__c	count
-- n/a	2442994
-- Revolution	31663
-- Daily Kos (paid)	20390
-- Partner share	18158
-- Email	12187
-- Organic	4441
-- MoveOn	3021
-- Instagram	2523
-- Mobile Com	1894
-- Medium	1300
select Origin_Source_Code_Type__c, count(*) as count
from sources
group by Origin_Source_Code_Type__c
order by count(*) desc;

select *
from sources
where 1 = 1
	and Origin_Source_Code_Channel__c = 'Distributed Organizing'
	and Origin_Source_Code_Type__c = 'Email'
;
-- source channel and type summary
select Origin_Source_Code_Channel__c, Origin_Source_Code_Type__c, count(*) as count
from sources
where 1 = 1
--	and Origin_Source_Code_Channel__c = 'Distributed Organizing'
--	and Origin_Source_Code_Type__c = 'Email'
group by Origin_Source_Code_Channel__c, Origin_Source_Code_Type__c
order by Origin_Source_Code_Channel__c;

-- join date analysis
select C3_Date_Joined__c
	, C4_Date_Joined__c 
from sources
where 1 = 1 
	and C3_Date_Joined__c is not null
	and C4_Date_Joined__c is not null
order by C3_Date_Joined__c;

