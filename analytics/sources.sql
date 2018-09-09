use fww;

-- alter table queries
alter table sources alter column C4_Date_Joined__c date;
alter table sources alter column C3_Date_Joined__c date;
alter table sources alter column total_combined_credits_lifetime__c float not null;
alter table sources alter column total_hard_credits_lifetime__c float not null;
alter table sources alter column total_soft_credits_lifetime__c float not null;
update sources set C4_Date_Joined__c = null where C4_Date_Joined__c = '1900-01-01';
update sources set C3_Date_Joined__c = null where C3_Date_Joined__c = '1900-01-01';

-- sources
select count(*) from sources;

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
order by C3_Date_Joined__c;

