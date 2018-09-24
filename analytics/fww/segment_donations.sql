use fww;

set nocount on

/*********** OPPORTUNITIES SEGMENTS ***********/
-- segment 1: 0 - 91 days (0 - 3 months)
-- segment 2: 92 - 183 days (3 - 6 months)
-- segment 3: 184 - 275 days (6 - 9 months)
-- segment 4: 276 - 367 days (9 - 12 months)
-- segment 5: 368 - 733 days (12 - 24 months)
-- segment 6: 734 - 1098 (12 - 36 months)
-- segment 7: 1099+ (36+ months)
-- segments
-- 2017-09-14, 2017-12-13, 2018-03-13, 2018-06-11, 2018-09-09
/***
select dateadd(day,-@segmentdaycount*12,getdate()) as "segment6 - 36 months"
	, dateadd(day,-@segmentdaycount*8,getdate()) as "segment5 - 24 months"
	, dateadd(day,-@segmentdaycount*4,getdate()) as "segment4 - 9 to 12 months"
	, dateadd(day,-@segmentdaycount*3,getdate()) as "segment3 - 6 to 9 months"
	, dateadd(day,-@segmentdaycount*2,getdate()) as "segment2 - 3 to 6 months"
	, dateadd(day,-@segmentdaycount,getdate()) as "segment1 - 0 to 3 months"
	, getdate() as today;
***/

declare @segmentcountmax int
declare @segmentcount int
declare @segmentdaycount int

set @segmentdaycount = 91; -- 365 days / 4 = 91.25

-- last 0 to 91 days - 3 months
if (object_id('tempdb..#segment1') is not null) begin drop table #segment1 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
--	, b.Id as opportunityId
--	, b.closedate as recorddate
	, b.npsp__Primary_Contact__c as contactid
	, active = case
		when c.giftdate is not null then 1
		else 0
	end
	, '1' as segment
	, '1' as recordtype
into #segment1 
from sources a
inner join opportunities b on a.id = b.npsp__Primary_Contact__c
left join donors_new c on b.id = c.opportunityid
where datediff(day,a.joineddate,b.closedate) <= @segmentdaycount;
-- select count(*) from #segment1; --270,527
-- select * from #segment1 order by channel, type, amount;
--select * from opportunities where id = '0066A0000058kH4QAI';
--select * from donors_new where contactid = '0036A00000MsZa8QAF'; -- 2012-12-12

--declare @segmentdaycount int
--set @segmentdaycount = 91;
-- last 91 to 182 days - 3 to 6 months
if (object_id('tempdb..#segment2') is not null) begin drop table #segment2 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
--	, b.Id as opportunityId
--	, b.closedate as recorddate
	, b.npsp__Primary_Contact__c as contactid
	, active = case
		when c.giftdate is not null then 1
		else 0
	end
	, '2' as segment
	, '1' as recordtype
into #segment2 
from sources a
inner join opportunities b on a.id = b.npsp__Primary_Contact__c
left join donors_new c on b.id = c.opportunityid
where datediff(day,a.joineddate,b.closedate) > @segmentdaycount and datediff(day,a.joineddate,b.closedate) <= @segmentdaycount*2;
-- select count(*) from #segment2; -- 28,728
-- select * from #segment2;
/****
select a.*, b.* 
from #segment2 a
inner join donors_new b on a.contactid = b.contactid
order by b.contactid; -- 28,728
****/

-- last 183 to 273 days - 6 to 9 months
if (object_id('tempdb..#segment3') is not null) begin drop table #segment3 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
--	, b.Id as opportunityId
--	, b.closedate as recorddate
	, b.npsp__Primary_Contact__c as contactid
	, active = case
		when c.giftdate is not null then 1
		else 0
	end
	, '3' as segment
	, '1' as recordtype
into #segment3 
from sources a
inner join opportunities b on a.id = b.npsp__Primary_Contact__c
left join donors_new c on b.id = c.opportunityid
where datediff(day,a.joineddate,b.closedate) > @segmentdaycount*2 and datediff(day,a.joineddate,b.closedate) <= @segmentdaycount*3;
-- select count(*) from #segment3; -- 27,375
/****
select a.*, b.* 
from #segment3 a
inner join donors_new b on a.contactid = b.contactid
order by b.contactid; -- 27,375
****/

-- last 274 to 364 days - 9 to 12 months
if (object_id('tempdb..#segment4') is not null) begin drop table #segment4 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
--	, b.Id as opportunityId
--	, b.closedate as recorddate
	, b.npsp__Primary_Contact__c as contactid
	, active = case
		when c.giftdate is not null then 1
		else 0
	end
	, '4' as segment
	, '1' as recordtype
into #segment4 
from sources a
inner join opportunities b on a.id = b.npsp__Primary_Contact__c
left join donors_new c on b.id = c.opportunityid
where datediff(day,a.joineddate,b.closedate) > @segmentdaycount*3 and datediff(day,a.joineddate,b.closedate) <= @segmentdaycount*4;
-- select count(*) from #segment4; -- 27,109
/****
select a.*, b.* 
from #segment4 a
inner join donors_new b on a.contactid = b.contactid
where datediff(day,a.joineddate,b.closedate) > @segmentdaycount*3 and datediff(day,a.joineddate,b.closedate) <= @segmentdaycount*4;
order by b.contactid; -- 28,728
****/

-- last 365 to 730 days - 12 to 24 months
if (object_id('tempdb..#segment5') is not null) begin drop table #segment5 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
--	, b.Id as opportunityId
--	, b.closedate as recorddate
	, b.npsp__Primary_Contact__c as contactid
	, active = case
		when c.giftdate is not null then 1
		else 0
	end
	, '5' as segment
	, '1' as recordtype
into #segment5
from sources a
inner join opportunities b on a.id = b.npsp__Primary_Contact__c
left join donors_new c on b.id = c.opportunityid
where datediff(day,a.joineddate,b.closedate) > @segmentdaycount*4 and datediff(day,a.joineddate,b.closedate) <= @segmentdaycount*8;
-- select * from #segment5 order by joineddate;
/****
select a.*, b.* 
from #segment5 a
inner join donors_new b on a.contactid = b.contactid
order by b.contactid; -- 28,728
****/

-- last 731 to 1,095 days - 24 to 36 months
if (object_id('tempdb..#segment6') is not null) begin drop table #segment6 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
--	, b.Id as opportunityId
--	, b.closedate as recorddate
	, b.npsp__Primary_Contact__c as contactid
	, active = case
		when c.giftdate is not null then 1
		else 0
	end
	, '6' as segment
	, '1' as recordtype
into #segment6
from sources a
inner join opportunities b on a.id = b.npsp__Primary_Contact__c
left join donors_new c on b.id = c.opportunityid
where datediff(day,a.joineddate,b.closedate) > @segmentdaycount*8 and datediff(day,a.joineddate,b.closedate) <= @segmentdaycount*12;
-- select * from #segment6 order by joineddate;
/****
select a.*, b.* 
from #segment6 a
inner join donors_new b on a.contactid = b.contactid
order by b.contactid; -- 28,728
****/

-- over 1,095 - over 36 months
--declare @segmentdaycount int
--set @segmentdaycount = 91;
if (object_id('tempdb..#segment7') is not null) begin drop table #segment7 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
--	, b.Id as opportunityId
--	, b.closedate as recorddate
	, b.npsp__Primary_Contact__c as contactid
	, active = case
		when c.giftdate is not null then 1
		else 0
	end
	, '7' as segment
	, '1' as recordtype
into #segment7 
from sources a
inner join opportunities b on a.id = b.npsp__Primary_Contact__c
left join donors_new c on b.id = c.opportunityid
where datediff(day,a.joineddate,b.closedate) > @segmentdaycount*12;
-- select * from #segment7 where opportunityid = '0066A0000058uRlQAI' order by id;
-- select datediff(day,'2011-07-20','2017-03-17'); -- 2067
--select * from opportunities where id = '0066A0000058uRlQAI';
/****
select a.*, b.* 
from #segment7 a
inner join donors_new b on a.contactid = b.contactid
order by b.contactid; -- 28,728
****/

-- within the last year
/*****
if (object_id('tempdb..#segment8') is not null) begin drop table #segment8 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
	, b.Id as opportunityId
	, '8' as segment
into #segment8 
from sources a
inner join opportunities b on a.id = b.npsp__Primary_Contact__c
where datediff(day,a.joineddate,b.closedate) <= 365;
-- select * from #segment8 order by id;
****/
-- 686,638
select * from #segment1
union all
select * from #segment2
union all
select * from #segment3
union all
select * from #segment4
union all
select * from #segment5
union all
select * from #segment6
union all
select * from #segment7
--order by firstgift desc, segment, channel, type, amount;
order by segment, channel, type, amount;

set nocount off

--select * from opportunities where npsp__Primary_Contact__c = '0036A00000KBkpVQAT' order by closedate;
--select * from donors_new where contactid = '0036A00000KBkpVQAT';