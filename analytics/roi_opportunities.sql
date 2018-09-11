use fww;
set nocount on

-- count variables
declare @segmentcountmax int
declare @segmentcount int
declare @segmentdaycount int

/*********** OPPORTUNITIES SEGMENTS ***********/
set @segmentdaycount = 91; -- 365 days / 4 = 91.25
-- segments
-- 2017-09-14, 2017-12-13, 2018-03-13, 2018-06-11, 2018-09-09
-- select dateadd(day,-@segmentdaycount*12,getdate()) as "segment6 - 36 months", dateadd(day,-@segmentdaycount*8,getdate()) as "segment5 - 24 months",dateadd(day,-@segmentdaycount*4,getdate()) as "segment4 - 9 to 12 months", dateadd(day,-@segmentdaycount*3,getdate()) as "segment3 - 6 to 9 months", dateadd(day,-@segmentdaycount*2,getdate()) as "segment2 - 3 to 6 months", dateadd(day,-@segmentdaycount,getdate()) as "segment1 - 0 to 3 months", getdate() as today;

-- last 0 to 91 days - 3 months
if (object_id('tempdb..#segment1') is not null) begin drop table #segment1 end;
select a.id
	, a.opportunityid
	, a.channel
	, a.type
	, a.amount
into #segment1 
from opportunities_delta a
where deltadays <= @segmentdaycount;
-- select * from #segment1;

-- last 91 to 182 days - 3 to 6 months
if (object_id('tempdb..#segment2') is not null) begin drop table #segment2 end;
select a.id
	, a.opportunityid
	, a.channel
	, a.type
	, a.amount
into #segment2 
from opportunities_delta a
where deltadays > @segmentdaycount and deltadays <= @segmentdaycount*2;
-- select * from #segment2;

-- last 183 to 273 days - 6 to 9 months
if (object_id('tempdb..#segment3') is not null) begin drop table #segment3 end;
select a.id
	, a.opportunityid
	, a.channel
	, a.type
	, a.amount
into #segment3 
from opportunities_delta a
where deltadays > @segmentdaycount*2 and deltadays <= @segmentdaycount*3;
-- select * from #segment3;

-- last 274 to 364 days - 9 to 12 months
if (object_id('tempdb..#segment4') is not null) begin drop table #segment4 end;
select a.id
	, a.opportunityid
	, a.channel
	, a.type
	, a.amount
into #segment4 
from opportunities_delta a
where deltadays > @segmentdaycount*3 and deltadays <= @segmentdaycount*4;
-- select * from #segment4 order by joineddate;

-- last 365 to 730 days - 12 to 24 months
if (object_id('tempdb..#segment5') is not null) begin drop table #segment5 end;
select a.id
	, a.opportunityid
	, a.channel
	, a.type
	, a.amount
into #segment5
from opportunities_delta a
where deltadays > @segmentdaycount*4 and deltadays <= @segmentdaycount*8;
-- select * from #segment5 order by joineddate;

-- last 731 to 1,095 days - 24 to 36 months
if (object_id('tempdb..#segment6') is not null) begin drop table #segment6 end;
select a.id
	, a.opportunityid
	, a.channel
	, a.type
	, a.amount
into #segment6
from opportunities_delta a
where deltadays > @segmentdaycount*8 and deltadays <= @segmentdaycount*12;
-- select * from #segment6 order by joineddate;

-- over 1,095 - over 36 months
if (object_id('tempdb..#segment7') is not null) begin drop table #segment7 end;
select a.id
	, a.opportunityid
	, a.channel
	, a.type
	, a.amount
into #segment7 
from opportunities_delta a
where deltadays > @segmentdaycount*12;
-- select * from #segment7 order by id;

-- within the last year
if (object_id('tempdb..#segment8') is not null) begin drop table #segment8 end;
select a.id
	, a.opportunityid
	, a.channel
	, a.type
	, a.amount
into #segment8 
from opportunities_delta a
where deltadays <= 365;
-- select * from #segment8 order by id;

set nocount off
