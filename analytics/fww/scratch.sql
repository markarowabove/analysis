use fww;

set nocount on

/***************** DONATIONS *************/
if object_id('dbo.donations','U') is not null
	drop table donations;
create table donations (
	id int identity(1,1) not null
	, channel nvarchar(255) not null
	, type nvarchar(255) not null
	, months_3 float not null
	, months_6 float not null
	, months_9 float not null
	, months_12 float not null
	, months_36 float not null
	, months_36_plus float not null
	, months_all float not null
	, months_year float not null
);
insert into donations (channel, type, months_3, months_6, months_9, months_12, months_36, months_36_plus, months_all, months_year)
select origin_source_code_channel__c 
	, origin_source_code_type__c
	, ------------------ STOPPED HERE -----------------
from sources

set nocount off