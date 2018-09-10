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
	, actiondate
into #segment1 
from source_actions
where actiondate >= dateadd(day,-@segmentdaycount,getdate());
-- select * from #segment1 order by actiondate;

-- last 91 to 182 days
if (object_id('tempdb..#segment2') is not null) begin drop table #segment2 end;
select id
	, contactid
	, actiondate
into #segment2 
from source_actions
where actiondate >= dateadd(day,-@segmentdaycount*2,getdate())
	and actiondate < dateadd(day,-@segmentdaycount,getdate());
-- select * from #segment2 order by actiondate;

-- last 183 to 273 days
if (object_id('tempdb..#segment3') is not null) begin drop table #segment3 end;
select id
	, contactid
	, actiondate
into #segment3 
from source_actions
where actiondate >= dateadd(day,-@segmentdaycount*3,getdate())
	and actiondate < dateadd(day,-@segmentdaycount*2,getdate());
-- select * from #segment3 order by actiondate;

-- last 274 to 364 days
if (object_id('tempdb..#segment4') is not null) begin drop table #segment4 end;
select id
	, contactid
	, actiondate
into #segment4 
from source_actions
where actiondate >= dateadd(day,-@segmentdaycount*4,getdate())
	and actiondate < dateadd(day,-@segmentdaycount*3,getdate());
-- select * from #segment4 order by actiondate;

-- last 365 to 730 days
if (object_id('tempdb..#segment5') is not null) begin drop table #segment5 end;
select id
	, contactid
	, actiondate
into #segment5 
from source_actions
where actiondate >= dateadd(day,-@segmentdaycount*8,getdate())
	and actiondate < dateadd(day,-@segmentdaycount*4,getdate());
-- select * from #segment5 order by actiondate;

-- last 731 to 1,095 days
if (object_id('tempdb..#segment6') is not null) begin drop table #segment6 end;
select id
	, contactid
	, actiondate
into #segment6 
from source_actions
where actiondate >= dateadd(day,-@segmentdaycount*8,getdate())
	and actiondate < dateadd(day,-@segmentdaycount*4,getdate());
-- select * from #segment6 order by actiondate;

-- last 731 to 1,095 days
if (object_id('tempdb..#segment7') is not null) begin drop table #segment7 end;
select id
	, contactid
	, actiondate
into #segment7 
from source_actions
where actiondate < dateadd(day,-@segmentdaycount*8,getdate());
-- select * from #segment7 order by actiondate desc;

-- within the last year
if (object_id('tempdb..#segment8') is not null) begin drop table #segment8 end;
select id
	, contactid
	, actiondate
into #segment8
from source_actions
where actiondate >= dateadd(day,-365,getdate());
-- select * from #segment8 order by actiondate desc;

set nocount off