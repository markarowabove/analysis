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
if (object_id('tempdb..#contactsegment1') is not null) begin drop table #contactsegment1 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, '' as amount
	, a.joineddate
	, a.Email_Opt_Out_Date__c as recorddate
	, a.id as contactid
	, '1' as active
	, '1' as segment
	, '3' as recordtype
into #contactsegment1 
from sources a
where a.Email_Opt_Out_Date__c != ''
	and datediff(day,a.joineddate,@startdate) <= @segmentdaycount;
-- select count(*) from #contactsegment1; -- 340,595
-- select top 100 * from #contactsegment1;
--select * from #contactsegment1 where channel = 'Distributed Organizing' and type = 'Relay' order by amount, contactid, recorddate, active;
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

--declare @segmentdaycount int
--set @segmentdaycount = 91; -- 365 days / 4 = 91.25
-- last 3 - 6 months
if (object_id('tempdb..#contactsegment2') is not null) begin drop table #contactsegment2 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, '' as amount
	, a.joineddate
	, a.Email_Opt_Out_Date__c as recorddate
	, a.id as contactid
	, '1' as active
	, '2' as segment
	, '3' as recordtype
into #contactsegment2 
from sources a
where a.Email_Opt_Out_Date__c != ''
	and datediff(day,a.joineddate,@startdate) > @segmentdaycount and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*2;
-- select count(*) from #contactsegment2; -- 84,801
-- select top 100 * from #contactsegment2;

--declare @segmentdaycount int
--set @segmentdaycount = 91; -- 365 days / 4 = 91.25
-- last 6 - 9 months
if (object_id('tempdb..#contactsegment3') is not null) begin drop table #contactsegment3 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, '' as amount
	, a.joineddate
	, a.Email_Opt_Out_Date__c as recorddate
	, a.id as contactid
	, '1' as active
	, '3' as segment
	, '3' as recordtype
into #contactsegment3 
from sources a
where a.Email_Opt_Out_Date__c != ''
	and datediff(day,a.joineddate,@startdate) > @segmentdaycount*2 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*3;
-- select count(*) from #contactsegment3; -- 51,152
-- select top 100 * from #contactsegmen3;

--declare @segmentdaycount int
--set @segmentdaycount = 91; -- 365 days / 4 = 91.25
-- last 9 - 12 months
if (object_id('tempdb..#contactsegment4') is not null) begin drop table #contactsegment4 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, '' as amount
	, a.joineddate
	, a.Email_Opt_Out_Date__c as recorddate
	, a.id as contactid
	, '1' as active
	, '4' as segment
	, '3' as recordtype
into #contactsegment4 
from sources a
where a.Email_Opt_Out_Date__c != ''
	and datediff(day,a.joineddate,@startdate) > @segmentdaycount*3 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*4;
-- select count(*) from #contactsegment4; -- 42,962
-- select top 100 * from #contactsegmen4;

--declare @segmentdaycount int
--set @segmentdaycount = 91; -- 365 days / 4 = 91.25
-- last 12 - 24 months
if (object_id('tempdb..#contactsegment5') is not null) begin drop table #contactsegment5 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, '' as amount
	, a.joineddate
	, a.Email_Opt_Out_Date__c as recorddate
	, a.id as contactid
	, '1' as active
	, '5' as segment
	, '3' as recordtype
into #contactsegment5 
from sources a
where a.Email_Opt_Out_Date__c != ''
	and datediff(day,a.joineddate,@startdate) > @segmentdaycount*4 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*8;
-- select count(*) from #contactsegment5; -- 117,507
-- select top 100 * from #contactsegment5;

--declare @segmentdaycount int
--set @segmentdaycount = 91; -- 365 days / 4 = 91.25
-- last 24 - 36 months
if (object_id('tempdb..#contactsegment6') is not null) begin drop table #contactsegment6 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, '' as amount
	, a.joineddate
	, a.Email_Opt_Out_Date__c as recorddate
	, a.id as contactid
	, '1' as active
	, '6' as segment
	, '3' as recordtype
into #contactsegment6 
from sources a
where a.Email_Opt_Out_Date__c != ''
	and datediff(day,a.joineddate,@startdate) > @segmentdaycount*8 and datediff(day,a.joineddate,@startdate) <= @segmentdaycount*12;
-- select count(*) from #contactsegment6; -- 73,902
-- select top 100 * from #contactsegment6;

--declare @segmentdaycount int
--set @segmentdaycount = 91; -- 365 days / 4 = 91.25
-- last 36+ months
if (object_id('tempdb..#contactsegment7') is not null) begin drop table #contactsegment7 end;
select a.Origin_Source_Code_Channel__c as channel
	, a.Origin_Source_Code_Type__c as type
	, '' as amount
	, a.joineddate
	, a.Email_Opt_Out_Date__c as recorddate
	, a.id as contactid
	, '1' as active
	, '7' as segment
	, '3' as recordtype
into #contactsegment7 
from sources a
where a.Email_Opt_Out_Date__c != ''
	and datediff(day,a.joineddate,@startdate) > @segmentdaycount*12;
-- select count(*) from #contactsegment7; -- 118,214
-- select top 100 * from #contactsegment7;

select * from #contactsegment1
union all
select * from #contactsegment2
union all
select * from #contactsegment3
union all
select * from #contactsegment4
union all
select * from #contactsegment5
union all
select * from #contactsegment6
union all
select * from #contactsegment7
--order by firstactive desc, segment, channel, type;
order by segment, channel, type;

set nocount off