use fww;

set nocount on

-- date segment variables
declare @begindate date
declare @enddate date

set @begindate = '2012-01-01';
set @enddate = getdate();

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

print N'Segment Date Ranges,,,,,,';
print N',6,5,4,3,2,1';
print N',' + rtrim(dateadd(day,-@segmentdaycount*12,getdate())) + ' to ' + rtrim(dateadd(day,-@segmentdaycount*8-1,getdate())) + ',' + rtrim(dateadd(day,-@segmentdaycount*8,getdate())) + ' to ' + rtrim(dateadd(day,-@segmentdaycount*4-1,getdate())) + ',' + rtrim(dateadd(day,-@segmentdaycount*4,getdate())) + ' to ' + rtrim(dateadd(day,-@segmentdaycount*3-1,getdate())) + ',' + rtrim(dateadd(day,-@segmentdaycount*3,getdate())) + ' to ' + rtrim(dateadd(day,-@segmentdaycount*2-1,getdate())) + ',' + rtrim(dateadd(day,-@segmentdaycount*2,getdate())) + ' to ' + rtrim(dateadd(day,-@segmentdaycount-1,getdate())) + ',' + rtrim(dateadd(day,-@segmentdaycount,getdate())) + ' to ' + rtrim(@enddate);
