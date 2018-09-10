use fww;

-- update queries
alter table actions alter column Date_of_Action__c date;
update actions set Date_of_Action__c = null where Date_of_Action__c = '1900-01-01';

select count(*) from actions where Date_of_Action__c is not null;

-- dupe check
select id, count(*) as dupes
from actions
group by id
having (count(*) > 1);

/***************** ACTIONS *************/
if object_id('dbo.source_actions','U') is not null
	drop table source_actions;
select id
	, Contact__c as contactid
	, Date_of_Action__c as actiondate
	into source_actions
from actions
where 1 = 1
	and Date_of_Action__c is not null
	and Contact__c is not null
order by id; -- 8,683,246
-- select count(*) from source_actions; -- 8,683,246
-- select count(*) from actions; -- 8,683,247


