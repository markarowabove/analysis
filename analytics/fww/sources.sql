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
select count(*) from sources; -- 2,545,404
select count(*) from sources where JoinedDate is not null; -- 2,545,404
select count(*) from sources where JoinedDate is null; -- 0

-- dupe check -- 0
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
--Origin_Source_Code_Channel__c,Origin_Source_Code_Type__c,count
--Distributed Organizing,Email,26
--Distributed Organizing,Partner,3
--Distributed Organizing,Other,7
--Distributed Organizing,Relay,579
--FWA Website,Other,221
--FWA Website,News piece,33
--FWA Website,Donate Button,28
--FWA Website,Front page,35
--FWA Website,Call out,1
--FWA Website,Blog/other,16
--FWW Website,News piece,309
--FWW Website,Call out,2
--FWW Website,Front page,9
--FWW Website,Blog/other,110
--FWW Website,Donate Button,54
--FWW Website,Other,526
--Integrated channels,Youtube,3
--Integrated channels,Other,1
--Integrated channels,DM,10
--List Growth,FB,273
--List Growth,MoveOn,2947
--List Growth,Partner share,18017
--List Growth,Revolution,31663
--List Growth,Daily Kos (paid),20390
--List Growth,ShareProg,239
--n/a,LinkedIn,560
--n/a,Partner share,141
--n/a,AddThis,1032
--n/a,Pinterest,2
--n/a,FB,3
--n/a,Event,17
--n/a,Scrollbox,43
--n/a,LeftAction,36
--n/a,Mobile Com,5
--n/a,Change.org,168
--n/a,Instagram,2523
--n/a,Vimeo,8
--n/a,Care2,2
--n/a,Relay,596
--n/a,Coalition,7
--n/a,ShareProg,109
--n/a,Other,77
--n/a,Twitter,14
--n/a,Perfect Audience,28
--n/a,Medium,1300
--n/a,Organic,393
--n/a,Dems.com,1
--n/a,Flyer,2
--n/a,Newsletter,27
--n/a,TBTT,2
--n/a,Email,9
--n/a,PressRelease,21
--n/a,Social Share,11
--n/a,Front page,38
--n/a,Action Network,318
--n/a,MoveOn,74
--n/a,FB TAF,3
--n/a,Call out,69
--n/a,Partner,32
--n/a,Adword,1
--n/a,After Action,93
--n/a,n/a,2442909
--n/a,DM,5
--Offline,Other,1
--Offline,n/a,60
--Offline,Coalition,149
--Offline,Flyer,3
--Online Advertising,Other,2
--Online Advertising,n/a,6
--Online Advertising,FB,113
--Online Advertising,Perfect Audience,5
--Online Advertising,Adword,360
--Online Organizing,After Action,148
--Online Organizing,Mobile Com,1889
--Online Organizing,Other,2
--Online Organizing,Email,12152
--Organic (default),Organic,4048
--Organic (default),n/a,19
--Social Media,Twitter,64
--Social Media,FB,202
select Origin_Source_Code_Channel__c, Origin_Source_Code_Type__c, count(*) as count
from sources
where 1 = 1
--	and Origin_Source_Code_Channel__c = 'Distributed Organizing'
--	and Origin_Source_Code_Type__c = 'Email'
group by Origin_Source_Code_Channel__c, Origin_Source_Code_Type__c
order by Origin_Source_Code_Channel__c;

-- joined date analysis after all of the update work from above
select C3_Date_Joined__c
	, C4_Date_Joined__c 
from sources
where 1 = 1 
	and C3_Date_Joined__c is not null
	and C4_Date_Joined__c is not null
order by C3_Date_Joined__c;

-- check for the records with the two dates the same -- 133,162
select C3_Date_Joined__c
	, C4_Date_Joined__c 
from sources
where 1 = 1 
	and C3_Date_Joined__c = C4_Date_Joined__c
order by C3_Date_Joined__c;
