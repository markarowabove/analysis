use fww;

-- update queries
alter table actions alter column Date_of_Action__c date;
update actions set Date_of_Action__c = null where Date_of_Action__c = '1900-01-01';

select count(*) from actions; -- 8683247
select count(*) from actions where Date_of_Action__c is not null; -- 8683246

-- dupe check
select id, count(*) as dupes
from actions
group by id
having (count(*) > 1);

/***************** ACTIONS *************/
if object_id('dbo.actions_delta','U') is not null
	drop table actions_delta;
select a.id
	, a.Contact__c as contactid
	, deltadays = case 
		when b.joineddate < a.Date_of_Action__c then datediff(day,b.joineddate,a.Date_of_Action__c)
		else 0
	end
	into actions_delta
from actions a
inner join sources b on a.Contact__c = b.id
where 1 = 1
	and a.Date_of_Action__c is not null
	and a.Contact__c is not null
order by a.id;
-- select count(*) from actions_delta; -- 10,436,915
-- select top 1000 * from actions_delta order by contactid; 



