use fww;

set nocount on

declare @segmentdaycount int
declare @startdate date

set @startdate = getdate()
set @segmentdaycount = 91; -- 365 days / 4 = 91.25

/*********** ACTION SEGMENTS ***********/
-- segment 1: 0 - 91 days (0 - 3 months)
-- segment 2: 92 - 183 days (3 - 6 months)
-- segment 3: 184 - 275 days (6 - 9 months)
-- segment 4: 276 - 367 days (9 - 12 months)
-- segment 5: 368 - 733 days (12 - 24 months)
-- segment 6: 734 - 1098 (12 - 36 months)
-- segment 7: 1099+ (36+ months)
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
-- 1,396,639
if (object_id('tempdb..#actionsegment1') is not null) begin drop table #actionsegment1 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, '' as amount
	, a.JoinedDate
	, b.date_of_action__c as recorddate
	, b.contact__c as contactid
	, active = case
		when c.actiondate is not null then 1
		else 0
	end
	, '1' as segment
	, '2' as recordtype
into #actionsegment1 
from sources a
inner join actions b on b.contact__c = a.id
left join activists_new c on b.id = c.activityid
where datediff(day,a.joineddate,@startdate) <= @segmentdaycount;
-- select count(*) from #actionsegment1; -- 1,396,639
-- select top 100 * from #actionsegment1 where contactid = '0036A00000Mt3jLQAR' order by channel, type, amount;
--select * from opportunities where id = '0066A0000058kH4QAI';
--select * from donors_new where contactid = '0036A00000MsZa8QAF'; -- 2012-12-12
--select * from #actionsegment1 where channel = 'Distributed Organizing' and type = 'Relay' order by contactid, active, recorddate;
--select distinct contactid from #actionsegment1 where channel = 'Distributed Organizing' and type = 'Relay';
--select distinct contactid from #actionsegment1 where channel = 'Distributed Organizing' and type = 'Relay' and active = 1;
--select active from #actionsegment1 where channel = 'Distributed Organizing' and type = 'Relay' order by active;
--select * from #actionsegment1 where contactid = '0036A00000MxTzuQAF' order by recorddate;
--select count(*) from #actionsegment1 where channel = 'Distributed Organizing' and type = 'Relay' and active = 1;
--select contactid, count(*)
--from #actionsegment1
--where channel = 'Distributed Organizing' and type = 'Relay'
--group by contactid
--having (count(*) > 1)
--order by count(*) desc;
--declare @segmentdaycount int;
--set @segmentdaycount = 91;
-- 847,222
if (object_id('tempdb..#actionsegment2') is not null) begin drop table #actionsegment2 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, '' as amount
	, a.JoinedDate
	, b.date_of_action__c as recorddate
	, b.contact__c as contactid
	, active = case
		when c.actiondate is not null then 1
		else 0
	end
	, '2' as segment
	, '2' as recordtype
into #actionsegment2
from sources a
inner join actions b on b.contact__c = a.id
left join activists_new c on b.id = c.activityid
where datediff(day,a.joineddate,@startdate) > @segmentdaycount and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*2;
-- select top 100 * from #actionsegment2;

--declare @segmentdaycount int;
--set @segmentdaycount = 91;
-- 819,909
if (object_id('tempdb..#actionsegment3') is not null) begin drop table #actionsegment3 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, '' as amount
	, a.JoinedDate
	, b.date_of_action__c as recorddate
	, b.contact__c as contactid
	, active = case
		when c.actiondate is not null then 1
		else 0
	end
	, '3' as segment
	, '2' as recordtype
into #actionsegment3
from sources a
inner join actions b on b.contact__c = a.id
left join activists_new c on b.id = c.activityid
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*2 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*3;
-- select top 100 * from #actionsegment3;

--declare @segmentdaycount int;
--set @segmentdaycount = 91;
-- 722,559
if (object_id('tempdb..#actionsegment4') is not null) begin drop table #actionsegment4 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, '' as amount
	, a.JoinedDate
	, b.date_of_action__c as recorddate
	, b.contact__c as contactid
	, active = case
		when c.actiondate is not null then 1
		else 0
	end
	, '4' as segment
	, '2' as recordtype
into #actionsegment4
from sources a
inner join actions b on b.contact__c = a.id
left join activists_new c on b.id = c.activityid
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*3 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*4;
-- select top 100 * from #actionsegment4;

--declare @segmentdaycount int;
--set @segmentdaycount = 91;
-- 2,059,065
if (object_id('tempdb..#actionsegment5') is not null) begin drop table #actionsegment5 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, '' as amount
	, a.JoinedDate
	, b.date_of_action__c as recorddate
	, b.contact__c as contactid
	, active = case
		when c.actiondate is not null then 1
		else 0
	end
	, '5' as segment
	, '2' as recordtype
into #actionsegment5
from sources a
inner join actions b on b.contact__c = a.id
left join activists_new c on b.id = c.activityid
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*4 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*8;
-- select top 100 * from #actionsegment5 where contactid = '0036A00000KBa0CQAT' order by actiondate;

--declare @segmentdaycount int;
--set @segmentdaycount = 91;
-- 1,386,886
if (object_id('tempdb..#actionsegment6') is not null) begin drop table #actionsegment6 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, '' as amount
	, a.JoinedDate
	, b.date_of_action__c as recorddate
	, b.contact__c as contactid
	, active = case
		when c.actiondate is not null then 1
		else 0
	end
	, '6' as segment
	, '2' as recordtype
into #actionsegment6
from sources a
inner join actions b on b.contact__c = a.id
left join activists_new c on b.id = c.activityid
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*8 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*12;
-- select top 100 * from #actionsegment6;

--declare @segmentdaycount int;
--set @segmentdaycount = 91;
-- 1,450,966
if (object_id('tempdb..#actionsegment7') is not null) begin drop table #actionsegment7 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, '' as amount
	, a.JoinedDate
	, b.date_of_action__c as recorddate
	, b.contact__c as contactid
	, active = case
		when c.actiondate is not null then 1
		else 0
	end
	, '7' as segment
	, '2' as recordtype
into #actionsegment7
from sources a
inner join actions b on b.contact__c = a.id
left join activists_new c on b.id = c.activityid
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*12;
-- select top 100 * from #actionsegment7;

-- 8,683,246
select * from #actionsegment1
union all
select * from #actionsegment2
union all
select * from #actionsegment3
union all
select * from #actionsegment4
union all
select * from #actionsegment5
union all
select * from #actionsegment6
union all
select * from #actionsegment7
--order by firstactive desc, segment, channel, type;
order by segment, channel, type;

set nocount off