use fww;

set nocount on

declare @segmentdaycount int
declare @startdate date

set @startdate = getdate()
set @segmentdaycount = 91; -- 365 days / 4 = 91.25

/*********** CONTACTS SEGMENTS ***********/
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
if (object_id('tempdb..#cohortsegment1') is not null) begin drop table #cohortsegment1 end;
select a.id as contactid
	, a.joineddate
	, '1' as segment
into #cohortsegment1 
from sources a
where datediff(day,a.joineddate,@startdate) <= @segmentdaycount;
-- select count(*) from #cohortsegment1; -- 47,248

--declare @segmentdaycount int
--set @segmentdaycount = 91; -- 365 days / 4 = 91.25
-- last 3 - 6 months
if (object_id('tempdb..#cohortsegment2') is not null) begin drop table #cohortsegment2 end;
select a.id as contactid
	, a.joineddate
	, '2' as segment
into #cohortsegment2 
from sources a
where datediff(day,a.joineddate,@startdate) > @segmentdaycount and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*2;
-- select count(*) from #cohortsegment2; -- 84,801
-- select top 100 * from #cohortsegment2;

--declare @segmentdaycount int
--set @segmentdaycount = 91; -- 365 days / 4 = 91.25
-- last 6 - 9 months
if (object_id('tempdb..#cohortsegment3') is not null) begin drop table #cohortsegment3 end;
select a.id as contactid
	, a.joineddate
	, '3' as segment
into #cohortsegment3 
from sources a
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*2 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*3;
-- select count(*) from #cohortsegment3; -- 51,152
-- select top 100 * from #contactsegmen3;

--declare @segmentdaycount int
--set @segmentdaycount = 91; -- 365 days / 4 = 91.25
-- last 9 - 12 months
if (object_id('tempdb..#cohortsegment4') is not null) begin drop table #cohortsegment4 end;
select a.id as contactid
	, a.joineddate
	, '4' as segment
into #cohortsegment4 
from sources a
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*3 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*4;
-- select count(*) from #cohortsegment4; -- 42,962
-- select top 100 * from #contactsegmen4;

--declare @segmentdaycount int
--set @segmentdaycount = 91; -- 365 days / 4 = 91.25
-- last 12 - 24 months
if (object_id('tempdb..#cohortsegment5') is not null) begin drop table #cohortsegment5 end;
select a.id as contactid
	, a.joineddate
	, '5' as segment
into #cohortsegment5 
from sources a
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*4 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*8;
-- select count(*) from #cohortsegment5; -- 117,507
-- select top 100 * from #cohortsegment5;

--declare @segmentdaycount int
--set @segmentdaycount = 91; -- 365 days / 4 = 91.25
-- last 24 - 36 months
if (object_id('tempdb..#cohortsegment6') is not null) begin drop table #cohortsegment6 end;
select a.id as contactid
	, a.joineddate
	, '6' as segment
into #cohortsegment6 
from sources a
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*8 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*12;
-- select count(*) from #cohortsegment6; -- 73,902
-- select top 100 * from #cohortsegment6;

--declare @segmentdaycount int
--set @segmentdaycount = 91; -- 365 days / 4 = 91.25
-- last 36+ months
if (object_id('tempdb..#cohortsegment7') is not null) begin drop table #cohortsegment7 end;
select a.id as contactid
	, a.joineddate
	, '7' as segment
into #cohortsegment7 
from sources a
where datediff(day,a.joineddate,@startdate) > @segmentdaycount*12;
-- select count(*) from #cohortsegment7; -- 118,214
-- select top 100 * from #cohortsegment7;

-- 2,545,404
if object_id('dbo.cohorts','U') is not null
	drop table cohorts;
create table cohorts (
	contactid nvarchar(18) not null
	, joineddate date not null
	, segment int
);
insert into cohorts (contactid, joineddate, segment) 
select * from #cohortsegment1
union
select * from #cohortsegment2
union
select * from #cohortsegment3
union
select * from #cohortsegment4
union
select * from #cohortsegment5
union
select * from #cohortsegment6
union
select * from #cohortsegment7;
--order by segment;

/******
-- calc total summary per segment
select segment, count(*) as segmentcount
from cohorts 
group by segment
order by segment;

-- check for dupes -- there should be NONE
select contactid, count(*)
from cohorts
group by contactid
having (count(*) > 1);
****/

set nocount off