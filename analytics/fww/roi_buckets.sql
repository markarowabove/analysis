use fww;

set nocount on

-- segment variables
declare @begindate date
declare @enddate date
declare @segmentcountmax int
declare @segmentcount int
declare @segmentdays int
declare @segmentnumberbegin int
declare @segmentnumberend int
declare @segmentotaldays int

set @segmentdays = 91; -- 365 days / 4 = 91.25

/****************** change these two values for each run ************/
-- use this to set the max @segmentnumberbegin value for the 36 months and greater run
-- select (year(getdate()) - min(year(closedate)))*4 from opportunities; (2018-2007)*4=44
--select (datediff(day,dateadd(yy,datediff(yy,0,getdate()),0),getdate()))/91;
-- select min(closedate) from opportunities; -- 2007-01-09
-- set @segmentnumberbegin = 47; -- maximum for 36+ run
set @segmentnumberbegin = 4;
set @segmentnumberend = 0;

set @segmentotaldays = @segmentdays*(@segmentnumberbegin-@segmentnumberend);
set @begindate = format(dateadd(day,-@segmentdays*@segmentnumberbegin,getdate()),'yyyy-MM-dd');
set @enddate = format(dateadd(day,-@segmentdays*@segmentnumberend,getdate()),'yyyy-MM-dd');

/*********** ACTION SEGMENTS ***********/
-- segments
-- segment6 - 36 months	    segment5 - 24 months	segment4 - 9 to 12 months	segment3 - 6 to 9 months	segment2 - 3 to 6 months	segment1 - 0 to 3 months	today
-- 2015-09-14 13:44:57.463	2016-09-12 13:44:57.463	2017-09-11 13:44:57.463	    2017-12-11 13:44:57.463	    2018-03-12 13:44:57.463	    2018-06-11 13:44:57.463	    2018-09-10 13:44:57.463
-- select dateadd(day,-@segmentdays*12,getdate()) as "segment6 - 36 months", dateadd(day,-@segmentdays*8,getdate()) as "segment5 - 24 months",dateadd(day,-@segmentdays*4,getdate()) as "segment4 - 9 to 12 months", dateadd(day,-@segmentdays*3,getdate()) as "segment3 - 6 to 9 months", dateadd(day,-@segmentdays*2,getdate()) as "segment2 - 3 to 6 months", dateadd(day,-@segmentdays,getdate()) as "segment1 - 0 to 3 months", getdate() as today;
--print N',' + rtrim(dateadd(day,-@segmentdays*12,getdate())) + ' to ' + rtrim(dateadd(day,-@segmentdays*8-1,getdate())) + ',' + rtrim(dateadd(day,-@segmentdays*8,getdate())) + ' to ' + rtrim(dateadd(day,-@segmentdays*4-1,getdate())) + ',' + rtrim(dateadd(day,-@segmentdays*4,getdate())) + ' to ' + rtrim(dateadd(day,-@segmentdays*3-1,getdate())) + ',' + rtrim(dateadd(day,-@segmentdays*3,getdate())) + ' to ' + rtrim(dateadd(day,-@segmentdays*2-1,getdate())) + ',' + rtrim(dateadd(day,-@segmentdays*2,getdate())) + ' to ' + rtrim(dateadd(day,-@segmentdays-1,getdate())) + ',' + rtrim(dateadd(day,-@segmentdays,getdate())) + ' to ' + rtrim(@enddate);

print N',Segment Date Range: ' + cast(@begindate as nvarchar(12)) + ' to ' + cast(@enddate as nvarchar(12)) + ',,Total number of days: ' + cast(@segmentotaldays as nvarchar(10));
print N',,,';
print N'Row,Source Channel,Source Type,Amount';

declare @channel nvarchar(255)
declare @type nvarchar(255)
declare @amount nvarchar(255)
declare @deltadays nvarchar(255)

DECLARE db_cursor CURSOR FOR
select channel
	, type
	, amount
	, deltadays 
from opportunities_delta 
where 1 = 1
	and deltadays >= @segmentnumberend*@segmentdays
	and deltadays <  @segmentnumberbegin*@segmentdays
	and deltadays > 0
order by channel, type, amount;
	--and deltadays >= 0
	--and deltadays < 91 -- 269,989
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @channel, @type, @amount, @deltadays

declare @rownum int = 0
WHILE @@FETCH_STATUS = 0
BEGIN

	set @rownum = @rownum + 1
	print cast(@rownum as nvarchar(10)) + ',' + @channel + ',' + @type + ',' + cast(@amount as nvarchar(18));
	FETCH NEXT FROM db_cursor INTO @channel, @type, @amount, @deltadays
	

END
CLOSE db_cursor
DEALLOCATE db_cursor

set nocount off