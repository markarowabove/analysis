use fww;

set nocount on

/***************** NEW ACTIVISTS *************/
if object_id('dbo.activists_new','U') is not null
	drop table activists_new;
create table activists_new (
	id int identity(1,1) not null
	, actiondate date not null
	, contactId nvarchar(18) not null
);
insert into activists_new (contactId, actiondate) 
select Contact__c
	, min(Date_Of_Action__C)
from actions 
where Date_Of_Action__C is not null
group by Contact__c;
-- select * from activists_new order by actiondate;
-- select * from actions where date_of_action__c is null;
/*** check duplicates
select contactId, count(*)
from activists_new
group by contactId
having (count(*) > 1);
****/
set nocount off




