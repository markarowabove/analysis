use fww;

set nocount on

/***************** NEW ACTIVISTS *************/
if object_id('dbo.activists_new','U') is not null
	drop table activists_new;
create table activists_new (
	contactid nvarchar(18) not null
	, activityid nvarchar(18) not null
	, actiondate date not null
);
insert into activists_new (contactid, activityid, actiondate) 
-- 1,087,535
select a.contact__c
	, a.id
	, a.date_of_action__c
from actions a 
inner join
(
	select contact__c
		, min(date_of_action__c) as firstaction 
	from actions 
	where contact__c != ''
	group by contact__c -- 1,048,412
) b
on b.contact__c = a.contact__c
where b.firstaction = a.date_of_action__c
	and b.contact__c != '';
/*****
select Contact__c
	, min(Date_Of_Action__C)
from actions 
where Date_Of_Action__C is not null
group by Contact__c;
****/

-- remove duplicate records with the same contact id and gift date
-- 39,123
with cte as (
	select contactid
		, actiondate
		, row_number() over(partition by contactid, actiondate order by activityid) as rn
	from activists_new
)
--select * from cte where rn > 1;
delete cte where rn > 1;

-- select count(*) from activists_new;
-- select * from activists_new order by actiondate;
-- select * from actions where date_of_action__c is null;
/*** check duplicates
select contactId, count(*)
from activists_new
group by contactId
having (count(*) > 1);
****/
set nocount off




