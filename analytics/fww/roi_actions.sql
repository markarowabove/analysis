use fww;
set nocount on

-- count variables
declare @segmentcountmax int
declare @segmentcount int
declare @segmentdaycount int

/*********** ACTION SEGMENTS ***********/
set @segmentdaycount = 91; -- 365 days / 4 = 91.25
-- segments
-- segment6 - 36 months	    segment5 - 24 months	segment4 - 9 to 12 months	segment3 - 6 to 9 months	segment2 - 3 to 6 months	segment1 - 0 to 3 months	today
-- 2015-09-14 13:44:57.463	2016-09-12 13:44:57.463	2017-09-11 13:44:57.463	    2017-12-11 13:44:57.463	    2018-03-12 13:44:57.463	    2018-06-11 13:44:57.463	    2018-09-10 13:44:57.463
-- select dateadd(day,-@segmentdaycount*12,getdate()) as "segment6 - 36 months", dateadd(day,-@segmentdaycount*8,getdate()) as "segment5 - 24 months",dateadd(day,-@segmentdaycount*4,getdate()) as "segment4 - 9 to 12 months", dateadd(day,-@segmentdaycount*3,getdate()) as "segment3 - 6 to 9 months", dateadd(day,-@segmentdaycount*2,getdate()) as "segment2 - 3 to 6 months", dateadd(day,-@segmentdaycount,getdate()) as "segment1 - 0 to 3 months", getdate() as today;

-- last 0 to 91 days
if (object_id('tempdb..#segment1') is not null) begin drop table #segment1 end;
select id
	, contactid
	, deltadays
into #segment1 
from actions_delta
where deltadays > 0 and deltadays <= @segmentdaycount;
-- select * from #segment1 order by deltadays;

-- last 91 to 182 days
if (object_id('tempdb..#segment2') is not null) begin drop table #segment2 end;
select id
	, contactid
	, deltadays
into #segment2 
from actions_delta
where deltadays > @segmentdaycount and deltadays <= @segmentdaycount*2;
-- select * from #segment2 order by deltadays;

-- last 183 to 273 days
if (object_id('tempdb..#segment3') is not null) begin drop table #segment3 end;
select id
	, contactid
	, deltadays
into #segment3 
from actions_delta
where deltadays > @segmentdaycount*2 and deltadays <= @segmentdaycount*3;
-- select * from #segment3 order by deltadays;

-- last 274 to 364 days
if (object_id('tempdb..#segment4') is not null) begin drop table #segment4 end;
select id
	, contactid
	, deltadays
into #segment4
from actions_delta
where deltadays > @segmentdaycount*3 and deltadays <= @segmentdaycount*4;
-- select * from #segment4 order by deltadays;

-- last 365 to 730 days
if (object_id('tempdb..#segment5') is not null) begin drop table #segment5 end;
select id
	, contactid
	, deltadays
into #segment5
from actions_delta
where deltadays > @segmentdaycount*4 and deltadays <= @segmentdaycount*8;
-- select * from #segment5 order by deltadays;

-- last 731 to 1,095 days
if (object_id('tempdb..#segment6') is not null) begin drop table #segment6 end;
select id
	, contactid
	, deltadays
into #segment6
from actions_delta
where deltadays > @segmentdaycount*8 and deltadays <= @segmentdaycount*12;
-- select * from #segment6 order by deltadays;

-- check for dupes in the buckets
select a.id from #segment1 a
inner join #segment2 b on a.id = b.id;
select a.id from #segment2 a
inner join #segment3 b on a.id = b.id;
select a.id from #segment3 a
inner join #segment4 b on a.id = b.id;
select a.id from #segment4 a
inner join #segment5 b on a.id = b.id;
select a.id from #segment5 a
inner join #segment6 b on a.id = b.id;

select id from #segment1
union
select id from #segment2
union
select id from #segment3
union 
select id from #segment4
union
select id from #segment5
union
select id from #segment6
order by id; -- 6,673,415

select id from #segment1
union all
select id from #segment2
union all
select id from #segment3
union all
select id from #segment4
union all
select id from #segment5
union all
select id from #segment6
order by id; -- 6,673,415

select count(*) from #segment1;
select count(*) from #segment2;
select count(*) from #segment3;
select count(*) from #segment4;
select count(*) from #segment5;
select count(*) from #segment6;

set nocount off
