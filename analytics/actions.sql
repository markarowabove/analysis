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

