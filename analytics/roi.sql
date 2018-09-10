use fww;
set nocount on

-- count variables
declare @segmentcountmax int
declare @segmentcount int
declare @segmentdaycount int



/*********** DONATION SEGMENTS ***********/
set @segmentdaycount = 90;
-- segments
-- 2017-09-14, 2017-12-13, 2018-03-13, 2018-06-11, 2018-09-09
--select dateadd(day,-@segmentdaycount*4,getdate()), dateadd(day,-@segmentdaycount*3,getdate()), dateadd(day,-@segmentdaycount*2,getdate()), dateadd(day,-@segmentdaycount,getdate()), getdate();

if (object_id('tempdb..#segment1') is not null) begin drop table #segment1 end;
select id
	, channel
	, type
	, joineddate
	, amount
into #segment1 
from source_donations
where joineddate >= dateadd(day,-@segmentdaycount,getdate());
-- select * from #segment1;

if (object_id('tempdb..#segment2') is not null) begin drop table #segment2 end;
select id
	, channel
	, type
	, joineddate
	, amount
into #segment2 
from source_donations
where joineddate >= dateadd(day,-@segmentdaycount*2,getdate())
	and joineddate < dateadd(day,-@segmentdaycount,getdate());
-- select * from #segment2;

if (object_id('tempdb..#segment3') is not null) begin drop table #segment3 end;
select id
	, channel
	, type
	, joineddate
	, amount
into #segment3 
from source_donations
where joineddate >= dateadd(day,-@segmentdaycount*3,getdate())
	and joineddate < dateadd(day,-@segmentdaycount*2,getdate());
-- select * from #segment3;

if (object_id('tempdb..#segment4') is not null) begin drop table #segment4 end;
select id
	, channel
	, type
	, joineddate
	, amount
into #segment4 
from source_donations
where joineddate >= dateadd(day,-@segmentdaycount*4,getdate())
	and joineddate < dateadd(day,-@segmentdaycount*3,getdate());
-- select * from #segment4 order by joineddate;


set nocount off
