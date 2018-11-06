use raft;

-- list multiple aff orgs
select npe5__Organization__c, count(*)
from raft_affiliations
where npe5__Primary__c = 1
group by npe5__Organization__c
having (count(*) > 1)
order by count(*) desc;

-- list dupe contacts
select npe5__Contact__c, count(*)
from raft_affiliations
--where npe5__Primary__c = 1
group by npe5__Contact__c
having (count(*) > 1);

-- get single affiliations
if (object_id('tempdb..#affprimary') is not null) begin drop table #affprimary end;
select Id, npe5__Contact__c as ContactId into #affprimary
from raft_affiliations
where npe5__Primary__c = 1
order by Id;
--select * from #affprimary order by Id;

/****** scenerio 1: contact has no primary affiliation and single affiliation is marked primary ****/
-- get list of unique contact ids with an affiliation
-- 584
if (object_id('tempdb..#affnone') is not null) begin drop table #affnone end;
select distinct a.Id into #affnone
from raft_contacts a
inner join raft_affiliations b on a.Id = b.npe5__Contact__c
where 1 = 1
	and a.npsp__Primary_Affiliation__c = ''
order by a.Id;
-- select Id from #affnone

select a.Id, b.npe5__Organization__c from raft_contacts a
inner join raft_affiliations b on a.Id = b.npe5__Contact__c
inner join #affprimary c on b.npe5__Contact__c = c.ContactId
where 1 = 1
	and a.npsp__Primary_Affiliation__c = ''
order by a.Id;