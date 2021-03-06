use raft;
-- select count(*) from raft_contacts;

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
where npe5__Primary__c = 1
group by npe5__Contact__c
having (count(*) > 1);

-- get primary affiliations
if (object_id('tempdb..#affprimary') is not null) begin drop table #affprimary end;
select Id, npe5__Contact__c as ContactId into #affprimary
from raft_affiliations
where npe5__Primary__c = 1
order by Id;
--select * from #affprimary order by Id;

/****** scenerio 1: find single affiliation not marked as primary ****/
if (object_id('tempdb..#affone') is not null) begin drop table #affone end;
select npe5__Contact__c as Id into #affone
from raft_affiliations
group by npe5__Contact__c
having (count(*) = 1)
order by Id;
-- select * from #affone order by Id;

-- get single affiliations that are not set as primary
if (object_id('tempdb..#affonenotprimary') is not null) begin drop table #affonenotprimary end;
select b.Id into #affonenotprimary
from #affone a
inner join raft_affiliations b on a.Id = b.npe5__Contact__c
where 1 = 1
	and b.npe5__Primary__c = 0
order by b.Id;
-- OUTPUT for dataloader
--select Id, '1' as npe5__Primary__c, 'Current' as npe5__Status__c from #affonenotprimary order by Id

-- get new tables from salesforce for this next run

/****** scenerio 2: find contact with no primary affilition but has multiple related affiliations ****/
-- 128
if (object_id('tempdb..#affnone') is not null) begin drop table #affnone end;
select distinct a.Id into #affnone
from raft_contacts a
inner join raft_affiliations b on a.Id = b.npe5__Contact__c
where 1 = 1
	and a.npsp__Primary_Affiliation__c = ''
order by a.Id;
-- select Id from #affnone order by Id

-- get primary affiliation for each contact without a Primary Affiliation on the Contact object
-- 115
-- OUTPUT for dataloader
select a.Id, b.npe5__Organization__c
from #affnone a
inner join raft_affiliations b on a.Id = b.npe5__Contact__c
inner join raft_contacts c on b.npe5__Contact__c = c.Id
where 1 = 1
	and c.npsp__Primary_Affiliation__c = ''
	and b.npe5__Primary__c = 1
order by a.Id;

-- find duplicate affiliations
if (object_id('tempdb..#affcontacts') is not null) begin drop table #affcontacts end;
select npe5__Contact__c as Id, count(*) as Count into #affcontacts
from raft_affiliations
group by npe5__Contact__c
having (count(*) = 3);
-- select * from #affcontacts order by Id;

if (object_id('tempdb..#afforgs') is not null) begin drop table #afforgs end;
select a.Id, a.npe5__Contact__c, a.npe5__Organization__c into #afforgs
from raft_affiliations a
inner join #affcontacts b on a.npe5__Contact__c = b.Id
where 1 = 1
	and a.npe5__Primary__c = 0
order by a.npe5__Contact__c;
-- select * from #afforgs order by npe5__Contact__c;

-- get duplicate contacts
select npe5__Contact__c, count(*)
from #afforgs
group by npe5__Contact__c
having (count(*) > 1);

-- get duplicate orgs
select npe5__Contact__c, npe5__Organization__c, count(*)
from #afforgs
group by npe5__Contact__c, npe5__Organization__c
having (count(*) > 1);