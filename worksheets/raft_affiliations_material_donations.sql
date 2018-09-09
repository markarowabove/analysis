-- material donation affiliations
use raftdb2den;

if (object_id('tempdb..#contacts') is not null) begin drop table #contacts end;
select distinct a.nameId as id into #contacts
from materialdonation a;

select distinct a.id, b.orgId
from #contacts a
inner join materialdonation b on a.id = b.nameId
where 1 = 1
	and b.orgId is not null
order by a.id;

-- dump material donation affiliations
select distinct a.id as RaftDb2Id_Contact__c
	, b.orgId as RaftDb2Id_Organization__c
	, concat(a.id,b.orgId) as Raft_Db2_Compound_Id__c
	, 'Material Donor' as npe5__Role__c
	, 'Import 2018-08-23' as Import_Tag__c
	, '005f4000001o3c8AAA' as OwnerId
from #contacts a
inner join materialdonation b on a.id = b.nameId
where 1 = 1
	and b.orgId is not null
order by a.id;