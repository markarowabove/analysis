use fww;

set nocount on

declare @segmentcountmax int
declare @segmentcount int
declare @segmentdaycount int
declare @startdate date

set @startdate = getdate()
set @segmentdaycount = 91; -- 365 days / 4 = 91.25

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

-- last 0 to 91 days - 3 months
if (object_id('tempdb..#segment1') is not null) begin drop table #segment1 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
--	, b.Id as opportunityId
--	, a.joineddate
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
where datediff(day,a.joineddate,@startdate) <= @segmentdaycount;
--select count(*) from #segment1; -- 4,355
--select datediff(day,joineddate,getdate()), channel, type, amount, recorddate, joineddate, contactid, active, segment, recordtype from #segment1 order by channel, type, contactid;
--select * from #segment1 order by joineddate, channel, type, amount;
--select * from opportunities where id = '0066A0000058kH4QAI';
--select * from donors_new where contactid = '0036A00000MsZa8QAF'; -- 2012-12-12
--select * from #segment1 where channel = 'Distributed Organizing' and type = 'Relay' order by amount, contactid, recorddate, active;
--select distinct contactid from #segment1 where channel = 'Distributed Organizing' and type = 'Relay';
--select distinct contactid from #segment1 where channel = 'Distributed Organizing' and type = 'Relay' and active = 1;
--select active from #segment1 where channel = 'Distributed Organizing' and type = 'Relay' order by active;
--select * from #segment1 where contactid = '0036A00000MxTzuQAF' order by recorddate;
--select count(*) from #segment1 where channel = 'Distributed Organizing' and type = 'Relay' and active = 1;
--select contactid, count(*)
--from #segment1
--where channel = 'Distributed Organizing' and type = 'Relay'
--group by contactid
--having (count(*) > 1)
--order by count(*) desc;

-- last 91 to 182 days - 3 to 6 months
if (object_id('tempdb..#segment2') is not null) begin drop table #segment2 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
--	, b.Id as opportunityId
--	, a.joineddate
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
where datediff(day,a.joineddate,@startdate) > @segmentdaycount and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*2;
-- select * from #segment2; -- 3,847
-- select datediff(day,joineddate,getdate()), channel, type, amount, recorddate, joineddate, contactid, active, segment, recordtype from #segment2 order by channel, type, joineddate;

-- last 183 to 273 days - 6 to 9 months
if (object_id('tempdb..#segment3') is not null) begin drop table #segment3 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
--	, b.Id as opportunityId
--	, a.joineddate
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
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*2 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*3;
-- select count(*) from #segment3; -- 3,790
-- select datediff(day,joineddate,getdate()), channel, type, amount, recorddate, joineddate, contactid, active, segment, recordtype from #segment3 order by joineddate, channel, type;
--select * from #segment3 order by type;

-- last 274 to 364 days - 9 to 12 months
if (object_id('tempdb..#segment4') is not null) begin drop table #segment4 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
--	, b.Id as opportunityId
--	, a.joineddate
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
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*3 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*4;
-- select count(*) from #segment4; -- 4,238
-- select datediff(day,joineddate,getdate()), channel, type, amount, recorddate, joineddate, contactid, active, segment, recordtype from #segment4 order by joineddate, channel, type;

-- last 365 to 730 days - 12 to 24 months
if (object_id('tempdb..#segment5') is not null) begin drop table #segment5 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
--	, b.Id as opportunityId
--	, a.joineddate
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
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*4 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*8;
-- select * from #segment5 order by joineddate;
-- select datediff(day,joineddate,getdate()), channel, type, amount, recorddate, joineddate, contactid, active, segment, recordtype from #segment5 order by channel, type, joineddate;

-- last 731 to 1,095 days - 24 to 36 months
if (object_id('tempdb..#segment6') is not null) begin drop table #segment6 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
--	, b.Id as opportunityId
--	, a.joineddate
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
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*8 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*12;
-- select * from #segment6 order by joineddate;
-- select datediff(day,joineddate,getdate()), channel, type, amount, recorddate, joineddate, contactid, active, segment, recordtype from #segment6 order by joineddate, channel, type;

-- over 1,095 - over 36 months
--declare @segmentdaycount int
--set @segmentdaycount = 91;
if (object_id('tempdb..#segment7') is not null) begin drop table #segment7 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, b.Amount as amount
--	, b.Id as opportunityId
--	, a.joineddate
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
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*12;
-- select * from #segment7 where opportunityid = '0066A0000058uRlQAI' order by id;
-- select datediff(day,joineddate,getdate()), channel, type, amount, recorddate, joineddate, contactid, active, segment, recordtype from #segment7 order by joineddate, channel, type;

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