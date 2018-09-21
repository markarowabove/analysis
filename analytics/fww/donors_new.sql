use fww;

set nocount on

/***************** FIRST GIFT DATE *************/
if object_id('dbo.donors_new','U') is not null
	drop table donors_new;
create table donors_new (
	contactid nvarchar(18) not null
	, opportunityid nvarchar(18) not null
	, giftdate date not null
);
insert into donors_new (contactid, opportunityid, giftdate) 
/*****
select npsp__Primary_Contact__c as contactid
	, min(closedate) as giftdate
from opportunities 
where npsp__Primary_Contact__c != ''
group by npsp__Primary_Contact__c
*****/
select a.npsp__Primary_Contact__c as contactid
	, a.Id as opportunityid
	, a.closedate as firstgiftdate
from opportunities a 
inner join
(
	select npsp__Primary_Contact__c
		, min(closedate) as firstgift 
	from opportunities 
	where npsp__Primary_Contact__c != ''
	group by npsp__Primary_Contact__c -- 279,030
) b
on b.npsp__Primary_Contact__c = a.npsp__Primary_Contact__c
where b.firstgift = a.closedate
	and b.npsp__Primary_Contact__c != ''; -- 280,122
--order by npsp__Primary_Contact__c, Id, closedate;

-- select * from donors_new order by contactid, giftdate; -- 279,030
-- select * from donors_new where contactid = '0036A00000MyOCbQAN';
-- select * from donors_new where opportunityid = '0066A000007PF3hQAG';

-- remove duplicate records with the same contact id and gift date
with cte as (
	select contactid
		, giftdate
		, row_number() over(partition by contactid, giftdate order by opportunityid) as rn
	from donors_new
)
--select * from cte where rn > 1 and contactid = '0036A00000MyOCbQAN';
delete cte where rn > 1;

-- select count(*) from donors_new; - 279,030

/*** check duplicates
select contactId, count(*)
from donors_new
group by contactId
having (count(*) > 1);
****/
set nocount off




